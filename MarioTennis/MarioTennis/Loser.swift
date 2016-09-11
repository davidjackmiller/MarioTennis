//
//  Loser.swift
//  Mario Tennis 50
//
//  Created by David Miller, Matt Mandel, and Eric Wasserman on 12/4/15.
//  Copyright (c) 2015 David Miller, Matt Mandel, and Eric Wasserman. All rights reserved.
//

import SpriteKit
import Foundation
import Darwin

class Loser: SKScene, SKPhysicsContactDelegate {
    
    var victor = GameScene()
    // the loser is victor.winner
    
    var background = SKSpriteNode(imageNamed: "Sad-pug")
    var youLost = SKSpriteNode(imageNamed: "youlost")
    var space = SKSpriteNode(imageNamed: "spacetoplayagain")
    
    override func didMoveToView(view: SKView) {
        
        background.position = CGPoint(x: 512, y: 768/2-10)
        background.zPosition = -1
        background.xScale = 0.5
        background.yScale = 0.5
        addChild(background)
        
        youLost.position = CGPoint(x: 512, y: 650)
        youLost.xScale = 2
        youLost.yScale = 2.5
        addChild(youLost)
        
        // ADD IN AND RENDER SPACE TO PLAY AGAIN
        space.position = CGPoint(x: 512, y: 50)
        addChild(space)
    }
    
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