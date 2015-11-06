//
//  newEventCreateProcess.swift
//  iOSTwelv
//
//  Created by Lucas Bullen on 2015-10-31.
//  Copyright © 2015 Lucas Bullen. All rights reserved.
//

import Foundation
import UIKit

extension ViewController{
    /* function for moving between slides in the create event proccess
    * parameters: Int -1 for backwards, 1 for forwards
    */
    func progressNewEvent(movement:Int){
        if (input.text?.isEmpty == nil) {
            return
        }
        currentSlide += movement
        if currentSlide > slidesRequired{
            enableCreate()
        }
        if currentSlide > totalSlides{
            createNewEvent()
        }
        let userIn: String = input.text!
        input.text = ""
        print("progressNewEvent:\(currentSlide)")
        switch currentSlide{
        case 1:
            eventTitle = userIn
            nameCreate()
        case 2:
            friendsCreate()
        case 3:
            eventLocation = userIn
            locationCreate()
        default:
            createNewEvent()
            currentSlide=1
        }
    }
    func createNewEvent(){
        finishCreate()
    }
    
/***visuals***/
    func enableCreate(){
        finish.enabled = true
    }
    //step one of new event set up
    func nameCreate(){
        finish.enabled = false
        createEvent.hidden=false
        engageKeyboard(input)
        prompt.text="What is the event?"
        descriptionInput.hidden=true
        addFriends.hidden=true
        prompt.hidden=false
    }
    func friendsCreate(){
        createEvent.hidden=false
        self.view.endEditing(true)
        prompt.text="Who is invited?"
        descriptionInput.hidden=true
        addFriends.hidden=false
        prompt.hidden=true
        
    }
    func locationCreate(){
        createEvent.hidden=false
        engageKeyboard(input)
        prompt.text="Where is the event?"
        descriptionInput.hidden=true
        addFriends.hidden=true
        prompt.hidden=false
    }
    func finishCreate(){
        createEvent.hidden=true
        self.view.endEditing(true)
    }
}
