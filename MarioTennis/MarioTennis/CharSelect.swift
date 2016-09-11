//
//  CharSelect.swift
//  Mario Tennis 50
//
//  Created by David Miller, Matt Mandel, and Eric Wasserman on 11/27/15.
//  Copyright (c) 2015 David Miller, Matt Mandel, and Eric Wasserman. All rights reserved.
//

import SpriteKit
import Darwin

class CharSelect: SKScene, SKPhysicsContactDelegate {
    
    // create variables to cycle through the options
    var selector = "player1"
    var stage = "hard"
    var p1 = "mario"
    var p2 = "mario"
    var s_ball = "tennis"
    
    var state = "select"
    
    // create sprites for the court icons
    var hard = SKSpriteNode(imageNamed: "court-icon-hard")
    var clay = SKSpriteNode(imageNamed: "court-icon-clay")
    var grass = SKSpriteNode(imageNamed: "court-icon-grass")
    var composition = SKSpriteNode(imageNamed: "court-icon-composition")
    var star = SKSpriteNode(imageNamed: "court-icon-star")
    var peach = SKSpriteNode(imageNamed: "court-icon-peach")
    var yoshi = SKSpriteNode(imageNamed: "court-icon-yoshi")
    var dk = SKSpriteNode(imageNamed: "court-icon-dk")
    var wario = SKSpriteNode(imageNamed: "court-icon-wario")
    var random = SKSpriteNode(imageNamed: "court-icon-random")
    
    // create sprites for the ball
    var ball = SKSpriteNode(imageNamed: "ball-tennis")
    var ball_label = SKLabelNode(text:"Tennis")
    
    // create sprites for the player icons
    var p_mario = SKSpriteNode(imageNamed: "mario-mugshot")
    var p_luigi = SKSpriteNode(imageNamed: "luigi-mugshot")
    var p_peach = SKSpriteNode(imageNamed: "peach-mugshot")
    var p_yoshi = SKSpriteNode(imageNamed: "yoshi-mugshot")
    var p_wario = SKSpriteNode(imageNamed: "wario-mugshot")
    var p_waluigi = SKSpriteNode(imageNamed: "waluigi-mugshot")
    
    // create sprites for the arrows pointing to the players
    var p1_sel = SKSpriteNode(imageNamed: "P1")
    var p2_sel = SKSpriteNode(imageNamed: "P2")
    
    // create sprites for toad, his textbox,
    var toad = SKSpriteNode(imageNamed: "toad")
    var tbox = SKSpriteNode(imageNamed: "p1box")
    var curtain = SKSpriteNode(imageNamed: "curtain")
    
    var error = false
    
    // position and render all the sprites
    override func didMoveToView(view: SKView) {
        let scl:CGFloat = 2
        let hgt:CGFloat = 300
        
        // Position all the player pictures on the screen and scale them
        p_mario.position = CGPoint(x: 262, y: 500);     p_mario.xScale = 4;     p_mario.yScale = 4;     addChild(p_mario)
        p_luigi.position = CGPoint(x: 362, y: 500);     p_luigi.xScale = 4;     p_luigi.yScale = 4;     addChild(p_luigi)
        p_peach.position = CGPoint(x: 462, y: 500);     p_peach.xScale = 4;     p_peach.yScale = 4;     addChild(p_peach)
        p_yoshi.position = CGPoint(x: 562, y: 500);     p_yoshi.xScale = 4;     p_yoshi.yScale = 4;     addChild(p_yoshi)
        p_wario.position = CGPoint(x: 662, y: 500);     p_wario.xScale = 4;     p_wario.yScale = 4;     addChild(p_wario)
        p_waluigi.position = CGPoint(x: 762, y: 500);   p_waluigi.xScale = 4;   p_waluigi.yScale = 4;   addChild(p_waluigi)
        
        // Position and render the player select pointers
        p1_sel.position = CGPoint(x: p_mario.position.x, y: p_mario.position.y + 100); addChild(p1_sel)
        p2_sel.position = CGPoint(x: p_mario.position.x, y: p_mario.position.y - 100); addChild(p2_sel)
        
        // Position and render the ball
        ball.position = CGPoint(x: 250, y:hgt-50);      ball.xScale = 3.5;      ball.yScale = 3.5;      addChild(ball)
        ball_label.fontName = "Super Mario 256"
        ball_label.position = CGPoint(x: 250, y: hgt);  addChild(ball_label)
        
        // Position all the court icons on the screen and scale them
        hard.position = CGPoint(x:392, y:hgt);            hard.xScale = scl;          hard.yScale = scl
        clay.position = CGPoint(x:492, y:hgt);            clay.xScale = scl;          clay.yScale = scl
        grass.position = CGPoint(x:592, y:hgt);           grass.xScale = scl;         grass.yScale = scl
        composition.position = CGPoint(x:692, y:hgt);     composition.xScale = scl;   composition.yScale = scl
        random.position = CGPoint(x:792, y:hgt);          random.xScale = scl;        random.yScale = scl
        
        star.position = CGPoint(x:392, y:hgt-50);         star.xScale = scl;          star.yScale = scl
        peach.position = CGPoint(x:492, y:hgt-50);        peach.xScale = scl;         peach.yScale = scl
        yoshi.position = CGPoint(x:592, y:hgt-50);        yoshi.xScale = scl;         yoshi.yScale = scl
        dk.position = CGPoint(x:692, y:hgt-50);           dk.xScale = scl;            dk.yScale = scl
        wario.position = CGPoint(x:792, y:hgt-50);        wario.xScale = scl;         wario.yScale = scl
        
        // Give all the court icons a black color and tint them, except hard since it's by default selected, and render them
        hard.color = .blackColor();         hard.colorBlendFactor = 0.0;            addChild(hard)
        clay.color = .blackColor();         clay.colorBlendFactor = 0.7;            addChild(clay)
        grass.color = .blackColor();        grass.colorBlendFactor = 0.7;           addChild(grass)
        composition.color = .blackColor();  composition.colorBlendFactor = 0.7;     addChild(composition)
        star.color = .blackColor();         star.colorBlendFactor = 0.7;            addChild(star)
        peach.color = .blackColor();        peach.colorBlendFactor = 0.7;           addChild(peach)
        yoshi.color = .blackColor();        yoshi.colorBlendFactor = 0.7;           addChild(yoshi)
        dk.color = .blackColor();           dk.colorBlendFactor = 0.7;              addChild(dk)
        wario.color = .blackColor();        wario.colorBlendFactor = 0.7;           addChild(wario)
        random.color = .blackColor();       random.colorBlendFactor = 0.7;          addChild(random)
        
        // Position and render toad
        toad.position = CGPoint(x: 920, y: 80); addChild(toad)
        tbox.position = CGPoint(x: 430, y: 100); tbox.xScale = 0.9; tbox.yScale = 0.9; addChild(tbox)
        curtain.position = CGPoint(x: 512, y:384); curtain.zPosition = -1; curtain.xScale = 4; curtain.yScale = 3; addChild(curtain)
    }
    
    // When the space key is pressed, transition to the game scene
    override func keyDown(theEvent: NSEvent) {

        // Go to the GameScene if the controls are being displayed and pass it the requisite variables
        if theEvent.keyCode == 49 && state == "controls"
        {
            // transition to the game
            let transition = SKTransition.revealWithDirection(.Down, duration: 1.0)
            let nextScene = GameScene(fileNamed:"GameScene")
            nextScene!.charScene = self
            nextScene!.charScene.stage = stage
            nextScene!.charScene.p1 = p1
            nextScene!.charScene.p2 = p2
            nextScene!.charScene.s_ball = s_ball
            nextScene!.scaleMode = .AspectFill
            scene?.view?.presentScene(nextScene!, transition: transition)
        }
        
        // If you press space on the start option, display the controls diagram
        if state == "select"
        {
            if theEvent.keyCode == 49 && selector == "start" && p1 != p2
            {
                // pick a random stage
                if stage == "random"
                {
                    let diceroll = Int(arc4random_uniform(9)) + 1
                    if diceroll == 1
                    {
                        stage = "hard"
                    }
                    else if diceroll == 2
                    {
                        stage = "clay"
                    }
                    else if diceroll == 3
                    {
                        stage = "grass"
                    }
                    else if diceroll == 4
                    {
                        stage = "composition"
                    }
                    else if diceroll == 5
                    {
                        stage = "star"
                    }
                    else if diceroll == 6
                    {
                        stage = "peach"
                    }
                    else if diceroll == 7
                    {
                        stage = "yoshi"
                    }
                    else if diceroll == 8
                    {
                        stage = "dk"
                    }
                    else if diceroll == 9
                    {
                        stage = "wario"
                    }
                }
                
                let keyboard = SKSpriteNode(imageNamed:"controls")
                keyboard.position = CGPoint(x: 512, y: 768/2)
                keyboard.zPosition = 100
                addChild(keyboard)
                state = "controls"
            }
            
            if theEvent.keyCode == 49 && selector == "start" && p1 == p2
            {
                tbox.runAction(SKAction.setTexture(SKTexture(imageNamed:"errorbox")))
                error = true
                NSTimer.after(3.seconds) {
                    self.error = false
                }
            }
            
            // Use the up and down keys to cycle through the different options
            if theEvent.keyCode == 125
            {
                if selector == "player1"
                {
                    selector = "player2"
                }
                else if selector == "player2"
                {
                    selector = "ball"
                }
                else if selector == "ball"
                {
                    selector = "stage"
                }
                else if selector == "stage"
                {
                    selector = "start"
                }
                else if selector == "start"
                {
                    selector = "player1"
                }
            }
            else if theEvent.keyCode == 126
            {
                if selector == "player1"
                {
                    selector = "start"
                }
                else if selector == "player2"
                {
                    selector = "player1"
                }
                else if selector == "ball"
                {
                    selector = "player2"
                }
                else if selector == "stage"
                {
                    selector = "ball"
                }
                else if selector == "start"
                {
                    selector = "stage"
                }
            }
            
            // Use the left and right keys to cycle through the stages
            if theEvent.keyCode == 124 && selector == "stage"
            {
                if stage == "hard"
                {
                    stage = "clay"
                }
                else if stage == "clay"
                {
                    stage = "grass"
                }
                else if stage == "grass"
                {
                    stage = "composition"
                }
                else if stage == "composition"
                {
                    stage = "random"
                }
                else if stage == "star"
                {
                    stage = "peach"
                }
                else if stage == "peach"
                {
                    stage = "yoshi"
                }
                else if stage == "yoshi"
                {
                    stage = "dk"
                }
                else if stage == "dk"
                {
                    stage = "wario"
                }
                else if stage == "wario"
                {
                    stage = "hard"
                }
                else if stage == "random"
                {
                    stage = "star"
                }
            }
            else if theEvent.keyCode == 123 && selector == "stage"
            {
                if stage == "hard"
                {
                    stage = "wario"
                }
                else if stage == "clay"
                {
                    stage = "hard"
                }
                else if stage == "grass"
                {
                    stage = "clay"
                }
                else if stage == "composition"
                {
                    stage = "grass"
                }
                else if stage == "star"
                {
                    stage = "random"
                }
                else if stage == "peach"
                {
                    stage = "star"
                }
                else if stage == "yoshi"
                {
                    stage = "peach"
                }
                else if stage == "dk"
                {
                    stage = "yoshi"
                }
                else if stage == "wario"
                {
                    stage = "dk"
                }
                else if stage == "random"
                {
                    stage = "composition"
                }
            }
            
            // Use the left and right keys to cycle through the characters for player 1
            if theEvent.keyCode == 124 && selector == "player1"
            {
                if p1 == "mario"
                {
                    p1 = "luigi"
                }
                else if p1 == "luigi"
                {
                    p1 = "peach"
                }
                else if p1 == "peach"
                {
                    p1 = "yoshi"
                }
                else if p1 == "yoshi"
                {
                    p1 = "wario"
                }
                else if p1 == "wario"
                {
                    p1 = "waluigi"
                }
                else if p1 == "waluigi"
                {
                    p1 = "mario"
                }
            }
            else if theEvent.keyCode == 123 && selector == "player1"
            {
                if p1 == "mario"
                {
                    p1 = "waluigi"
                }
                else if p1 == "luigi"
                {
                    p1 = "mario"
                }
                else if p1 == "peach"
                {
                    p1 = "luigi"
                }
                else if p1 == "yoshi"
                {
                    p1 = "peach"
                }
                else if p1 == "wario"
                {
                    p1 = "yoshi"
                }
                else if p1 == "waluigi"
                {
                    p1 = "wario"
                }
            }
            
            // Use the left and right keys to cycle through the characters for player 2
            if theEvent.keyCode == 124 && selector == "player2"
            {
                if p2 == "mario"
                {
                    p2 = "luigi"
                }
                else if p2 == "luigi"
                {
                    p2 = "peach"
                }
                else if p2 == "peach"
                {
                    p2 = "yoshi"
                }
                else if p2 == "yoshi"
                {
                    p2 = "wario"
                }
                else if p2 == "wario"
                {
                    p2 = "waluigi"
                }
                else if p2 == "waluigi"
                {
                    p2 = "mario"
                }
            }
            else if theEvent.keyCode == 123 && selector == "player2"
            {
                if p2 == "mario"
                {
                    p2 = "waluigi"
                }
                else if p2 == "luigi"
                {
                    p2 = "mario"
                }
                else if p2 == "peach"
                {
                    p2 = "luigi"
                }
                else if p2 == "yoshi"
                {
                    p2 = "peach"
                }
                else if p2 == "wario"
                {
                    p2 = "yoshi"
                }
                else if p2 == "waluigi"
                {
                    p2 = "wario"
                }
            }
            
            // Use the left and right keys to cycle through the tennis balls
            if theEvent.keyCode == 124 && selector == "ball"
            {
                if s_ball == "tennis"
                {
                    s_ball = "soccer"
                }
                else if s_ball == "soccer"
                {
                    s_ball = "beach"
                }
                else if s_ball == "beach"
                {
                    s_ball = "basket"
                }
                else if s_ball == "basket"
                {
                    s_ball = "poke"
                }
                else if s_ball == "poke"
                {
                    s_ball = "tennis"
                }
            }
            else if theEvent.keyCode == 123 && selector == "ball"
            {
                if s_ball == "tennis"
                {
                    s_ball = "poke"
                }
                else if s_ball == "soccer"
                {
                    s_ball = "tennis"
                }
                else if s_ball == "beach"
                {
                    s_ball = "soccer"
                }
                else if s_ball == "basket"
                {
                    s_ball = "beach"
                }
                else if s_ball == "poke"
                {
                    s_ball = "basket"
                }
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        
        // Move the player pickers to the character that's currently selected
        if state == "select"
        {
            if selector == "player1" || selector == "player2"
            {
                if p1 == "mario"
                {
                    p1_sel.position = CGPoint(x: p_mario.position.x, y: p_mario.position.y + 100)
                }
                else if p1 == "luigi"
                {
                    p1_sel.position = CGPoint(x: p_luigi.position.x, y: p_luigi.position.y + 100)
                }
                else if p1 == "peach"
                {
                    p1_sel.position = CGPoint(x: p_peach.position.x, y: p_peach.position.y + 100)
                }
                else if p1 == "yoshi"
                {
                    p1_sel.position = CGPoint(x: p_yoshi.position.x, y: p_yoshi.position.y + 100)
                }
                else if p1 == "wario"
                {
                    p1_sel.position = CGPoint(x: p_wario.position.x, y: p_wario.position.y + 100)
                }
                else if p1 == "waluigi"
                {
                    p1_sel.position = CGPoint(x: p_waluigi.position.x, y: p_waluigi.position.y + 100)
                }
                
                if p2 == "mario"
                {
                    p2_sel.position = CGPoint(x: p_mario.position.x, y: p_mario.position.y - 100)
                }
                else if p2 == "luigi"
                {
                    p2_sel.position = CGPoint(x: p_luigi.position.x, y: p_luigi.position.y - 100)
                }
                else if p2 == "peach"
                {
                    p2_sel.position = CGPoint(x: p_peach.position.x, y: p_peach.position.y - 100)
                }
                else if p2 == "yoshi"
                {
                    p2_sel.position = CGPoint(x: p_yoshi.position.x, y: p_yoshi.position.y - 100)
                }
                else if p2 == "wario"
                {
                    p2_sel.position = CGPoint(x: p_wario.position.x, y: p_wario.position.y - 100)
                }
                else if p2 == "waluigi"
                {
                    p2_sel.position = CGPoint(x: p_waluigi.position.x, y: p_waluigi.position.y - 100)
                }
            }
            
            // Highlight the court that's current selected
            if selector == "stage"
            {
                if stage == "hard"
                {
                    hard.colorBlendFactor = 0.0
                    clay.colorBlendFactor = 0.7
                    grass.colorBlendFactor = 0.7
                    composition.colorBlendFactor = 0.7
                    star.colorBlendFactor = 0.7
                    peach.colorBlendFactor = 0.7
                    yoshi.colorBlendFactor = 0.7
                    dk.colorBlendFactor = 0.7
                    wario.colorBlendFactor = 0.7
                    random.colorBlendFactor = 0.7
                }
                else if stage == "clay"
                {
                    hard.colorBlendFactor = 0.7
                    clay.colorBlendFactor = 0.0
                    grass.colorBlendFactor = 0.7
                    composition.colorBlendFactor = 0.7
                    star.colorBlendFactor = 0.7
                    peach.colorBlendFactor = 0.7
                    yoshi.colorBlendFactor = 0.7
                    dk.colorBlendFactor = 0.7
                    wario.colorBlendFactor = 0.7
                    random.colorBlendFactor = 0.7
                }
                else if stage == "grass"
                {
                    hard.colorBlendFactor = 0.7
                    clay.colorBlendFactor = 0.7
                    grass.colorBlendFactor = 0.0
                    composition.colorBlendFactor = 0.7
                    star.colorBlendFactor = 0.7
                    peach.colorBlendFactor = 0.7
                    yoshi.colorBlendFactor = 0.7
                    dk.colorBlendFactor = 0.7
                    wario.colorBlendFactor = 0.7
                    random.colorBlendFactor = 0.7
                }
                else if stage == "composition"
                {
                    hard.colorBlendFactor = 0.7
                    clay.colorBlendFactor = 0.7
                    grass.colorBlendFactor = 0.7
                    composition.colorBlendFactor = 0.0
                    star.colorBlendFactor = 0.7
                    peach.colorBlendFactor = 0.7
                    yoshi.colorBlendFactor = 0.7
                    dk.colorBlendFactor = 0.7
                    wario.colorBlendFactor = 0.7
                    random.colorBlendFactor = 0.7
                }
                else if stage == "star"
                {
                    hard.colorBlendFactor = 0.7
                    clay.colorBlendFactor = 0.7
                    grass.colorBlendFactor = 0.7
                    composition.colorBlendFactor = 0.7
                    star.colorBlendFactor = 0.0
                    peach.colorBlendFactor = 0.7
                    yoshi.colorBlendFactor = 0.7
                    dk.colorBlendFactor = 0.7
                    wario.colorBlendFactor = 0.7
                    random.colorBlendFactor = 0.7
                }
                else if stage == "peach"
                {
                    hard.colorBlendFactor = 0.7
                    clay.colorBlendFactor = 0.7
                    grass.colorBlendFactor = 0.7
                    composition.colorBlendFactor = 0.7
                    star.colorBlendFactor = 0.7
                    peach.colorBlendFactor = 0.0
                    yoshi.colorBlendFactor = 0.7
                    dk.colorBlendFactor = 0.7
                    wario.colorBlendFactor = 0.7
                    random.colorBlendFactor = 0.7
                }
                else if stage == "yoshi"
                {
                    hard.colorBlendFactor = 0.7
                    clay.colorBlendFactor = 0.7
                    grass.colorBlendFactor = 0.7
                    composition.colorBlendFactor = 0.7
                    star.colorBlendFactor = 0.7
                    peach.colorBlendFactor = 0.7
                    yoshi.colorBlendFactor = 0.0
                    dk.colorBlendFactor = 0.7
                    wario.colorBlendFactor = 0.7
                    random.colorBlendFactor = 0.7
                }
                else if stage == "dk"
                {
                    hard.colorBlendFactor = 0.7
                    clay.colorBlendFactor = 0.7
                    grass.colorBlendFactor = 0.7
                    composition.colorBlendFactor = 0.7
                    star.colorBlendFactor = 0.7
                    peach.colorBlendFactor = 0.7
                    yoshi.colorBlendFactor = 0.7
                    dk.colorBlendFactor = 0.0
                    wario.colorBlendFactor = 0.7
                    random.colorBlendFactor = 0.7
                }
                else if stage == "wario"
                {
                    hard.colorBlendFactor = 0.7
                    clay.colorBlendFactor = 0.7
                    grass.colorBlendFactor = 0.7
                    composition.colorBlendFactor = 0.7
                    star.colorBlendFactor = 0.7
                    peach.colorBlendFactor = 0.7
                    yoshi.colorBlendFactor = 0.7
                    dk.colorBlendFactor = 0.7
                    wario.colorBlendFactor = 0.0
                    random.colorBlendFactor = 0.7
                }
                else if stage == "random"
                {
                    hard.colorBlendFactor = 0.7
                    clay.colorBlendFactor = 0.7
                    grass.colorBlendFactor = 0.7
                    composition.colorBlendFactor = 0.7
                    star.colorBlendFactor = 0.7
                    peach.colorBlendFactor = 0.7
                    yoshi.colorBlendFactor = 0.7
                    dk.colorBlendFactor = 0.7
                    wario.colorBlendFactor = 0.7
                    random.colorBlendFactor = 0.0
                }
            }
            
            // Change the ball image according to what's selected
            if selector == "ball"
            {
                ball.runAction(SKAction.setTexture(SKTexture(imageNamed: "ball-" + s_ball)))
                ball_label.text = s_ball
                ball.runAction(SKAction.rotateByAngle(-0.02, duration: 0.1))
            }
            
            // Change the textbox according to the right selector
            if error == false
            {
                if selector == "player1"
                {
                    tbox.runAction(SKAction.setTexture(SKTexture(imageNamed: "p1box")))
                }
                else if selector == "player2"
                {
                    tbox.runAction(SKAction.setTexture(SKTexture(imageNamed: "p2box")))
                }
                else if selector == "ball"
                {
                    tbox.runAction(SKAction.setTexture(SKTexture(imageNamed: "ballbox")))
                }
                else if selector == "stage"
                {
                    tbox.runAction(SKAction.setTexture(SKTexture(imageNamed: "stgbox")))
                }
                else if selector == "start"
                {
                    tbox.runAction(SKAction.setTexture(SKTexture(imageNamed: "strbox")))
                }
            }
        }
    }
}


























