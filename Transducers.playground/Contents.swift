//: Playground - noun: a place where people can play

import Cocoa

//
//  Transduce.swift
//  XjSwiftLab
//
//  Created by Jason Jobe on 5/8/15.
//  Copyright (c) 2015 Jason Jobe. All rights reserved.
//

import Foundation
import QuartzCore

enum demo<T> { case a(T), b }

// x |> f = f(x)
infix operator |> {associativity left}
func |> <A, B> (x: A, f: A -> B) -> B {
    return f(x)
}

// (f |> g)(x) = f(g(x))
func |> <A, B, C> (f: A -> B, g: B -> C) -> A -> C {
    return { g(f($0)) }
}

func map <A, B> (f: A -> B) -> [A] -> [B] {
    return { $0.map(f) }
}

func mapping <A, B, C> (f: A -> B) -> ((C, B) -> C) -> ((C, A) -> C) {
    return { reducer in
        return { accum, x in reducer(accum, f(x)) }
    }
}

func append <A> (xs: [A], x: A) -> [A] {
    return xs + [x]
}

func filter <A> (p: A -> Bool) -> [A] -> [A] {
    return {xs in
        var ys = [A]()
        for x in xs {
            if p(x) { ys.append(x) }
        }
        return ys
    }
}

func filtering <A, C> (p: A -> Bool) -> ((C, A) -> C) -> (C, A) -> C {
    return { reducer in
        return { accum, x in
            return p(x) ? reducer(accum, x) : accum
        }
    }
}

func taking <A, C> (n: Int) -> (([C], A) -> [C]) -> (([C], A) -> [C]) {
    return { reducer in
        return { accum, x in
            return accum.count < n ? reducer(accum, x) : accum
        }
    }
}

func measure(title: String!, call: () -> Void) -> CFTimeInterval {
    let startTime = CACurrentMediaTime()
    call()
    let endTime = CACurrentMediaTime()
    if let title = title {
        print("\(title): ", terminator: "")
    }
    print("Time - \(endTime - startTime)")
    let result = endTime - startTime
    
    return result
}

func square (n: Int) -> Int {
    return n * n
}

func incr (n: Int) -> Int {
    return n + 1
}

func isPrime (p: Int) -> Bool {
    if p == 2 { return true }
    for i in 2...Int(sqrtf(Float(p))) {
        if p % i == 0 { return false }
    }
    return true
}

func isTwinPrime (p: Int) -> Bool {
    return isPrime(p) && isPrime(p+2)
}

func pr <T> (value: T) -> Bool {
    print (value)
    return true
}

//func demo () {
    let f: (Float) -> Float = sqrt |> cos |> exp
    let r = f(4.0)
var answer: Float = 0

    let count = 1000
    
    let x = measure ("nested") {
        for x in 1...count {
            answer = exp(cos(sqrt(4.0)))
        }
    }
print (answer)

    let y = measure ("transduced") {
        for x in 1...count {
            answer = 4.0 |> sqrt |> cos |> exp
        }
    }
    print (answer)

    let z = measure ("cached") {
        for x in 1...count {
            answer = f(4.0)
        }
    }
print (answer)

    print("nested/transduced- \(y/x)")
    print("nested/cached- \(z/x)")
    
    let nums =
    (1...200).reduce([],
        combine: append |> filtering(isTwinPrime)
            |> mapping(incr)
            |> mapping(square)
            |> taking(10))
    
    print (nums)
    //            |> mapping(pr))
//}

//demo()

