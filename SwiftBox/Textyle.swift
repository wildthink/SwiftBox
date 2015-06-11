//
//  Textyle.swift
//  SwiftBox
//
//  Created by Jason Jobe on 6/7/15.
//  Copyright (c) 2015 WildThink. All rights reserved.
//
import Foundation

protocol TextStylable {
}

protocol TextFormatable {
}


enum TextMark {
    case H1, H2
    case H (Int)
    case Chapter, Section
    case Str (String)
    case p                  // paragraph
    case tab ([NSTextTab])
    case Body
    case Close
    
    // Common
}


class TextStyles {
    var mark : TextMark
    var attributes :[String:String]

    init (mark :TextMark, attributes:[String:String]) {
        self.mark = mark
        self.attributes = attributes
    }
}

class TextFormat {
    var formatter : NSFormatter
    init (formatter :NSFormatter) {
        self.formatter = formatter
    }
    var attributes :[String:String]?
}

struct Text: CustomStringConvertible {

    var segments :[TextMark]?
    var actualString: String = ""
    var description: String { return actualString }
    
    //    init (strings: Text...) {
    //        actualString = strings[0].actualString
    //    }
}

extension Text {
    func attributedString (styles :[TextStyles], formatters: [TextFormat]) -> NSAttributedString
    {
        return NSAttributedString (string: self.description)
    }
}

extension Text: StringInterpolationConvertible {

    init<T>(stringInterpolationSegment expr: T) {
        actualString = String(expr)
        segments = [.Str(actualString)]
    }
    
    init (stringInterpolationSegment expr: TextMark) {
        segments = [expr]
    }
    
    init (stringInterpolationSegment expr: NSTextTab) {
        segments = [.tab([expr])]
    }
    
    init (stringInterpolationSegment expr: [NSTextTab]) {
        segments = [.tab(expr)]
    }
    
    // here is a type-specific override for Int, that coverts
    // small numbers into words:
    // Demonstratio
    init(@autoclosure stringInterpolationSegment expr: () -> Int) {
        let value = expr()
        if (0..<4).contains(value) {
            print("Embigening \(value)")
            let numbers = ["zeo","one","two","three"]
            actualString = numbers[value]
        }
        else {
            print("Processing segment: " + String(value))
            actualString = String(value)
        }
    }
    
    // finally, this gets called with an array of all of the
    // converted segments
    
    init(stringInterpolation strings: Text...) {
        // strings will be a bunch of Text objects
        actualString = "".join(strings.map { $0.actualString })
    }
}

