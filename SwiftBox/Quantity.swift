//
//  Quantity.swift
//  XjSwiftLab
//
//  Created by Jason Jobe on 5/7/15.
//  Copyright (c) 2015 Jason Jobe. All rights reserved.
//

import Foundation


protocol Number {
    func +(l: Self, r: Self) -> Self
//    func doubleValue() -> Double
}

//func - <L :IntegerType, R: IntegerType>(lhs: L, rhs: R) -> Float {
//    return Float(lhs) - Float(rhs)
//}

protocol Number_v {
    func doubleValue() -> Double
}

//func doubleValue<N:IntegerType> (num: N) -> Double {
//    return Double(num)
//}

func -(lhs: Number_v, rhs: Number_v) -> Float {
    return Float(lhs.doubleValue()) - Float(rhs.doubleValue())
}

extension Double : Number {}
extension Float  : Number {}
extension Int    : Number {}

infix operator ⊕ { associativity left precedence 140 }
func ⊕<T: Number>(left: [T], right: [T]) -> [T] {
    var minus = [T]()
    assert(left.count == right.count, "vector of same length only")
    for (key, _) in left.enumerate() {
        minus.append(left[key] + right[key])
    }
    return minus
}

let t = [1, 2, 3] ⊕ [4, 5, 6]

//struct Percent {
//    Float value
//}

struct Unit {
    
}


// weeks[1...3] = 40.hours

enum TimeIntervalUnit {
    case Seconds, Minutes, Hours, Days, Months, Years
    
    func dateComponents(interval: Int) -> NSDateComponents {
        let components:NSDateComponents = NSDateComponents()
        
        switch (self) {
        case .Seconds:
            components.second = interval
        case .Minutes:
            components.minute = interval
        case .Days:
            components.day = interval
        case .Months:
            components.month = interval
        case .Years:
            components.year = interval
        default:
            components.day = interval
        }
        return components
    }
}

class TimeInterval<U>
{
    typealias UnitType = U
    
    var interval: Int
    var unit: UnitType
    
//    var ago: NSDate {
//        var calendar = NSCalendar.currentCalendar()
//        let today = NSDate()
//        var components = unit.dateComponents(-self.interval)
//        return calendar.dateByAddingComponents(components, toDate: today, options: nil)!
//    }
    
    init(interval: Int, unit: UnitType) {
        self.interval = interval
        self.unit = unit
    }
}

/*
//func add <T :TimeInterval, S :TimeInterval where S.UnitType == T.UnitType > (a: T, b: S) -> Int {
//    return a.interval + b.interval
//}
*/

