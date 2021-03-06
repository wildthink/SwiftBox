//
//  Textyle.swift
//  
//
//  Created by Jason Jobe on 6/7/15.
//
//

import Foundation

enum TextMark {
    case H1, H2
    case H (Int)
    case S (String)
    case Body, Close
}

class TextStyle {
    var mark : TextMark
    init (mark :TextMark) {
        self.mark = mark
    }
}


struct Text: Printable {
    
    static let scale = 100 / 3

    var actualString: String = ""
    var segments : [TextMark]
    var description: String { return actualString }
    
    //    init (strings: Text...) {
    //        actualString = strings[0].actualString
    //    }
}

func << (lhs :Text, rhs :Text) -> Text {
    return Text (stringInterpolation: lhs, rhs)
}

extension Text: StringInterpolationConvertible {
    // first, this will get called for each "segment"
    init<T>(stringInterpolationSegment expr: T) {
        println("Processing segment: " + toString(expr))
        actualString = toString(expr)
    }
    
    init (stringInterpolationSegment expr: TextMark) {
        println("MarkIt: " + toString(expr))
        actualString = "(style \(expr))"
    }
    
    init (stringInterpolationSegment expr: NSTextTab) {
        actualString = "(tab \(expr))"
    }
    
    init (stringInterpolationSegment expr: [NSTextTab]) {
        actualString = "(tabs \(expr))"
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
