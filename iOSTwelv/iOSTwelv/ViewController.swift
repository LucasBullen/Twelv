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
    //UIImageView is the face of the analog clock
    @IBOutlet weak var clockFace: UIImageView!
    //UIImageView is the hour hand of the analog clock
    @IBOutlet weak var hourHand: UIImageView!
    //UILable found at top of screen hosting important information and title of the currently viewed event
    @IBOutlet weak var topInfoBar: UILabel!
    
    @IBOutlet weak var minuteHand: UIImageView!
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
    
    @IBOutlet weak var smallInfoView: UIView!
//Event info elements
    @IBOutlet weak var eventFullInfo: UIView!
    @IBOutlet weak var titleFull: UILabel!
    @IBOutlet weak var locationFull: UILabel!
    @IBOutlet weak var timeFull: UILabel!
    @IBOutlet weak var descriptionFull: UITextView!
    @IBOutlet weak var friendsFull: UIScrollView!
//newEventCreateProcess variables
    var eventTitle: String = ""
    var eventTime: String = "2015-11-19 19:40:27"
    var eventDescription: String = ""
    var eventFriends = [String]()
    var eventLocation: String = ""
//global variables
    var currentSlide: Int = 1
    let totalSlides: Int = 3
    let slidesRequired: Int = 2
    var is_online = true
    var theTimer:NSTimer?
    
    override func viewDidLoad() {

        //notification
        UIApplication.sharedApplication().registerForRemoteNotifications()
        //code for the agree popup
        let settings = UIUserNotificationSettings(forTypes: .Alert, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        //load page
        super.viewDidLoad()
        
               
        self.input.delegate = self;
        input.autocorrectionType = UITextAutocorrectionType.No
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        //add all the locations where dragging will be affected
        dragArray.append(dragSection(xIn: 0, yIn: Int(screenSize.height - 92), widthIn:92, heightIn:92, functionNameIn:"inNewEventButton"))
        dragArray.append(dragSection(xIn: (Int(clockFace.frame.minX)), yIn: (Int(clockFace.frame.minY)), widthIn:Int(clockFace.frame.width), heightIn:Int(clockFace.frame.height), functionNameIn:"inFullInfo"))
        // Do any additional setup after loading the view, typically from a nib.
        accessPlist().downloadImages()
        
        //download events
        //saveAllEvents
        let parameters = ["AccessToken":accessPlist().owner_get("access_token")! as String]
        
        twelvApi().Request("event_fetch", parameter: JSON(parameters), onCompletion: twelvApi().saveAllEvents)
        
        fillWithEvents(mainView, events: accessPlist().all_events_get()!, function_name: "inEvent:")
        view.bringSubviewToFront(createEvent)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setTime()
        self.theTimer = NSTimer.scheduledTimerWithTimeInterval(15, target: self, selector: Selector("setTime"), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//input funcitons
    
    //starting the drag from create new event
    var dragStart: String = ""
    var idCurrentEvent: String = ""
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
        //check where we started the drag
        if recognizer.state == UIGestureRecognizerState.Began {
            dragStart = drag().checkDragLocation(x,y:y, ac:accurracy)
        }
        switch dragStart{
        case "inNewEventButton":
            if act=="inNewEventButton"{
                inNewEventButton()
            }else{
                minuteHand.hidden = true
                hourHand.hidden = true
                onClockTime.hidden = false
                let hour = drag().time(x,y:y, ac:accurracy) / 100
                let minute = drag().time(x,y:y, ac:accurracy) % 100
                if (minute<10){
                    onClockTime.text = "\(hour):0\(minute)"
                }else{
                    onClockTime.text = "\(hour):\(minute)"
                }
            }
        default:
            if act != "nil" && act.substringToIndex(act.startIndex.advancedBy(7)) == "inEvent" && dragStart.substringToIndex(dragStart.startIndex.advancedBy(7)) == "inEvent"{
                let button = UIButton()
                button.setTitle(act.substringFromIndex(act.startIndex.advancedBy(7)), forState: .Normal)
                idCurrentEvent = act.substringFromIndex(act.startIndex.advancedBy(7))
                overEvent(button)
            }
        }
        //on lift off
        if recognizer.state == UIGestureRecognizerState.Ended {
            //must create new event
            if dragStart == "inNewEventButton" && act != "inNewEventButton"{
                inNewEventButton()
                nameCreate()
                currentSlide=1
                //createEvent.layer.zPosition = 100;
            }else if dragStart != "nil" && dragStart.substringToIndex(dragStart.startIndex.advancedBy(7)) == "inEvent"{
                if act=="inFullInfo"{
                    let button = UIButton()
                    button.setTitle(idCurrentEvent, forState: .Normal)
                    inEvent(button)
                }else{
                   //no longer looking at events
                    topInfoBar.text = "Grocery Shopping in 30mins"
                    smallInfoView.hidden=true
                    clockFace.image = UIImage(named: "clockFace.png")
                    minuteHand.hidden = false
                    hourHand.hidden=false
                    for view in invitedFriends.subviews {
                        view.removeFromSuperview()
                    }
                }
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
        print("me clicked")
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
//full event info methods
    @IBAction func homeFromFullInfo(sender: AnyObject) {
        eventFullInfo.hidden=true
    }
    @IBAction func confirmAttendFull(sender: AnyObject) {
        switch sender.tag{
        case 1:
            print("going!!")
        case 2:
            print("not going :(")
        default:
            return
        }
    }
/*
*closes the keyboard
*/
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        if currentSlide==1 || currentSlide==3{
            progressNewEvent(1)
        }
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
        minuteHand.hidden = false
        hourHand.hidden = false
        onClockTime.hidden = true
    }
    func inEvent(sender: AnyObject){
        showFullEventInfo(sender.currentTitle!!)
    }
    func showFullEventInfo(id:String){
        //revert home
        topInfoBar.text = "Grocery Shopping in 30mins"
        smallInfoView.hidden = true
        clockFace.image = UIImage(named: "clockFace.png")
        minuteHand.hidden = false
        hourHand.hidden=false
        for view in invitedFriends.subviews {
            view.removeFromSuperview()
        }
        //create info
        eventFullInfo.hidden=false
        self.view.bringSubviewToFront(eventFullInfo)
        let event = accessPlist().event_get(id)
        titleFull.text = event?.objectForKey("title") as? String
        locationFull.text = event?.objectForKey("location") as? String
        descriptionFull.text = event?.objectForKey("description") as? String
        //show friends
        let relations = accessPlist().user_event_rel_get()
        let usersInEvent: NSMutableDictionary = [:] as NSMutableDictionary
        for view in friendsFull.subviews {
            view.removeFromSuperview()
        }
        for relation in relations!{
            if relation.objectForKey("event_id") as? String == id{
                usersInEvent.setValue(accessPlist().user_get((relation.objectForKey("user_id") as? String)!), forKey: (relation.objectForKey("user_id") as? String)!)
            }
        }
        fillWithUsers(friendsFull, users: usersInEvent, function_name: nil, event_id: id)
    }
    func overEvent(sender: AnyObject){
        let id: String = sender.currentTitle!!
        let event = accessPlist().event_get(id)
        //make visable
        smallInfoView.hidden = false
        clockFace.image = UIImage(named: "clockFaceHollow.png")
        minuteHand.hidden = true
        hourHand.hidden=true
        onClockTime.hidden=true
        //load info
        topInfoBar.text = event?.objectForKey("title") as? String
        location.text = event?.objectForKey("location") as? String
        descriptionText.text = event?.objectForKey("description") as? String
        //show friends
        let relations = accessPlist().user_event_rel_get()
        let usersInEvent: NSMutableDictionary = [:] as NSMutableDictionary
        for view in invitedFriends.subviews {
            view.removeFromSuperview()
        }
        for relation in relations!{
            if relation.objectForKey("event_id") as? String == id{
                usersInEvent.setValue(accessPlist().user_get((relation.objectForKey("user_id") as? String)!), forKey: (relation.objectForKey("user_id") as? String)!)
            }
        }
        fillWithUsers(invitedFriends, users: usersInEvent, function_name: nil, event_id: id)
        
    }
    //making the clock a clock
    func setTime(){
        let date = NSDate()
        let outputFormatter = NSDateFormatter()
        outputFormatter.dateFormat = "hh"
        var newString:NSString = outputFormatter.stringFromDate(date)
        let hour = Int(newString as String)

        outputFormatter.dateFormat = "mm"
        newString = outputFormatter.stringFromDate(date)
        let minute = Int(newString as String)

        let minAngle = Double(6 * minute!) / 180.0 * Double(CGFloat(M_PI))
        let hourAngle = Double(30 * hour! + minute! / 2) / 180.0 * Double(CGFloat(M_PI))
    
        minuteHand.transform = CGAffineTransformMakeRotation( CGFloat(Double(minAngle)) )
        hourHand.transform = CGAffineTransformMakeRotation( CGFloat(hourAngle) )
    }
}
