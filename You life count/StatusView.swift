//
//  StatusView.swift
//  You life count
//
//  Created by Roman Filippov on 13.08.16.
//  Copyright © 2016 Roman. All rights reserved.
//

import Cocoa

class StatusView: NSView {
    
    override func draw(_ dirtyRect: NSRect) {
        let ovalPath = NSBezierPath(ovalIn: dirtyRect)
        NSColor.gray.setFill()
        ovalPath.fill()
    }
    
}
