//
//  plistBrain.swift
//  iOSTwelv
//
//  Created by Lucas Bullen on 2015-11-06.
//  Copyright © 2015 Lucas Bullen. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

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
    //All Users
    func all_users_get()->NSDictionary?{
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as! NSString
        let path = documentsDirectory.stringByAppendingPathComponent("data.plist")
        
        if let dict = NSMutableDictionary(contentsOfFile: path){
            return dict.objectForKey("user_info")! as? NSDictionary
        }else{
            if let privPath = NSBundle.mainBundle().pathForResource("data", ofType: "plist"){
                if let dict = NSMutableDictionary(contentsOfFile: privPath){
                    if let events = dict.objectForKey("user_info"){
                        return events as? NSDictionary
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
    //All events
    func all_events_get()->NSDictionary?{
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as! NSString
        let path = documentsDirectory.stringByAppendingPathComponent("data.plist")
        
        if let dict = NSMutableDictionary(contentsOfFile: path){
            return dict.objectForKey("event_info")! as? NSDictionary
        }else{
            if let privPath = NSBundle.mainBundle().pathForResource("data", ofType: "plist"){
                if let dict = NSMutableDictionary(contentsOfFile: privPath){
                    if let events = dict.objectForKey("event_info"){
                        return events as? NSDictionary
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
    func user_event_rel_get()->NSArray?{
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as! NSString
        let path = documentsDirectory.stringByAppendingPathComponent("user_event_rel.plist")
        
        if let ary = NSMutableArray(contentsOfFile: path){
            return ary
        }else{
            if let privPath = NSBundle.mainBundle().pathForResource("user_event_rel", ofType: "plist"){
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
    func user_create(id: String, fb_id:String, name:String,profile_picture:String) {
        var event = [String: String]()
        event["fb_id"] = fb_id
        event["name"] = name
        event["profile_picture"] = profile_picture
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as! NSString
        let path = documentsDirectory.stringByAppendingPathComponent("data.plist")
        
        if let dict = NSMutableDictionary(contentsOfFile: path){
            dict.objectForKey("user_info")!.setObject(event, forKey: id)
            if dict.writeToFile(path, atomically: true){
                print("plist_write")
            }else{
                print("plist_write_error")
            }
        }else{
            if let privPath = NSBundle.mainBundle().pathForResource("data", ofType: "plist"){
                if let dict = NSMutableDictionary(contentsOfFile: privPath){
                    dict.objectForKey("user_info")!.setObject(event, forKey: id)
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
    func user_event_rel_create(user_id: String,event_id: String,status: String,privlages: String) {
        var user_event_rel = [String: String]()
        user_event_rel["user_id"] = user_id
        user_event_rel["event_id"] = event_id
        user_event_rel["status"] = status
        user_event_rel["privlages"] = privlages
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as! NSString
        let path = documentsDirectory.stringByAppendingPathComponent("user_event_rel.plist")
        
        if let ary = NSMutableArray(contentsOfFile: path){
            ary.addObject(user_event_rel)
            if ary.writeToFile(path, atomically: true){
                print("plist_write")
            }else{
                print("plist_write_error")
            }
        }else{
            if let privPath = NSBundle.mainBundle().pathForResource("user_event_rel", ofType: "plist"){
                if let ary = NSMutableArray(contentsOfFile: privPath){
                    ary.addObject(user_event_rel)
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
//editors
    //Events
    func event_edit(id: String, field:String, value:String) {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as! NSString
        let path = documentsDirectory.stringByAppendingPathComponent("data.plist")
        
        if let dict = NSMutableDictionary(contentsOfFile: path){
            dict.objectForKey("event_info")!.objectForKey(id)!.setObject(value, forKey: field)
            if dict.writeToFile(path, atomically: true){
                print("plist_write")
            }else{
                print("plist_write_error")
            }
        }else{
            if let privPath = NSBundle.mainBundle().pathForResource("data", ofType: "plist"){
                if let dict = NSMutableDictionary(contentsOfFile: privPath){
                    dict.objectForKey("event_info")!.objectForKey(id)!.setObject(value, forKey: field)
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
    func user_edit(id: String, field:String, value:String) {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as! NSString
        let path = documentsDirectory.stringByAppendingPathComponent("data.plist")
        
        if let dict = NSMutableDictionary(contentsOfFile: path){
            dict.objectForKey("user_info")!.objectForKey(id)!.setObject(value, forKey: field)
            if dict.writeToFile(path, atomically: true){
                print("plist_write")
            }else{
                print("plist_write_error")
            }
        }else{
            if let privPath = NSBundle.mainBundle().pathForResource("data", ofType: "plist"){
                if let dict = NSMutableDictionary(contentsOfFile: privPath){
                    dict.objectForKey("user_info")!.objectForKey(id)!.setObject(value, forKey: id)
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
    func user_event_rel_edit(user_id:String, event_id: String, field:String, value:String) {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as! NSString
        let path = documentsDirectory.stringByAppendingPathComponent("user_event_rel.plist")
        
        if let ary = NSMutableArray(contentsOfFile: path) {
            for var i = 0; i < ary.count; ++i{
                if ary[i]["user_id"] as! String==user_id && ary[i]["event_id"] as! String==event_id{
                    ary[i].setObject(value, forKey: field)
                    print("plist_adjusted")
                }
            }
            if ary.writeToFile(path, atomically: true){
                print("plist_write")
            }else{
                print("plist_write_error")
            }
        }else{
            if let privPath = NSBundle.mainBundle().pathForResource("user_event_rel", ofType: "plist"){
                if let ary = NSMutableArray(contentsOfFile: privPath){
                    for var i = 0; i < ary.count; ++i{
                        if ary[i]["user_id"] as! String==user_id && ary[i]["event_id"] as! String==event_id{
                            ary[i].setObject(value, forKey: field)
                            print("plist_adjusted")
                        }
                    }
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
//deletors
    //Events
    func event_delete(id: String) {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as! NSString
        let path = documentsDirectory.stringByAppendingPathComponent("data.plist")
        
        if let dict = NSMutableDictionary(contentsOfFile: path){
            dict.objectForKey("event_info")!.removeObjectForKey(id)
            if dict.writeToFile(path, atomically: true){
                print("plist_write")
            }else{
                print("plist_write_error")
            }
        }else{
            if let privPath = NSBundle.mainBundle().pathForResource("data", ofType: "plist"){
                if let dict = NSMutableDictionary(contentsOfFile: privPath){
                    dict.objectForKey("event_info")!.removeObjectForKey(id)
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
    func user_delete(id: String) {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as! NSString
        let path = documentsDirectory.stringByAppendingPathComponent("data.plist")
        
        if let dict = NSMutableDictionary(contentsOfFile: path){
            dict.objectForKey("user_info")!.removeObjectForKey(id)
            if dict.writeToFile(path, atomically: true){
                print("plist_write")
            }else{
                print("plist_write_error")
            }
        }else{
            if let privPath = NSBundle.mainBundle().pathForResource("data", ofType: "plist"){
                if let dict = NSMutableDictionary(contentsOfFile: privPath){
                    dict.objectForKey("user_info")!.removeObjectForKey(id)
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
    func user_event_rel_delete(user_id:String, event_id: String) {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as! NSString
        let path = documentsDirectory.stringByAppendingPathComponent("user_event_rel.plist")
        
        if let ary = NSMutableArray(contentsOfFile: path) {
            for var i = 0; i < ary.count; ++i{
                if ary[i]["user_id"] as! String==user_id && ary[i]["event_id"] as! String==event_id{
                    ary.removeObjectAtIndex(i)
                    print("plist_adjusted")
                }
            }
            if ary.writeToFile(path, atomically: true){
                print("plist_write")
            }else{
                print("plist_write_error")
            }
        }else{
            if let privPath = NSBundle.mainBundle().pathForResource("user_event_rel", ofType: "plist"){
                if let ary = NSMutableArray(contentsOfFile: privPath){
                    for var i = 0; i < ary.count; ++i{
                        if ary[i]["user_id"] as! String==user_id && ary[i]["event_id"] as! String==event_id{
                            ary.removeObjectAtIndex(i)
                            print("plist_adjusted")
                        }
                    }
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
//for the owner informaiton
    func owner_get(key:String)->String?{
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as! NSString
        let path = documentsDirectory.stringByAppendingPathComponent("data.plist")
        
        if let dict = NSMutableDictionary(contentsOfFile: path){
            return dict.objectForKey("owner_info")!.objectForKey(key)! as? String
        }else{
            if let privPath = NSBundle.mainBundle().pathForResource("data", ofType: "plist"){
                if let dict = NSMutableDictionary(contentsOfFile: privPath){
                    if let info = dict.objectForKey("owner_info")!.objectForKey(key){
                        return info as? String
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
    func owner_edit(field:String, value:String) {
        print("f:\(field) v:\(value)")
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as! NSString
        let path = documentsDirectory.stringByAppendingPathComponent("data.plist")
        
        if let dict = NSMutableDictionary(contentsOfFile: path){
            dict.objectForKey("owner_info")!.setObject(value, forKey: field)
            if dict.writeToFile(path, atomically: true){
                print("plist_write")
            }else{
                print("plist_write_error")
            }
        }else{
            if let privPath = NSBundle.mainBundle().pathForResource("data", ofType: "plist"){
                if let dict = NSMutableDictionary(contentsOfFile: privPath){
                    dict.objectForKey("owner_info")!.setObject(value, forKey: value)
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
    func downloadImages(){
        for user in all_users_get()!{
            Save().image(user.key as! String, url: user.value.objectForKey("profile_picture") as! String)
        }
        for event in all_events_get()!{
            Save().image(event.key as! String, url: event.value.objectForKey("image") as! String)
        }
    }
    //get current time in required format
    func currentTime()->String{
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        return formatter.stringFromDate(NSDate())
    }
    
}

class Save {
    func image(key:String, url:String) {
        print("checking for \(key)'s image")
        if (Load().image(key) == nil && Reachability().isConnectedToNetwork()){
            print("downloading \(key)'s image")
            let nsURL = NSURL(string:url)!
            let content = NSData(contentsOfURL:nsURL)!
            let image = UIImage(data: content)!
            let png = UIImagePNGRepresentation(image)
            NSUserDefaults.standardUserDefaults().setObject(png, forKey: key)
        }
    }
}

class Load {
    func image(key:String) -> UIImage? {
        if (NSUserDefaults.standardUserDefaults().objectForKey(key) != nil){
            return UIImage(data: ( NSUserDefaults.standardUserDefaults().objectForKey(key) as! NSData))
        }
        return nil
    }
}

class Reachability {
    
   func isConnectedToNetwork()->Bool{
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}
