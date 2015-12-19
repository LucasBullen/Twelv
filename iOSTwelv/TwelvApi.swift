//
//  TwelvApi.swift
//  iOSTwelv
//
//  Created by Nicholas Radford on 2015-11-10.
//  Copyright © 2015 Lucas Bullen. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit

class twelvApi: NSObject{
    static let shareInstance = twelvApi()

    let baseURL = "http://www.lucasbullen.com/twelv/api/"

    func Request(endpoint: String,parameter: JSON, onCompletion:(JSON) -> Void) {

        let route = baseURL +  "?" + endpoint + "=" + parameter.rawString()!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
        
        makeHTTPGetRequest(route, onCompletion: onCompletion)
    }
    
    func makeHTTPGetRequest(path: String, onCompletion: (JSON) -> Void) {
        let remoteUrl : NSURL = NSURL(string: path as String)!
        let request = NSMutableURLRequest(URL: remoteUrl)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
            print("error:\(error)")
            let json:JSON = JSON(data: data!)
            onCompletion(json)
        });
        task.resume()
    }

    func setFacebookUserData()
    {
        print("else");
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath:  "me", parameters: ["fields": "id,name,email"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                accessPlist().owner_edit("fb_id", value: result.valueForKey("id")! as! String)
                accessPlist().owner_edit("name", value: result.valueForKey("name")! as! String)
                accessPlist().owner_edit("email", value: result.valueForKey("email")! as! String)
                let parameters = ["AccessToken":accessPlist().owner_get("access_token")! as String,"FBID":accessPlist().owner_get("fb_id")! as String, "DeviceID":accessPlist().owner_get("device_id")! as String]
                //send to server
                self.Request("user_create", parameter: JSON(parameters), onCompletion: self.confirmTwelvLogin)
            }
        })
    }
    
    func saveAllEvents(returned: JSON){
        print("All Events: \(returned)")
    }
    
    func confirmTwelvLogin(returned: JSON){
        if returned["error"] != nil {
            print("ERROR: Login Error \(returned["error"].stringValue)")
        } else {
            accessPlist().owner_edit("twelv_id", value: returned["twelvid"].stringValue)
            print("Saved twelv id: \(returned["twelvid"].stringValue)")
        }
    }
    func confirmEventDelete(returned: JSON){
        if returned["error"] != nil {
            print("ERROR: Delete Event Error \(returned["error"].stringValue)")
        } else {
            print("Event Deleted: \(returned)")
        }
    }
}