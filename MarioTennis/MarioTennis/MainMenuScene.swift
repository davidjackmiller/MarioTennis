//
//  MainMenuScene.swift
//  Mario Tennis 50
//
//  Created by David Miller, Matt Mandel, and Eric Wasserman on 11/22/15.
//  Copyright (c) 2015 David Miller, Matt Mandel, and Eric Wasserman. All rights reserved.
//

import SpriteKit
import Darwin

class MainMenuScene: SKScene, SKPhysicsContactDelegate {
    
    // create sprites for the requisite graphics
    var title = SKSpriteNode(imageNamed: "titlescreen")
    var space = SKSpriteNode(imageNamed: "pressspace")
    var citations = SKSpriteNode(imageNamed: "citations")
    var cs50 = SKSpriteNode(imageNamed: "cs50")
    
    // position and render all the graphics
    override func didMoveToView(view: SKView) {
        title.position = CGPoint(x: 512, y: 300)
        title.zPosition = 0
        title.xScale = 7
        title.yScale = 7
        addChild(title)
        
        space.position = CGPoint(x: 512, y: 205)
        space.zPosition = 1
        space.xScale = 1
        space.yScale = 1
        addChild(space)
        
        citations.position = CGPoint(x: 512, y: 30)
        citations.zPosition = 3
        addChild(citations)
        
        cs50.position = CGPoint(x: 740, y: 665)
        cs50.zPosition = 2
        cs50.zRotation = -0.1
        cs50.xScale = 2
        cs50.yScale = 2
        addChild(cs50)
    }
    
    // When the space key is pressed, transition to the character select screen
    override func keyDown(theEvent: NSEvent) {
        if theEvent.keyCode == 49
        {
            let transition = SKTransition.revealWithDirection(.Down, duration: 1.0)
            let nextScene = CharSelect(fileNamed:"CharSelect")
            nextScene?.scaleMode = .AspectFill
            scene?.view?.presentScene(nextScene!, transition: transition)
        }
    }
}