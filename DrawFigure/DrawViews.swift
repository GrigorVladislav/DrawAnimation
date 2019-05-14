//
//  DrawViews.swift
//  DrawFigure
//
//  Created by Admin on 18.04.2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import UIKit

class DrawViews :UIView {
    
    var isCustomImage = false
    var customImage: UIImage?
   
    var sides: Int? {
        didSet {setNeedsDisplay(); setNeedsLayout()}
    }
    var isFaceUp = true { didSet{setNeedsDisplay(); setNeedsLayout()}}
    var flipCounter = 0
    
    init(frame: CGRect, sides: Int) {
        super.init(frame: frame)
        self.sides = sides
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
      
        guard let context = UIGraphicsGetCurrentContext() else { return }
        if isFaceUp {
            if sides != nil && sides! > 2 {
                drawFigure(context: context, rect: rect, sides: sides!)
            }
            drawCustomText(context: context, rect: rect, title: String(sides!))
        } else {
            if(isCustomImage){
                if let backImage = customImage{
                   backImage.draw(in: bounds)
                }
            }
            else{
            if let backgroundView =  UIImage(named: "images.jpg"){
                context.draw(backgroundView.cgImage!, in: rect)
                }
            }
        }
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    private func drawFigure(context: CGContext, rect: CGRect, sides: Int){
        let newMinX = rect.minX+5
        let newMaxX = rect.maxX-5
        let outerRadius = Double(newMaxX-newMinX)/2
        let sideLength = 2.0 * outerRadius * sin(Double.pi / Double(sides))
        let angle = -360.0/Double(sides)
        let innerRadius = sideLength/(2*tan(Double.pi/Double(sides)))
        var point = (x: Double(rect.maxX/2) + sideLength/2, y: Double(rect.maxY/2) + innerRadius)
        let path = UIBezierPath()
        path.move(to: CGPoint(x: point.x, y: point.y))
        for i in 1...sides-1{
            let sinFi = sin(Double(i) * angle * Double.pi / 180.0)
            let cosFi = cos(Double(i) * angle * Double.pi / 180.0)
            point.x = point.x + sideLength * cosFi
            point.y = point.y + sideLength * sinFi
            path.addLine(to: CGPoint(x: point.x, y: point.y))
        }
        path.close()
        
        UIColor.red.setStroke()
        UIColor.green.setFill()
        path.lineWidth = 5
        path.stroke()
        path.fill()
    }
    
    private func drawCustomText(context: CGContext, rect: CGRect, title: String){
        let text: NSString = title as NSString
        let fontSize = 30.0
        let font = UIFont(name: "Helvetica Bold", size: CGFloat(fontSize))!
        let textRect = CGRect(x: rect.maxX/2 - CGFloat(fontSize)/3, y: rect.maxY/2 - CGFloat(fontSize)/3, width: CGFloat(fontSize), height: CGFloat(fontSize))
        
        let attributeDict: [NSAttributedString.Key : Any] = [.font: font,.foregroundColor: UIColor.red]
        text.draw(in: textRect, withAttributes: attributeDict)
    }
}
