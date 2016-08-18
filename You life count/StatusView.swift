//
//  StatusView.swift
//  You life count
//
//  Created by Roman Filippov on 13.08.16.
//  Copyright © 2016 Roman. All rights reserved.
//

import Cocoa

class StatusView: NSView {
    
    override func drawRect(dirtyRect: NSRect) {
        let ovalPath = NSBezierPath(ovalInRect: dirtyRect)
        NSColor.grayColor().setFill()
        ovalPath.fill()
    }
    
}
