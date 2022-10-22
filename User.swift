//
//  MainLogic.swift
//  clr.
//
//  Created by Arjun Dalwadi on 10/10/22.
//

import Foundation
import Darwin
import SwiftUI

class User {
    private var pin = ""
    private var initialRate = 0.0
    private var finalRate = 0.0
    private var numDays = 0.0
    public var dailyPuffs:[Int] = []
    public var dailyPuffsEdit:[Int] = []
    
    func setPin(_ p: String) {
        pin = p
        userData.set(p, forKey: "Pin")
    }
    
    func setData(ir:Double, er:Double, nd:Double){
        initialRate = ir * 200
        finalRate = er * 200
        numDays = nd
        
        userData.set(calendar.startOfDay(for: Date()), forKey: "StartDate")
        
        
        buildTrendline()
    }
    
    func buildTrendline(){
        
        dailyPuffs = Array(repeating: 0, count: Int(numDays))
        
        var day = 0.0
        while Int(day) < dailyPuffs.count - 1{
            let a = Double.random(in: 10...50)
            let b = abs((finalRate - initialRate)) + a
            let result = pow((b/a), (day/numDays))
            dailyPuffs[Int(day)] = Int((b - a*result) + finalRate)
            day += 1
        }
        
        dailyPuffs[Int(numDays) - 1] = Int(finalRate)
        userData.set(dailyPuffs, forKey: "DailyPuffsArray")
        
        dailyPuffsEdit = dailyPuffs
        userData.set(dailyPuffsEdit, forKey: "EditableDPArray")
    }
    
}


