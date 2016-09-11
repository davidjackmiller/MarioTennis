//
//  Victory.swift
//  Mario Tennis 50
//
//  Created by David Miller, Matt Mandel, and Eric Wasserman on 11/30/15.
//  Copyright (c) 2015 David Miller, Matt Mandel, and Eric Wasserman. All rights reserved.
//

import SpriteKit
import Foundation
import Darwin

class Victory: SKScene, SKPhysicsContactDelegate {
    
    var victor = GameScene()
    // the victor is victor.winner
    
    var player = SKSpriteNode(imageNamed: "mario-victory")
    var background = SKSpriteNode(imageNamed: "bg-victory")
    var congrats = SKSpriteNode(imageNamed: "Congratulations")
    var space = SKSpriteNode(imageNamed: "spacetoplayagain")
    
    var confetti = SKSpriteNode(imageNamed: "mario-icon")
    
    override func didMoveToView(view: SKView) {
        player.position = CGPoint(x: 500, y:350)
        player.xScale = 4
        player.yScale = 4
        player.runAction(SKAction.setTexture(SKTexture(imageNamed: victor.winner + "-victory")))
        addChild(player)
        
        var path = NSBundle.mainBundle().pathForResource("RedConfetti", ofType: "sks")
        let red = NSKeyedUnarchiver.unarchiveObjectWithFile(path!) as! SKEmitterNode
            path = NSBundle.mainBundle().pathForResource("BlueConfetti", ofType: "sks")
        let blue = NSKeyedUnarchiver.unarchiveObjectWithFile(path!) as! SKEmitterNode
            path = NSBundle.mainBundle().pathForResource("YellowConfetti", ofType: "sks")
        let yellow = NSKeyedUnarchiver.unarchiveObjectWithFile(path!) as! SKEmitterNode
            path = NSBundle.mainBundle().pathForResource("GreenConfetti", ofType: "sks")
        let green = NSKeyedUnarchiver.unarchiveObjectWithFile(path!) as! SKEmitterNode
        
        red.position = CGPoint(x: 512, y:768)
        blue.position = CGPoint(x: 512, y:768)
        green.position = CGPoint(x: 512, y:768)
        yellow.position = CGPoint(x: 512, y:768)
        
        addChild(red)
        addChild(blue)
        addChild(yellow)
        addChild(green)
        
        background.position = CGPoint(x: 512, y: 768/2)
        background.zPosition = -1
        background.xScale = 1.75
        background.yScale = 1.75
        addChild(background)
        
        congrats.position = CGPoint(x: 512, y: 650)
        congrats.xScale = 2
        congrats.yScale = 2.5
        addChild(congrats)
        
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