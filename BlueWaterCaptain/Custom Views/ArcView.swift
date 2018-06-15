//
//  ArcView.swift
//  ArcDemo
//
//  Created by Garima Aggarwal on 6/13/18.
//  Copyright © 2018 Garima Aggarwal. All rights reserved.
//

import UIKit

@objc protocol ArcViewDelegate: class {
    func updateWindDirections(_ windArray : Array<Int16>)
}


class ArcView: UIView {
    
    var windArray = [Int16]()
    var isFilter = false
    weak var delegate : ArcViewDelegate?

    func createArcWithWidth(arcWidth : CGFloat, andWindArray dirArray : Array<Int16>)
{

    windArray = dirArray
    let gap = 10.0
    let arcLengh = 45.0 - gap
    var start = 22.5 + (gap/2)
    print(self.frame.size.height)
    let x = self.frame.width/2
    let y = self.frame.height/2
    let center = CGPoint(x: x, y: y)


    for i in 0..<windArray.count {

        let bgPath = UIBezierPath()
        bgPath.addArc(withCenter: center, radius: (x - 10), startAngle: deg2rad(start), endAngle: deg2rad(start + arcLengh), clockwise: true)
       // bgPath.close()
        start = start + arcLengh + gap
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bgPath.cgPath
        shapeLayer.lineWidth = arcWidth
        shapeLayer.name = String(i+1)
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = getColor(Int(windArray[i]))
         self.layer.addSublayer(shapeLayer)
        
        let pathRect = shapeLayer.path!.boundingBoxOfPath
        
        let vi = UIButton(type: .custom)
        vi.frame = pathRect
        if(i == 1 || i == 5) {
            vi.center.y = vi.center.y - ((arcWidth - vi.frame.size.height)/2.0)
            vi.frame.size.height = arcWidth
        }
        if(i == 3 || i == 7) {
            vi.center.x = vi.center.x - ((arcWidth - vi.frame.size.width)/2.0)
            vi.frame.size.width = arcWidth
        }
        vi.backgroundColor = UIColor.clear
        vi.tag = i + 1
        vi.addTarget(self, action: #selector(tapped(_ :)), for: .touchUpInside)
        self.addSubview(vi)
    
    }
}
    
    func getColor(_ value : Int) -> CGColor {
        switch value {
        case -1:
            return UIColor.lightGray.cgColor
        case 0:
            return UIColor.red.cgColor
        case 1:
            return UIColor.init(red: 91/255.0, green: 205/255.0, blue: 31/255.0, alpha: 1.0).cgColor
        default:
            return UIColor.lightGray.cgColor
        }
    }
    
    @objc func tapped(_ sender : Any) {
        for item in self.layer.sublayers! {
            if item.name == "\((sender as! UIButton).tag)" {
                let index = (sender as! UIButton).tag - 1
                if(self.isFilter) {
                    if(windArray[index] == -1) {
                        windArray[index] = 1
                    }
                    else if (windArray[index] == 1) {
                        windArray[index] = -1
                    }
                }
                else {
                    if(windArray[index] == -1) {
                        windArray[index] = 1
                    }
                    else if (windArray[index] == 0) {
                        windArray[index] = 1
                    }
                    else if (windArray[index] == 1) {
                        windArray[index] = 0
                    }
                }
                (item as! CAShapeLayer).strokeColor = getColor(Int(windArray[(sender as! UIButton).tag - 1]))
                self.delegate?.updateWindDirections(windArray)
            }
        }
    }
    
    
    func deg2rad(_ number: Double) -> CGFloat {
        return CGFloat(number * .pi / 180)
    }

}
