//
//  AppDelegate.swift
//  Mario Tennis 50
//
//  Created by David Miller, Matt Mandel, and Eric Wasserman on 11/22/15.
//  Copyright (c) 2015 David Miller, Matt Mandel, and Eric Wasserman. All rights reserved.
//

import Cocoa
import SpriteKit
import Foundation

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var skView: SKView!
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        
        /* Pick a size for the scene */
        if let scene = MainMenuScene(fileNamed:"MainMenuScene") {
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            self.skView!.presentScene(scene)
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            self.skView!.ignoresSiblingOrder = true
            
            self.skView!.showsFPS = true
            self.skView!.showsNodeCount = true
        }
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true
    }
}
