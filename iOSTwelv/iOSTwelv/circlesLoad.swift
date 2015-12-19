//
//  circlesLoad.swift
//  iOSTwelv
//
//  Created by Lucas Bullen on 2015-11-08.
//  Copyright © 2015 Lucas Bullen. All rights reserved.
//

import Foundation
import UIKit

extension ViewController{
    /*gives a view and a list of friends and fills this view with friends
    *
    */
    func fillWithUsers (view:UIScrollView, users:NSDictionary, function_name:Selector?, event_id:String){
        var x = 0
        for user in users{
            let canFitAccross = Int(view.frame.width) - (70 % Int(view.frame.width)) / 70
            let row: Int = (x - (x % canFitAccross)) / canFitAccross
            let slot: Int = x % canFitAccross
            
            let button = UIButton(type: UIButtonType.System) as UIButton
            button.frame = CGRectMake(CGFloat((slot * 58)+12),CGFloat((row * 58)+12), CGFloat(46), CGFloat(46))
            button.setTitle(users.allKeys[x] as? String, forState: .Normal)
            button.setTitleColor(UIColor.blackColor().colorWithAlphaComponent(0), forState: .Normal)
            //load image
            button.setBackgroundImage(Load().image(user.key as! String), forState: UIControlState.Normal)
            
            button.layer.cornerRadius = 0.5 * button.bounds.size.width
            button.clipsToBounds = true
            button.layer.borderWidth = 2
            //set border colour
            if event_id != "nil"{
                let relations = accessPlist().user_event_rel_get()
                forloop: for relation in relations!{
                    if relation.objectForKey("event_id") as? String == event_id && relation.objectForKey("user_id") as? String == user.key as? String{
                        let statusStr: String = relation.objectForKey("status") as! String;
                        print(statusStr)
                        let statusInt: Int = Int(statusStr)!;
                        print(statusInt)
                        switch statusInt{
                        case 1:
                            button.layer.borderColor = UIColor.greenColor().CGColor
                        case 2:
                            button.layer.borderColor = UIColor.redColor().CGColor
                        default:
                            break
                        }
                        break forloop
                    }
                }
            }
            
            if function_name != nil{
                button.addTarget(self, action: function_name!, forControlEvents: UIControlEvents.TouchUpInside)
            }
            view.contentSize.height = CGFloat(row * 70)
            view.addSubview(button)
            x++
        }
    }
    func fillWithUsers (view:UIView, users:NSDictionary, function_name:Selector?, event_id:String){
        var x = 0
        view.clipsToBounds = true;
        for user in users{
            let canFitAccross = Int(view.frame.width) - (70 % Int(view.frame.width)) / 70
            let row: Int = (x - (x % canFitAccross)) / canFitAccross
            let slot: Int = x % canFitAccross
            
            let button = UIButton(type: UIButtonType.System) as UIButton
            button.frame = CGRectMake(CGFloat((slot * 58)+12),CGFloat((row * 58)+12), CGFloat(46), CGFloat(46))
            button.setTitle(users.allKeys[x] as? String, forState: .Normal)
            button.setTitleColor(UIColor.blackColor().colorWithAlphaComponent(0), forState: .Normal)
            //load image
            button.setBackgroundImage(Load().image(user.key as! String), forState: UIControlState.Normal)
            
            //set border colour
            if event_id != "nil"{
                let relations = accessPlist().user_event_rel_get()
                forloop: for relation in relations!{
                    if relation.objectForKey("event_id") as? String == event_id && relation.objectForKey("user_id") as? String == user.key as? String{
                        let statusStr: String = relation.objectForKey("status") as! String;
                        print(statusStr)
                        let statusInt: Int = Int(statusStr)!;
                        print(statusInt)
                        switch statusInt{
                        case 1:
                            button.layer.borderColor = UIColor.greenColor().CGColor
                        case 2:
                            button.layer.borderColor = UIColor.redColor().CGColor
                        default:
                            break
                        }
                        break forloop
                    }
                }
            }
            
            button.layer.cornerRadius = 0.5 * button.bounds.size.width
            button.clipsToBounds = true
            button.layer.borderWidth = 2
            if function_name != nil{
                button.addTarget(self, action: function_name!, forControlEvents: UIControlEvents.TouchUpInside)
            }
            view.addSubview(button)
            x++
        }
    }
    func fillWithEvents(view:UIView, events:NSDictionary, function_name:Selector?){
        //sort events
        //ordered array by time of event objects with added id key
        var eventsDict: [String:[[String: String]]]=["01":[],"02":[],"03":[],"04":[],"05":[],"06":[],"07":[],"08":[],"09":[],"10":[],"11":[],"12":[]]
        for event in events{
            //find out how old an event is
            let formatter = NSDateFormatter()
            formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
            formatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
            
            let minutesFormatter = NSDateFormatter()
            minutesFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
            minutesFormatter.dateFormat = "mm"
            
            let date = formatter.dateFromString(event.value["start_time"] as! String)!
            let minutes = minutesFormatter.stringFromDate(date)
            let difference = NSDate().timeIntervalSinceDate(date)
            print("difference \(difference)")
            if(( Int(difference) > 43200 + Int(minutes)! ) || (Int(difference) < -43200 - (60 - Int(minutes)! ))){
                print("too old or not within ")
                //remove locally
                accessPlist().event_delete(event.key as! String)
                //remove from server
                let parameters = ["AccessToken":accessPlist().owner_get("access_token")! as String,"EventID":event.key as! String]
                //send to server
                twelvApi().Request("event_delete", parameter: JSON(parameters), onCompletion: twelvApi().confirmEventDelete)
            }else{
                event.value.setValue(event.key as! String, forKey: "id")
                let hr:String = timeToHour(event.value["start_time"] as! String)
                eventsDict[hr]?.append(event.value as! [String : String])
                //eventsArray.append(event.value as! [String : String])
            }
        }
        for hour in eventsDict{
            let sortedEvents: Array = hour.1.sort({
                return timeToMinutes($0["start_time"]!) > timeToMinutes($1["start_time"]!)
            })
            eventsDict[hour.0] = sortedEvents
        }
        //display events
        var x = 1
        for hourAr in eventsDict{
            var dragArrayHold = [dragSection]()
            for event in hourAr.1{
                let hour: String = timeToHour(event["start_time"]!)
                
                let width: Double = Double(view.frame.width)-Double(clockFace.frame.minX)
                let height: Double = Double(view.frame.height)-Double(clockFace.frame.minY)
                var halfCalc = ((Double(hour)! * 30) + Double((hourAr.1.count - x) * 3))
                halfCalc = halfCalc * M_PI / 180.0
                halfCalc = sin(halfCalc)
                let xLoc = ((width)/2)+(halfCalc*(width/2))
            
                halfCalc = ((Double(hour)! * 30) + Double((hourAr.1.count - x) * 3))
                halfCalc = halfCalc * M_PI / 180.0
                halfCalc = cos(halfCalc)
                let yLoc = ((height)/2)+50-(halfCalc*(height/2))
        
                let button = UIButton(type: UIButtonType.System) as UIButton
                button.frame = CGRectMake(CGFloat(xLoc),CGFloat(yLoc), CGFloat(46), CGFloat(46))
                button.setTitle(event["id"]!, forState: .Normal)
                //get current status
                let relations = accessPlist().user_event_rel_get()
                let ownerID: String = accessPlist().owner_get("twelv_id")!
                forloop: for relation in relations!{
                    if relation.objectForKey("event_id") as? String == event["id"]! && relation.objectForKey("user_id") as? String == ownerID{
                        let statusStr: String = relation.objectForKey("status") as! String;
                        print(statusStr)
                        let statusInt: Int = Int(statusStr)!;
                        print(statusInt)
                        switch statusInt{
                        case 1:
                            button.layer.borderColor = UIColor.greenColor().CGColor
                        case 2:
                            button.layer.borderColor = UIColor.redColor().CGColor
                        default:
                            break
                        }
                        break forloop
                    }
                }
                button.setTitleColor(UIColor.blackColor().colorWithAlphaComponent(0), forState: .Normal)
                //load image
                button.setBackgroundImage(Load().image(event["id"]!), forState: UIControlState.Normal)
            
                button.layer.cornerRadius = 0.5 * button.bounds.size.width
                button.clipsToBounds = true
                button.layer.borderWidth = 2
                if function_name != nil{
                    button.addTarget(self, action: function_name!, forControlEvents: UIControlEvents.TouchUpInside)
                    button.addTarget(self, action: "overEvent:", forControlEvents: UIControlEvents.TouchDown)
                }
                //add button to drag calc
                let functionName:String = "inEvent" + (event["id"]!)
                dragArrayHold.append(dragSection(xIn: Int(xLoc), yIn: Int(yLoc), widthIn:46, heightIn:46, functionNameIn:functionName))
                let panRec = UIPanGestureRecognizer()
                panRec.addTarget(self, action: "handlePan:")
                button.addGestureRecognizer(panRec)
                //add button to view
                view.addSubview(button)
                x++
            }
            x=1
            dragArray.appendContentsOf(dragArrayHold.reverse())
        }
    }
    
    func timeToMinutes(time:String) ->Int{
        let inFormatter = NSDateFormatter()
        inFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        inFormatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        
        let outFormatterHour = NSDateFormatter()
        outFormatterHour.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        outFormatterHour.dateFormat = "hh"
        
        let outFormatterMinute = NSDateFormatter()
        outFormatterMinute.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        outFormatterMinute.dateFormat = "mm"
        
        let date = inFormatter.dateFromString(time)!
        let hour: String = outFormatterHour.stringFromDate(date)
        let minute: String = outFormatterMinute.stringFromDate(date)
        return (Int(hour)! * 60) + Int(minute)!
    }
    func timeToHour(time:String) ->String{
        let inFormatter = NSDateFormatter()
        inFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        inFormatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        
        let outFormatter = NSDateFormatter()
        outFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        outFormatter.dateFormat = "hh"
        
        let date = inFormatter.dateFromString(time)!
        let hour: String = outFormatter.stringFromDate(date)
        return hour
    }
}