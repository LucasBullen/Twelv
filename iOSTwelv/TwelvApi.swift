//
//  TwelvApi.swift
//  iOSTwelv
//
//  Created by Nicholas Radford on 2015-11-10.
//  Copyright © 2015 Lucas Bullen. All rights reserved.
//

import Foundation

typealias ServiceResponse = (JSON, NSError?) -> Void

class twelvApi: NSObject{
    static let shareInstance = twelvApi()

    let baseURL = "lucasbullen.com/twelv/api/"

    func Request(endpoint: String,parameter: JSON, onCompletion:(JSON) -> Void) {

        
        let route = baseURL +  "?" + endpoint + "=" + parameter.string!
        
        
        makeHTTPGetRequest(route, onCompletion: { json, err in
            onCompletion(json as JSON)
        })
    }
    
    func makeHTTPGetRequest(path: String, onCompletion: ServiceResponse) {
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            let json:JSON = JSON(data: data!)
            onCompletion(json, error)
        })
        task.resume()
    }



}