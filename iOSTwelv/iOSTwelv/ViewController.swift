//
//  ViewController.swift
//  iOSTwelv
//
//  Created by Lucas Bullen on 2015-10-03.
//  Copyright © 2015 Lucas Bullen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
//main page elements
    //UIView used to hold images of friends invited to currently viewed event
    @IBOutlet weak var invitedFriends: UIView!
    //UITextView used to hold the descriptive text if any of the currently viewed event
    @IBOutlet weak var descriptionText: UITextView!
    //UILable used to store locaiton of currently viewed event
    @IBOutlet weak var location: UILabel!
    //Digital time shown within clock for event/timer creation
    @IBOutlet weak var onClockTime: UILabel!
    //UIImageView is the hour hand of the analog clock
    @IBOutlet weak var hourHand: UIImageView!
    //UILable found at top of screen hosting important information and title of the currently viewed event
    @IBOutlet weak var topInfoBar: UILabel!
//Create event elements
    //the view that holds all the create event tools
    @IBOutlet weak var createEvent: UIView!
    //top label asking the user for questions
    @IBOutlet weak var prompt: UILabel!
    //view for holding the auto complete buttons
    @IBOutlet weak var autoFill: UIView!
    //typing field
    @IBOutlet weak var input: UITextField!
    //the bar holding the progress buttons that stays with the keyboard
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var bottomBar: UIView!
    //to return to previous page
    @IBOutlet weak var back: UIButton!
    //to progress to next page
    @IBOutlet weak var forward: UIButton!
    //to finalize event create
    @IBOutlet weak var finish: UIButton!
    //view holding all the possible friends and groups to add
    @IBOutlet weak var addFriends: UIView!
    //scroll view holding all the possible groups to add
    @IBOutlet weak var groupScroll: UIScrollView!
    //scroll view holding all the possible friends to add
    @IBOutlet weak var friendScroll: UIScrollView!
    //text view for description input
    @IBOutlet weak var descriptionInput: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //add elements to the dragArray
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//input funcitons
    //holding down on the create new event button
    class dragSection{
        var x: Int
        var y: Int
        var width: Int
        var height: Int
        var funcitonName: String
        init (xIn: Int, yIn: Int, widthIn:Int, heightIn:Int, functionNameIn:String){
            x=xIn
            y=yIn
            width=widthIn
            height=heightIn
            funcitonName=functionNameIn
        }
        func isIn(xLoc:Int,yLoc:Int){
            if (xLoc >= x && xLoc <= x+width && yLoc>=y && yLoc <= y + height){
                print("within\(funcitonName)");
            }
            
        }
    }
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.locationInView(self.view)
        print("\(translation.x) and \(translation.y)")
    }
    
    func checkDragLocation(x: Int, y: Int){
        
    }
        //clicking on the 4 buttons on base of page
    
    @IBAction func changeViewClick(sender: AnyObject) {
    }
    //each keystrock on input to update autocompete
    @IBAction func typingInput(sender: AnyObject) {
    }
    //clicking any of the three bottom buttons on the create new event page
    @IBAction func bottomBarClick(sender: AnyObject) {
    }
    
    
}

