//
//  ViewController.swift
//  iOSTwelv
//
//  Created by Lucas Bullen on 2015-10-03.
//  Copyright © 2015 Lucas Bullen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate{
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
    //holding down on the create new event button
    @IBOutlet weak var bottomCreateBar: NSLayoutConstraint!
    
    //newEventCreateProcess variables
    var currentSlide: Int = 1
    let totalSlides: Int = 3
    let slidesRequired: Int = 2
    var eventTitle: String = ""
    var eventFriends = [String]()
    var eventLocation: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.input.delegate = self;
        input.autocorrectionType = UITextAutocorrectionType.No
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        //add all the locations where dragging will be affected
        dragArray.append(dragSection(xIn: 0, yIn: Int(screenSize.height - 92), widthIn:92, heightIn:92, functionNameIn:"inNewEventButton"))
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//input funcitons
    
    //starting the drag from create new event
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.locationInView(self.view)
        var accurracy: Int = 3
        let x: Int = Int(translation.x)
        let y: Int = Int(translation.y)
        let vel: Int = Int(sqrt(pow(Double(abs(recognizer.velocityInView(self.view).x)),2) + pow(Double(abs(recognizer.velocityInView(self.view).y)),2)))
        if vel > 250 {
            accurracy = 1;
        }else if vel > 180 {
            accurracy = 2;        }
        let act: String = drag().checkDragLocation(x,y:y, ac:accurracy)
        if act == "inNewEventButton"{
            inNewEventButton()
        }else{
            hourHand.hidden = true
            onClockTime.hidden = false
            onClockTime.text = "\(drag().time(x,y:y, ac:accurracy))"
        }
        //on lift off
        if recognizer.state == UIGestureRecognizerState.Ended {
            //must create new event
            if act != "inNewEventButton"{
                inNewEventButton()
                nameCreate()
            }
        }
    }
        //clicking on the 4 buttons on base of page
    
    @IBAction func changeViewClick(sender: AnyObject) {
    }
    //each keystrock on input to update autocompete
    @IBAction func typingInput(sender: AnyObject) {
    }
    //clicking any of the three bottom buttons on the create new event page
    @IBAction func bottomBarClick(sender: AnyObject) {
        switch sender.tag{
        case 0:
            progressNewEvent(-1)
        case 1:
            progressNewEvent(1)
        case 2:
            createNewEvent()
        default: break
        }
        
    }
    /*
    *closes the keyboard
    */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        progressNewEvent(1)
        return false
    }
    
    
    /*
    *moves up the bottome bar
    */
    func textFieldDidBeginEditing(textField: UITextField) { // became first responder
        bottomCreateBar.constant = 216
    }
    
    /*
    *moves down the bottom bar
    */
    func textFieldDidEndEditing(textField: UITextField) {
        bottomCreateBar.constant = 0
    }
    
    /*
    *set highlight to textfield
    */
    func engageKeyboard(field: UITextField){
        field.becomeFirstResponder()
    }
    
    //dragging reactions
    func inNewEventButton(){
        hourHand.hidden = false
        onClockTime.hidden = true
    }
}


