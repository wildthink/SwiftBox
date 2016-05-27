//
//  XPArchiving.swift
//  SwiftBox
//
//  Created by Jason Jobe on 7/24/15.
//  Copyright © 2015 WildThink. All rights reserved.
//

import Foundation

#if os(OSX)
    public typealias Color = NSColor
    public typealias Image = NSImage
    #else
    public typealias Color = UIColor
    public typealias Image = UIImage
#endif

class XPArchiver: NSKeyedArchiver {
    override func encodeObject(object: AnyObject?) {
        
        if (object?.isKindOfClass(Image) != nil) {
            
        }
        super.encodeObject(object)
    }
    
    override func encodeObject(objv: AnyObject?, forKey key: String) {
        super.encodeObject(objv, forKey: key)
    }
}

class XPUnarchver: NSKeyedUnarchiver {
    override func decodeObject() -> AnyObject? {
        return super.decodeObject()
    }
    
    override func decodeObjectForKey(key: String) -> AnyObject? {
        return super.decodeObjectForKey(key)
    }
}

