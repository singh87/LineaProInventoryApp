//
//  CustomTextField.swift
//  LiquorInventory
//
//  Created by Jasvinder Singh on 5/18/19.
//  Copyright © 2019 Jasvinder Singh. All rights reserved.
//

import UIKit

class CustomTextField : UITextField {
    
    override var tintColor: UIColor! {
        
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        let startingPoint = CGPoint(x: rect.minX, y: rect.maxY)
        let endingPoint = CGPoint(x: rect.maxX, y: rect.maxY)
        
        let path = UIBezierPath()
        
        path.move(to: startingPoint)
        path.addLine(to: endingPoint)
        path.lineWidth = 2.0
        UIColor.lightGray.setStroke()
        
//        tintColor.setStroke()
        
        path.stroke()
    }

}
