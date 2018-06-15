//
//  CalculationsAndConversions.swift
//  BlueWaterCaptain
//
//  Created by Garima Aggarwal on 6/2/18.
//  Copyright © 2018 Garima Aggarwal. All rights reserved.
//

import UIKit

class CalculationsAndConversions: NSObject {

    
    func convertFromDegreeDecimalToDegreeMinutes(_ degree : Double, forType type : String ) -> String {
        
        var decimalComponents = "\(degree)".components(separatedBy: ".")
        let decimal = degree - Double(decimalComponents[0])!
        let minutes = decimal * 60.0
        if(degree >= 0) {
            if(type == "latitude") {
                //return "\(decimalComponents[0])" + "º" + String(format: "%.5f", minutes) + "’ N"
                return "\(decimalComponents[0])" + "º" + "\(minutes.roundToDecimal(5))" + "’ N"
            }
            else {
                return "\(decimalComponents[0])" + "º" + "\(minutes.roundToDecimal(5))" + "’ E"
            }
        }
        else {
            if(type == "latitude") {
                return "\(decimalComponents[0])" + "º" + "\(minutes.roundToDecimal(5))" + "’ S"
            }
            else {
                return "\(decimalComponents[0])" + "º" + "\(minutes.roundToDecimal(5))" + "’ W"
            }
        }
    }
    
    func convertFromDegreeDecimalToDegreeMinutesSeconds(_ degree : Double, forType type : String) -> String {
        var decimalComponents = "\(degree)".components(separatedBy: ".")
        let decimal = degree - Double(decimalComponents[0])!
        let minutes = decimal * 60.0
         var minuteComponents = "\(minutes)".components(separatedBy: ".")
        let decimalMinute = minutes - Double(minuteComponents[0])!
        let seconds = decimalMinute * 60.0
        
        if(degree >= 0) {
            if(type == "latitude") {
                return "\(decimalComponents[0])" + "º" + "\(minuteComponents[0])" + "’"  + "\(seconds.roundToDecimal(2))" + "’’ N"
            }
            else {
                return "\(decimalComponents[0])" + "º" + "\(minuteComponents[0])" + "’"  + "\(seconds.roundToDecimal(2))" + "’’ E"
            }
        }
        else {
            if(type == "latitude") {
               return "\(decimalComponents[0])" + "º" + "\(minuteComponents[0])" + "’"  + "\(seconds.roundToDecimal(2))" + "’’ S"
            }
            else {
                return "\(decimalComponents[0])" + "º" + "\(minuteComponents[0])" + "’"  + "\(seconds.roundToDecimal(2))" + "’’ W"
            }
        }
        
    }
    
    func convertMetreToFeet(_ metres : Double) -> String{
        return String(format: "%.2f", (metres * 3.28)) 
    }
    
}

//extension Double {
//    func roundToDecimal(_ fractionDigits: Int) -> Double {
//        let multiplier = pow(10, Double(fractionDigits))
//        return Darwin.round(self * multiplier) / multiplier
//    }
//}
