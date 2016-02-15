//
//  AppDelegate.swift
//  SwiftBoxDemo
//
//  Created by Josh Abernathy on 2/1/15.
//  Copyright (c) 2015 Josh Abernathy. All rights reserved.
//

import Cocoa
import SwiftBox

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
	@IBOutlet weak var window: NSWindow!
    var parentNode: Node!

	func applicationDidFinishLaunching(notification: NSNotification)
    {
        self.window.delegate = self
        
		let contentView = window.contentView! as NSView
		parentNode = Node(size: contentView.frame.size,
                          direction: .Row,
                          childAlignment: .Center,
                          children: [
			Node(flex: 75,
                 margin: Edges(left: 10, right: 10),
                 size: CGSize(width: 0, height: 100), selfAlignment: .Stretch),
			Node(flex: 15,
                 margin: Edges(right: 10),
                 size: CGSize(width: 0, height: 50), selfAlignment: .Stretch),
			Node(flex: 10,
                 margin: Edges(right: 10),
                 size: CGSize(width: 0, height: 180), selfAlignment: .Stretch),
		])

		let layout = parentNode.layout()
		Swift.print(layout)

		layout.apply(contentView)
	}
    
    func windowDidResize(notification: NSNotification) {
        let contentView = window.contentView! as NSView
        parentNode.size = contentView.frame.size
        
        let layout = parentNode.layout()
        //		Swift.print(layout)
        
        layout.apply(contentView)
    }
    
    func initializeLayout() {
    }
}
