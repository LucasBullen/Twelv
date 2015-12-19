//
//  SplashViewController.swift
//  iOSTwelv
//
//  Created by Nicholas Radford on 2015-11-06.
//  Copyright © 2015 Lucas Bullen. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class SplashViewController: UIViewController ,FBSDKLoginButtonDelegate {
    override func viewDidAppear(animated: Bool) {
        //check if user is connected to internet, if not skip to home
        if ((!Reachability().isConnectedToNetwork()) && (accessPlist().owner_get("twelv_id") != nil)){
            ViewController().is_online = false
            let controller = storyboard?.instantiateViewControllerWithIdentifier("main") as! ViewController
            presentViewController(controller, animated: true, completion: nil)
        }
        if (FBSDKAccessToken.currentAccessToken() == nil){
            print("Not logged in..")
        } else {
            prepLogin()
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // start of Facebook implamintation
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile","email","user_friends"]
        loginButton.center = self.view.center
        
        loginButton.delegate = self
        
        self.view.addSubview(loginButton)
        
        // End of Facebook implamintation


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if error == nil{
            print("Login complete.")
            prepLogin()
            
        } else {
            
            print(error.localizedDescription)
        }
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User loged out...")
    }
    
    func prepLogin(){
        print("logged into facebook")
        twelvApi().setFacebookUserData()
        accessPlist().owner_edit("access_token", value: FBSDKAccessToken.currentAccessToken().tokenString)
        
        let controller = storyboard?.instantiateViewControllerWithIdentifier("main") as! ViewController
        presentViewController(controller, animated: true, completion: nil)
    }
}
