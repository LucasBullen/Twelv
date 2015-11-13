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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // start of Facebook implamintation
        
        if (FBSDKAccessToken.currentAccessToken() == nil){
            
            print("Not logged in..")
        } else {
            
            print("Logged in..")
        }
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - Facebook Login
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if error == nil{
            
            print("Login complete.")
            self.performSegueWithIdentifier("showNew", sender: self)
            
        } else {
            
            print(error.localizedDescription)
        }
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User loged out...")
    }
    
    
    
    

}
