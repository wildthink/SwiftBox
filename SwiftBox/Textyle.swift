//
//  Textyle.swift
//  SwiftBox
//
//  Created by Jason Jobe on 6/7/15.
//  Copyright (c) 2015 WildThink. All rights reserved.
//

import Foundation

enum TextMark {
    case H1, H2
    case H (Int)
    case Chapter, Section
    case Str (String)
    case p                  // paragraph
    case tab ([NSTextTab])
    case Body
    case Close
}

class TextStyle {
    var mark : TextMark
    init (mark :TextMark) {
        self.mark = mark
    }
}


struct Text: Printable {
    
    static let scale = 100 / 3
    
    var segments :[TextMark]?
    var actualString: String = ""
    var description: String { return actualString }
    
    //    init (strings: Text...) {
    //        actualString = strings[0].actualString
    //    }
}

extension Text: StringInterpolationConvertible {

    init<T>(stringInterpolationSegment expr: T) {
        actualString = toString(expr)
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
    init(@autoclosure stringInterpolationSegment expr: () -> Int) {
        let value = expr()
        if (0..<4).contains(value) {
            println("Embigening \(value)")
            let numbers = ["zeo","one","two","three"]
            actualString = numbers[value]
        }
        else {
            let r = value * Text.scale
            println("Processing segment: " + toString(r))
            actualString = toString(r)
        }
    }
    
    // finally, this gets called with an array of all of the
    // converted segments
    
    init(stringInterpolation strings: Text...) {
        // strings will be a bunch of Text objects
        actualString = "".join(strings.map { $0.actualString })
    }
}

