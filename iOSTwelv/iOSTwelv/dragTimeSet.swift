//
//  dragTimeSet.swift
//  iOSTwelv
//
//  Created by Lucas Bullen on 2015-10-31.
//  Copyright © 2015 Lucas Bullen. All rights reserved.
//

import Foundation
import UIKit

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
    func isIn(xLoc:Int,yLoc:Int) -> Bool{
        if (xLoc >= x && xLoc <= x+width && yLoc>=y && yLoc <= y + height){
            return true
        }
        return false
    }
}
//array of objects to track dragging
var dragArray = [dragSection]()

class  drag{
    /*turns coordinates and accuracy into a military time
    *parameters: x (Int x location) y (Int y location) ac (Int required accuracy)
    *returns: military time Int
    */
    func time(x:Int, y:Int, ac:Int) ->Int{
        let opposite: Double = (Double(y)-(Double(UIScreen.mainScreen().bounds.height)/2))
        let agecent: Double = (Double(x)-(Double(UIScreen.mainScreen().bounds.width)/2))
        let tan: Double = atan(opposite/agecent)
        let minutesPastZero: Int = Int((tan*360)/M_PI)
        var hour: Int = 0;
        var minute: Int = 0;
        if Double(x) > (Double(UIScreen.mainScreen().bounds.width)/2) {
            hour = (minutesPastZero + 180) / 60;
        }else if Double(x) < (Double(UIScreen.mainScreen().bounds.width)/2) {
            hour = (((minutesPastZero) + 180) / 60) + 6;
        }else{
            if Double(y) >= (Double(UIScreen.mainScreen().bounds.height)/2) {
                hour = 6;
            }else{
                hour = 12;
            }
        }
        minute=(minutesPastZero + 180) % 60;
        if hour == 0{
            hour = 12
        }
        var ret: Int = 0;
        switch ac {
        case 3:
            ret=(hour*100) + (minute-(minute%5))
        case 2:
            ret=(hour*100) + (minute-(minute%15))
        case 1:
            ret=(hour*100) + (minute-(minute%30))
        default:
            ret=(hour*100)
        }
        return ret
    }
    /*
        checks the location of current drag and sees if an action is required
        returns the reaction with highest priority
        parameters: x (Int x location) y (Int y location)
        return: function name of required reaction (String) ir 'nil' string
    */
    func checkDragLocation(x: Int, y: Int, ac: Int) -> String{
        for i in dragArray{
            if i.isIn(x, yLoc: y){
                return i.funcitonName
            }else{
                
            }
        }
        return "nil"
    }
}
