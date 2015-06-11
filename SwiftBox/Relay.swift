//
//  Relay.swift
//  XjSwiftLab
//
//  Created by Jason Jobe on 5/11/15.
//  Copyright (c) 2015 Jason Jobe. All rights reserved.
//

import Foundation

/// the "from" parameter is the original starting sender / target of the relay call

//enum RelayResponse { case Ignored, Accepted, Halt }

protocol Relay
{
    func relay <T> (type: T.Type, to: Any, from: Any?, call: (T) -> Void) -> Void
    func relay <T> (type: T.Type, to: Any, from: Any?, call: (T, Any) -> Void) -> Void
}

protocol RelayHandler {
    func willPerformRelay <T> (type: T.Type, sender: Any) -> Bool
}

func relay <T> (type: T.Type, to: Any, call: (T) -> Void) -> Void
{
    if let target = to as? T {
        call (target)
    }
    else if let target = to as? Relay {
        target.relay (type, to:to, from: nil, call: call)
    }
}

func relay <T> (type: T.Type, from: Any, call: (T, Any) -> Void) -> Void
{
    if let target = from as? T {
        call (target, from)
    }
    else if let target = from as? Relay {
        target.relay(type, to: from, from: from, call: call)
    }
}


#if os(iOS)
    import UIKit.UIResponder
    public typealias Responder = UIResponder
#else
    import AppKit.NSResponder
    public typealias Responder = NSResponder
#endif

extension Responder : Relay, RelayHandler
{
    func willPerformRelay <T> (type: T.Type, sender: Any) -> Bool  {
        return (nextResponder is T)
    }
    
    func relay <T> (type: T.Type, to: Any, from: Any?, call: (T) -> Void) -> Void
    {
        if (nextResponder() != nil) {
            if let target = from as? T {
                call (target)
            }
            else {
                nextResponder()?.relay(type, to: to, from: from, call: call)
            }
        }
    }

    func relay <T> (type: T.Type, to: Any, from: Any?, call: (T, Any) -> Void) -> Void
    {
        if (nextResponder() != nil) {
            if let target = from as? T {
                call (target, from)
            }
            else {
                nextResponder()?.relay(type, to: to, from: from, call: call)
            }
        }
    }
}
