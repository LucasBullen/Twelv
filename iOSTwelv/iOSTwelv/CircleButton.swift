//
//  CircleButton.swift
//  iOSTwelv
//
//  Created by Lucas Bullen on 2015-12-15.
//  Copyright © 2015 Lucas Bullen. All rights reserved.
//

import Foundation
import UIKit

class CircleButton{
    var parentView = UIView();
    var xLoc = 0;
    var yLoc = 0;
    var width = 0;
    var height = 0;
    var image = "nil";
    var borderColor = UIColor(
        red:0.0,
        green:0.0,
        blue:0.0,
        alpha:1.0);
    var zIndex = 0;
    var title = "nil";
    
    func clickAction(){
        
    }
    
    func draw(){
        let button = UIButton(type: UIButtonType.System) as UIButton
        button.frame = CGRectMake(CGFloat(xLoc),CGFloat(yLoc), CGFloat(width), CGFloat(height))
        button.setBackgroundImage(Load().image(image), forState: UIControlState.Normal)
        
        button.layer.cornerRadius = CGFloat(0.5 * Double(width))
        button.clipsToBounds = true
        button.layer.borderWidth = 2
        
        button.layer.borderColor = borderColor.CGColor

        //button.addTarget(self, action: clickAction(), forControlEvents: UIControlEvents.TouchUpInside)
        parentView.addSubview(button)
    }
}