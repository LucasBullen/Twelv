//
//  plistBrain.swift
//  iOSTwelv
//
//  Created by Lucas Bullen on 2015-11-06.
//  Copyright © 2015 Lucas Bullen. All rights reserved.
//

import Foundation

//logic for calling the Plist
class accessPlist {
//getters
    //Event
    func event_get(id: String)->NSDictionary?{
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as! NSString
        let path = documentsDirectory.stringByAppendingPathComponent("data.plist")
        
        if let dict = NSMutableDictionary(contentsOfFile: path){
            return dict.objectForKey("event_info")!.objectForKey(id)! as? NSDictionary
        }else{
            if let privPath = NSBundle.mainBundle().pathForResource("data", ofType: "plist"){
                if let dict = NSMutableDictionary(contentsOfFile: privPath){
                    if let event_info = dict.objectForKey("event_info")!.objectForKey(id){
                        return event_info as? NSDictionary
                    }else{
                        print("error_read_2")
                    }
                }else{
                    print("error_read")
                }
            }else{
                print("error_read")
            }
        }
        return nil
    }
    //User
    func user_get(id: String)->NSDictionary?{
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as! NSString
        let path = documentsDirectory.stringByAppendingPathComponent("data.plist")
        
        if let dict = NSMutableDictionary(contentsOfFile: path){
            return dict.objectForKey("user_info")!.objectForKey(id)! as? NSDictionary
        }else{
            if let privPath = NSBundle.mainBundle().pathForResource("data", ofType: "plist"){
                if let dict = NSMutableDictionary(contentsOfFile: privPath){
                    if let event_info = dict.objectForKey("user_info")!.objectForKey(id){
                        return event_info as? NSDictionary
                    }else{
                        print("error_read_2")
                    }
                }else{
                    print("error_read")
                }
            }else{
                print("error_read")
            }
        }
        return nil
    }
    //User_event_rel
    func user_event_rel_get(id: String)->NSArray?{
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as! NSString
        let path = documentsDirectory.stringByAppendingPathComponent("data.plist")
        
        if let ary = NSMutableArray(contentsOfFile: path){
            return ary
        }else{
            if let privPath = NSBundle.mainBundle().pathForResource("data", ofType: "plist"){
                if let ary = NSMutableArray(contentsOfFile: privPath){
                    return ary
                }else{
                    print("error_read")
                }
            }else{
                print("error_read")
            }
        }
        return nil
    }

//setters
    //Events
    func event_create(id: String, location:String, title:String, description:String, start_time:String) {
        var event = [String: String]()
        event["location"] = location
        event["title"] = title
        event["description"] = description
        event["start_time"] = start_time
        event["create_time"] = currentTime()
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as! NSString
        let path = documentsDirectory.stringByAppendingPathComponent("data.plist")
        
        if let dict = NSMutableDictionary(contentsOfFile: path){
            dict.objectForKey("event_info")!.setObject(event, forKey: id)
            if dict.writeToFile(path, atomically: true){
                print("plist_write")
            }else{
                print("plist_write_error")
            }
        }else{
            if let privPath = NSBundle.mainBundle().pathForResource("data", ofType: "plist"){
                if let dict = NSMutableDictionary(contentsOfFile: privPath){
                    dict.objectForKey("event_info")!.setObject(event, forKey: id)
                    if dict.writeToFile(path, atomically: true){
                        print("plist_write")
                    }else{
                        print("plist_write_error")
                    }
                }else{
                    print("plist_write")
                }
            }else{
                print("error_find_plist")
            }
        }
    }
    //Users
    func user_create(id: String) {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as! NSString
        let path = documentsDirectory.stringByAppendingPathComponent("data.plist")
        
        if let dict = NSMutableDictionary(contentsOfFile: path){
            dict.objectForKey("user_info")!.setObject(newUser(), forKey: id)
            if dict.writeToFile(path, atomically: true){
                print("plist_write")
            }else{
                print("plist_write_error")
            }
        }else{
            if let privPath = NSBundle.mainBundle().pathForResource("data", ofType: "plist"){
                if let dict = NSMutableDictionary(contentsOfFile: privPath){
                    dict.objectForKey("user_info")!.setObject(newUser(), forKey: id)
                    if dict.writeToFile(path, atomically: true){
                        print("plist_write")
                    }else{
                        print("plist_write_error")
                    }
                }else{
                    print("plist_write")
                }
            }else{
                print("error_find_plist")
            }
        }
    }
    //User Event Rel
    func user_event_rel_create(id: String) {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as! NSString
        let path = documentsDirectory.stringByAppendingPathComponent("user_event_rel.plist")
        
        if let ary = NSMutableArray(contentsOfFile: path){
            ary.addObject(newUserEventRel())
            if ary.writeToFile(path, atomically: true){
                print("plist_write")
            }else{
                print("plist_write_error")
            }
        }else{
            if let privPath = NSBundle.mainBundle().pathForResource("user_event_rel", ofType: "plist"){
                if let ary = NSMutableArray(contentsOfFile: privPath){
                    ary.addObject(newUserEventRel())
                    if ary.writeToFile(path, atomically: true){
                        print("plist_write")
                    }else{
                        print("plist_write_error")
                    }
                }else{
                    print("plist_write")
                }
            }else{
                print("error_find_plist")
            }
        }
    }
    
    
//fake builds for testing
    func newEvent()->NSDictionary{
        var event = [String: String]()
        event["location"] = "location123"
        event["title"] = "title123"
        event["description"] = "description123"
        event["start_time"] = "2015-11-19 7:30:00"
        event["create_time"] = "2015-11-19 7:30:00"
        return event
    }
    func newUser()->NSDictionary{
        var event = [String: String]()
        event["fb_id"] = "location123"
        event["name"] = "title123"
        event["profile_picture"] = "description123"
        return event
    }
    func newUserEventRel()->NSDictionary{
        var user_event_rel = [String: String]()
        user_event_rel["user_id"] = "100000000001"
        user_event_rel["event_id"] = "123"
        user_event_rel["status"] = "1"
        user_event_rel["privlages"] = "1"
        return user_event_rel
    }
    
    //get current time in required format
    func currentTime()->String{
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        return formatter.stringFromDate(NSDate())
    }
    
}