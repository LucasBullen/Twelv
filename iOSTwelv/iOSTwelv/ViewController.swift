//
//  ViewController.swift
//  iOSTwelv
//
//  Created by Lucas Bullen on 2015-10-03.
//  Copyright © 2015 Lucas Bullen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

