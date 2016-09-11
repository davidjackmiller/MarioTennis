//
//  GameScene.swift
//  Mario Tennis 50
//
//  Created by David Miller, Matt Mandel, and Eric Wasserman on 11/22/15.
//  Copyright (c) 2015 David Miller, Matt Mandel, and Eric Wasserman. All rights reserved.
//

import SpriteKit
import Darwin

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Import the CharSelect scene so you can access the stage picked in it
    var charScene = CharSelect()
    
    // Make a variable for how much player's should slide
    // This could eventually be dependent on which court is being played on and character
    let FRICTION:CGFloat = 1.15
    
    // Define a tick variable to count frames
    var tick = 0
    
    // Make a map to keep track of which keys are being pressed
    var map = ["left": false, "right": false, "down": false, "up": false, "space": false, "v": false]
    
    // Make a variable to find where the ball will hit the line y = 600
    var prediction:CGFloat = 0;
    
    // Make a variable to be used for randomization
    var diceroll = Int(arc4random_uniform(100))
    
    // Make a variable for the winner
    var winner = "no one"
    
    // Make a variable for who is serving
    var server = "player"
    
    // Make a function for setting up a serve scenario
    func setUpServe() {
        if server == "player" {
            player.serving = 1
            opponent.serving = 0
        }
        else if server == "opponent" {
            player.serving = 0
            opponent.serving = 1
        }
        player.xVel = 0
        player.yVel = 0
        player.position = CGPoint(x:683, y:169)
        player.xScale = 4
        opponent.xVel = 0
        opponent.yVel = 0
        opponent.position = CGPoint(x:360, y:630)
        opponent.xScale = 4
        
        ball.xScale = 1
        ball.yScale = 1
        
        ball.special = "normal"
        
        player.special = "none"
        player.meter = 0
        opponent.special = "none"
        opponent.meter = 0
        
        if (server == "player")
        {
            player.runAction(SKAction.setTexture(SKTexture(imageNamed: player.character + "-serve-1r")))
            opponent.runAction(SKAction.setTexture(SKTexture(imageNamed: opponent.character + "-idle")))
        }
        else
        {
            player.runAction(SKAction.setTexture(SKTexture(imageNamed: player.character + "-idle-u")))
            opponent.runAction(SKAction.setTexture(SKTexture(imageNamed: opponent.character + "-serve-1l")))
        }
    }
    
    func getPoint(who: String) {
        if who == "player"
        {
            if player.points == 0
            {
                player.points = 15
            }
            else if player.points == 15
            {
                player.points = 30
            }
            else if player.points == 30
            {
                player.points = 40
            }
            else if player.points == 40
            {
                if opponent.points == 40
                {
                    player.points = 50
                }
                else if opponent.points == 50
                {
                    opponent.points = 40
                }
                else
                {
                    player.points = 0
                    opponent.points = 0
                    player.games++
                    if (server == "player")
                    {
                        server = "opponent"
                    }
                    else if (server == "opponent")
                    {
                        server = "player"
                    }
                }
            }
            else if player.points == 50
            {
                player.points = 0
                opponent.points = 0
                player.games++
                if (server == "player")
                {
                    server = "opponent"
                }
                else if (server == "opponent")
                {
                    server = "player"
                }
            }
        }
        else if who == "opponent"
        {
            if opponent.points == 0
            {
                opponent.points = 15
            }
            else if opponent.points == 15
            {
                opponent.points = 30
            }
            else if opponent.points == 30
            {
                opponent.points = 40
            }
            else if opponent.points == 40
            {
                if player.points == 40
                {
                    opponent.points = 50
                }
                else if player.points == 50
                {
                    player.points = 40
                }
                else
                {
                    opponent.points = 0
                    player.points = 0
                    opponent.games++
                    if (server == "player")
                    {
                        server = "opponent"
                    }
                    else if (server == "opponent")
                    {
                        server = "player"
                    }
                }
            }
            else if opponent.points == 50
            {
                opponent.points = 0
                player.points = 0
                opponent.games++
                if (server == "player")
                {
                    server = "opponent"
                }
                else if (server == "opponent")
                {
                    server = "player"
                }
            }
        }
    }
    
    // Make a function to call when someone wins which takes in who won
    func winGame(who: String) {
        let transition = SKTransition.revealWithDirection(.Down, duration: 1.0)
        if who == "player"
        {
            let nextScene = Victory(fileNamed:"Victory")
            nextScene!.victor = self
            nextScene!.victor.winner = player.character
            nextScene!.scaleMode = .AspectFill
            scene?.view?.presentScene(nextScene!, transition: transition)
        }
        else
        {
            let nextScene = Loser(fileNamed:"Loser")
            nextScene!.victor = self
            nextScene!.victor.winner = opponent.character
            nextScene!.scaleMode = .AspectFill
            scene?.view?.presentScene(nextScene!, transition: transition)
        }
    }
    
    func updateScore(playerScore: Int, opponentScore: Int, playergames: Int, opponentgames: Int) {
        player_score.runAction(SKAction.setTexture(SKTexture(imageNamed: String(playerScore))))
        opponent_score.runAction(SKAction.setTexture(SKTexture(imageNamed: String(opponentScore))))
        
        player_games.runAction(SKAction.setTexture(SKTexture(imageNamed: String(playergames))))
        opponent_games.runAction(SKAction.setTexture(SKTexture(imageNamed: String(opponentgames))))
    }
    
    // Enumerate the different collision types
    enum CollisionType: UInt32 {
        case Ball = 1
        case Character = 2
    }
    
    // Create a BallSpriteNode class which extends a standard SpriteNode
    class BallSpriteNode: SKSpriteNode {
        var xVel:CGFloat = 0.0
        var yVel:CGFloat = 0.0
        var type = "tennis"
        var contact = false
        var returning = true
        
        var hearts = SKEmitterNode(fileNamed:"Hearts.sks")
        var farts = SKEmitterNode(fileNamed: "Farts.sks")
        var rbow = SKEmitterNode(fileNamed:"Rainbow.sks")
        
        var special = "normal"
        
        // make two bools to check if the ball passed two checkpoints
        var chkpt = false
        
        func backToServe(curServer: String)
        {
            self.xVel = 0
            self.yVel = 0
            if (curServer == "player"){
                self.position = CGPoint(x: 696.32, y: 192)
            }
            else if (curServer == "opponent") {
                self.position = CGPoint(x:365, y:617)
            }
        }
        
        func peachHeart()
        {
            self.color = .magentaColor();   self.colorBlendFactor = 1
            hearts = SKEmitterNode(fileNamed:"Hearts.sks")
            self.hearts!.numParticlesToEmit = 1
            self.hearts!.targetNode = self
            addChild(self.hearts!)
        }
        
        func warioFarts()
        {
            self.color = .greenColor();     self.colorBlendFactor = 1
            farts = SKEmitterNode(fileNamed:"Farts.sks")
            if self.position.y > 600
            {
                self.farts!.numParticlesToEmit = 1
                self.farts!.particleLifetime = 0.1
            }
            else
            {
                self.farts!.numParticlesToEmit = 50
                self.farts!.particleLifetime = 1
            }
            addChild(self.farts!)
        }
    }
    
    // Build upon SKSpriteNode and make CharacterSpriteNode
    class CharacterSpriteNode: SKSpriteNode {
        var xVel:CGFloat = 0.0
        var yVel:CGFloat = 0.0
        var character = "mario"
        var charge:CGFloat = 0
        var charging = 0
        var swinging = false
        var serving = 1
        var swing_anim = false
        
        var foreHand = true
        
        var meter:CGFloat = 0
        var special = "none"
        
        var points = 0           // 15, 30, 40 to win game
        var games = 0            // first to 3 games wins
        
        func animateWalkRight(tick: Int)
        {
            if self.serving == 0 && self.swing_anim == false
            {
                if tick % 12 < 6
                {
                    self.runAction(SKAction.setTexture(SKTexture(imageNamed: self.character + "-walk-1r")))
                }
                else
                {
                    self.runAction(SKAction.setTexture(SKTexture(imageNamed: self.character + "-walk-2r")))
                }
            }
        }
        
        func animateWalkLeft(tick: Int)
        {
            if self.serving == 0 && self.swing_anim == false
            {
                if tick % 12 < 6
                {
                    self.runAction(SKAction.setTexture(SKTexture(imageNamed: self.character + "-walk-1l")))
                }
                else
                {
                    self.runAction(SKAction.setTexture(SKTexture(imageNamed: self.character + "-walk-2l")))
                }
            }
        }
        
        /* For AI opponent */
        func returnBall () {
            NSTimer.after(0.3.seconds) {
                self.runAction(SKAction.setTexture(SKTexture(imageNamed: self.character + "-charge-1l")))
                self.xScale = 4
            }
            NSTimer.after(0.4.seconds) {
                self.runAction(SKAction.setTexture(SKTexture(imageNamed: self.character + "-charge-2l")))
                self.xScale = 80/15
            }
            NSTimer.after(0.6.seconds) {
                self.runAction(SKAction.setTexture(SKTexture(imageNamed: self.character + "-charge-3l")))
                self.xScale = 4
            }
            NSTimer.after(0.8.seconds) {
                self.runAction(SKAction.setTexture(SKTexture(imageNamed: self.character + "-idle")))
                self.xScale = 4
            }
        }
        
        func walkCenter (tick: Int) {
            if self.serving == 0
            {
                let dx:CGFloat = (525 - self.position.x)/50
                let dy:CGFloat = (600 - self.position.y)/50
                if dx > 0.5 && self.swing_anim == false
                {
                    animateWalkRight(tick)
                }
                else if dx < -0.5 && self.swing_anim == false
                {
                    animateWalkLeft(tick)
                }
                else if self.swing_anim == false
                {
                    self.runAction(SKAction.setTexture(SKTexture(imageNamed: self.character + "-idle")))
                }
                self.runAction(SKAction.moveByX(dx, y:dy, duration: 0.0))
            }
        }
        
        func interceptBall (prediction: CGFloat, ball_pos: CGFloat, tick: Int) {
            if self.serving == 0
            {
                let dx:CGFloat = (prediction + 30 - self.position.x)/50
                let dy:CGFloat = (600 - self.position.y)/50
                if dx > 0.5 && self.swing_anim == false
                {
                    animateWalkRight(tick)
                }
                else if dx < -0.5 && self.swing_anim == false
                {
                    animateWalkLeft(tick)
                }
                else if self.swing_anim == false
                {
                    self.runAction(SKAction.setTexture(SKTexture(imageNamed: self.character + "-charge-1l")))
                    self.xScale = 4
                }
                self.runAction(SKAction.moveByX(dx, y:dy, duration: 0.0))
            }
        }
        
        /* For player */
        func walkRight (tick: Int, map:Dictionary<String, Bool>) {
            self.xVel++
            if tick % 12 < 6
            {
                if map["up"] == true
                {
                    self.runAction(SKAction.setTexture(SKTexture(imageNamed: self.character + "-walk-1ur")))
                }
                else if map["down"] == true
                {
                    self.runAction(SKAction.setTexture(SKTexture(imageNamed: self.character + "-walk-1dr")))
                }
                else
                {
                    self.runAction(SKAction.setTexture(SKTexture(imageNamed: self.character + "-walk-1r")))
                }
                self.xScale = 4
            }
            else
            {
                if map["up"] == true
                {
                    self.runAction(SKAction.setTexture(SKTexture(imageNamed: self.character + "-walk-2ur")))
                }
                else if map["down"] == true
                {
                    self.runAction(SKAction.setTexture(SKTexture(imageNamed: self.character + "-walk-2dr")))
                }
                else
                {
                    self.runAction(SKAction.setTexture(SKTexture(imageNamed: self.character + "-walk-2r")))
                }
                self.xScale = 80/17
            }
        }
        
        func walkLeft (tick: Int, map: Dictionary<String, Bool>) {
            self.xVel--
            if tick % 12 < 6
            {
                if map["up"] == true
                {
                    self.runAction(SKAction.setTexture(SKTexture(imageNamed: self.character + "-walk-1ul")))
                }
                else if map["down"] == true
                {
                    self.runAction(SKAction.setTexture(SKTexture(imageNamed: self.character + "-walk-1dl")))
                }
                else
                {
                    self.runAction(SKAction.setTexture(SKTexture(imageNamed: self.character + "-walk-1l")))
                }
                self.xScale = 4
            }
            else
            {
                if map["up"] == true
                {
                    self.runAction(SKAction.setTexture(SKTexture(imageNamed: self.character + "-walk-2ul")))
                }
                else if map["down"] == true
                {
                    self.runAction(SKAction.setTexture(SKTexture(imageNamed: self.character + "-walk-2dl")))
                }
                else
                {
                    self.runAction(SKAction.setTexture(SKTexture(imageNamed: self.character + "-walk-2l")))
                }
                self.xScale = 80/17
            }
        }
        
        func walkUp (tick: Int, map: Dictionary<String, Bool>) {
            self.yVel++
            self.xScale = 4
            if tick % 12 < 6
            {
                self.runAction(SKAction.setTexture(SKTexture(imageNamed: self.character + "-walk-1u")))
            }
            else
            {
                self.runAction(SKAction.setTexture(SKTexture(imageNamed: self.character + "-walk-2u")))
            }
        }
        
        func walkDown (tick: Int, map: Dictionary<String, Bool>) {
            self.yVel--
            self.xScale = 4
            if tick % 12 < 6
            {
                self.runAction(SKAction.setTexture(SKTexture(imageNamed: self.character + "-walk-1d")))
            }
            else
            {
                self.runAction(SKAction.setTexture(SKTexture(imageNamed: self.character + "-walk-2d")))
            }
        }
    }
    
    // Make the player, opponent, ball, and icons to go next to score (court is in render)
    var player = CharacterSpriteNode(imageNamed:"mario-serve-1r")
    var opponent = CharacterSpriteNode(imageNamed:"luigi-idle")
    var ball = BallSpriteNode(imageNamed:"ball-tennis")
    var player_icon = SKSpriteNode(imageNamed: "mario-icon")
    var player_score = SKSpriteNode(imageNamed:"0")
    var opponent_icon = SKSpriteNode(imageNamed:"luigi-icon")
    var opponent_score = SKSpriteNode(imageNamed:"0")
    var player_games = SKSpriteNode(imageNamed:"0")
    var opponent_games = SKSpriteNode(imageNamed:"0")
    
    // Make two balls for waluigi's special shot
    var dup_ball_1 = BallSpriteNode(imageNamed:"ball-tennis")
    var dup_ball_2 = BallSpriteNode(imageNamed:"ball-tennis")
    
    // Render the player, opponent, tennis ball and court
    override func didMoveToView(view: SKView) {
        
        // Set the current scene as the physics world
        physicsWorld.contactDelegate = self
        
        let skView = self.view //as! SKView
        skView?.showsFPS = false
        skView?.showsNodeCount = false
        skView?.showsPhysics = false
        skView?.ignoresSiblingOrder = true
        
        /* Make icons to display next to the points */
        player_icon.position = CGPoint(x:50, y:50)
        player_icon.zPosition = 5
        player_icon.xScale = 4
        player_icon.yScale = 4
        addChild(player_icon)
        player_icon.runAction(SKAction.setTexture(SKTexture(imageNamed: charScene.p1 + "-icon")))
        opponent_icon.position = CGPoint(x:974, y:718)
        player.zPosition = 6
        opponent_icon.xScale = 4
        opponent_icon.yScale = 4
        addChild(opponent_icon)
        opponent_icon.runAction(SKAction.setTexture(SKTexture(imageNamed: charScene.p2 + "-icon")))
        
        /* Make scores to display next to the icons */
        player_score.position = CGPoint(x:140, y:50)
        player_score.zPosition = 7
        player_score.xScale = 3
        player_score.yScale = 3
        addChild(player_score)
        opponent_score.position = CGPoint(x:885, y:718)
        opponent_score.zPosition = 8
        opponent_score.xScale = 3
        opponent_score.yScale = 3
        addChild(opponent_score)
        
        /* Make games scores to display next to player icons */
        player_games.position = CGPoint(x:80, y:25)
        player_games.zPosition = 9
        player_games.xScale = 1.5
        player_games.yScale = 1.5
        addChild(player_games)
        opponent_games.position = CGPoint(x: 945, y:690)
        opponent_games.zPosition = 10
        opponent_games.xScale = 1.5
        opponent_games.yScale = 1.5
        addChild(opponent_games)
        
        /* Make the background the court */
        let court = SKSpriteNode(imageNamed:"court-" + charScene.stage)
        court.position = CGPoint(x: 512, y: 384)
        court.zPosition = -3
        court.xScale = 4
        court.yScale = 4
        addChild(court)
        
        /* Put the player in the bottom center */
        player.position = CGPoint(x: 683, y: 169)
        player.character = charScene.p1
        player.zPosition = 0
        player.xScale = 4
        player.yScale = 4
        player.physicsBody = SKPhysicsBody(circleOfRadius: 15, center: CGPoint(x: 20, y: 0))
        player.physicsBody?.dynamic = false
        player.physicsBody?.affectedByGravity = false
        player.physicsBody!.categoryBitMask = CollisionType.Character.rawValue
        player.physicsBody!.collisionBitMask = 0
        player.physicsBody!.contactTestBitMask = CollisionType.Ball.rawValue
        addChild(player)
        player.runAction(SKAction.setTexture(SKTexture(imageNamed: charScene.p1 + "-serve-1r")))
        
        /* Put the opponent in the top left */
        opponent.position = CGPoint(x: 360, y: 630)
        opponent.character = charScene.p2
        opponent.zPosition = -2
        opponent.xScale = 4
        opponent.yScale = 4
        opponent.physicsBody = SKPhysicsBody(circleOfRadius: 15, center: CGPoint(x: -20, y: 0))
        opponent.physicsBody?.dynamic = false
        opponent.physicsBody?.affectedByGravity = false
        opponent.physicsBody!.categoryBitMask = CollisionType.Character.rawValue
        opponent.physicsBody!.collisionBitMask = 0
        opponent.physicsBody!.contactTestBitMask = CollisionType.Ball.rawValue
        addChild(opponent)
        opponent.runAction(SKAction.setTexture(SKTexture(imageNamed: charScene.p2 + "-idle")))
        
        /* Put the tennis ball in front of the player */
        ball.position = CGPoint(x: 696.32, y: 192)
        ball.zPosition = -1
        ball.type = charScene.s_ball
        ball.xScale = 1
        ball.yScale = 1
        ball.xVel = 0
        ball.yVel = 0
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        ball.physicsBody?.dynamic = true
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody!.categoryBitMask = CollisionType.Ball.rawValue
        ball.physicsBody!.collisionBitMask = 0
        ball.physicsBody!.contactTestBitMask = CollisionType.Character.rawValue
        ball.runAction(SKAction.setTexture(SKTexture(imageNamed: "ball-" + charScene.s_ball)))
        addChild(ball)
        
        dup_ball_1.position = CGPoint(x: 100, y: 100)
        dup_ball_2.position = CGPoint(x: 100, y: 200)
        dup_ball_1.runAction(SKAction.setTexture(SKTexture(imageNamed: "ball-" + charScene.s_ball)))
        dup_ball_2.runAction(SKAction.setTexture(SKTexture(imageNamed: "ball-" + charScene.s_ball)))
        dup_ball_1.zPosition = -1.1
        dup_ball_2.zPosition = -0.9
        addChild(dup_ball_1)
        addChild(dup_ball_2)
        
        setUpServe()
    }
    
    // Change the ball's contact attribute when it begins and ends contact
    func didBeginContact(contact: SKPhysicsContact) {
        // this gets called automatically when two objects begin contact
        ball.contact = true
    }
    func didEndContact(contact: SKPhysicsContact) {
        // this gets called automatically when two objects end contact
        ball.contact = false
    }
    
    // When a key is pressed, make the according value in map true
     override func keyDown(theEvent: NSEvent) {
        if theEvent.keyCode == 123
        {
            map["left"] = true
        }
        if theEvent.keyCode == 124
        {
            map["right"] = true
        }
        if theEvent.keyCode == 125
        {
            map["down"] = true
        }
        if theEvent.keyCode == 126
        {
            map["up"] = true
        }
        if theEvent.keyCode == 49
        {
            map["space"] = true
        }
        if theEvent.keyCode == 9
        {
            map["v"] = true
        }
        
        if theEvent.keyCode == 17
        {
            let transition = SKTransition.revealWithDirection(.Down, duration: 1.0)
            let nextScene = MainMenuScene(fileNamed:"MainMenuScene")
            nextScene?.scaleMode = .AspectFill
            scene?.view?.presentScene(nextScene!, transition: transition)
        }
    }
    
    // When a key is released, make the according value in map false
    override func keyUp(theEvent: NSEvent) {
        if theEvent.keyCode == 123
        {
            map["left"] = false
        }
        if theEvent.keyCode == 124
        {
            map["right"] = false
        }
        if theEvent.keyCode == 125
        {
            map["down"] = false
        }
        if theEvent.keyCode == 126
        {
            map["up"] = false
        }
        if theEvent.keyCode == 49
        {
            map["space"] = false
        }
        if theEvent.keyCode == 9
        {
            map["v"] = false
        }
    }
    
    // Repeat at every frame update
    override func update(currentTime: CFTimeInterval) {
        
        // Increment the tick
        tick++
        
        // Check forehand
        if player.xVel > 0
        {
            player.foreHand = true
        }
        else if player.xVel < 0
        {
            player.foreHand = false
        }
        
        // Regulate player.special depending on the meter
        if player.meter >= 3000 && player.special != "active"
        {
            player.meter = 3000
            player.special = "available"
        }
        else if player.special != "active"
        {
            player.special = "none"
            player.colorBlendFactor = 0
        }
        
        // Special shots
        if ball.special == "normal"
        {
            ball.runAction(SKAction.setTexture(SKTexture(imageNamed: "ball-" + charScene.s_ball)))
            ball.runAction(SKAction.rotateByAngle(0.1, duration: 0.1))
            ball.colorBlendFactor = 0
            ball.alpha = 1;         dup_ball_1.alpha = 0;       dup_ball_2.alpha = 0
        }
        else if ball.special == "mario"
        {
            ball.xScale = 5
            ball.yScale = 3
            
            if ball.yVel > 0
            {
                ball.zRotation = atan(ball.yVel/ball.xVel)
                if ball.zRotation < 0
                {
                    ball.zRotation += 3.14159
                }
            }
            else
            {
                ball.zRotation = atan(ball.yVel/ball.xVel)
                if ball.zRotation < 0
                {
                    ball.zRotation += 3.14159
                }
                ball.zRotation = -ball.zRotation
            }
            
            let frame = tick % 30
            if frame <= 6
            {
                ball.runAction(SKAction.setTexture(SKTexture(imageNamed: "fireball-1")))
            }
            else if frame > 6 && frame <= 12
            {
                ball.runAction(SKAction.setTexture(SKTexture(imageNamed: "fireball-2")))
            }
            else if frame > 12 && frame <= 18
            {
                ball.runAction(SKAction.setTexture(SKTexture(imageNamed: "fireball-3")))
            }
            else if frame > 18 && frame <= 24
            {
                ball.runAction(SKAction.setTexture(SKTexture(imageNamed: "fireball-1")))
            }
            else if frame > 24 && frame <= 30
            {
                ball.runAction(SKAction.setTexture(SKTexture(imageNamed: "fireball-4")))
            }
        }
        else if ball.special == "luigi" && ball.xScale != 2
        {
            ball.runAction(SKAction.setTexture(SKTexture(imageNamed: "poof-1")))
            ball.xScale = 2
            ball.yScale = 2
            NSTimer.after(0.1.seconds) {
                self.ball.runAction(SKAction.setTexture(SKTexture(imageNamed: "poof-2")))
            }
            NSTimer.after(0.2.seconds) {
                self.ball.runAction(SKAction.setTexture(SKTexture(imageNamed: "poof-3")))
            }
            NSTimer.after(0.3.seconds) {
                self.ball.runAction(SKAction.setTexture(SKTexture(imageNamed: "poof-4")))
            }
            NSTimer.after(0.4.seconds) {
                self.ball.runAction(SKAction.setTexture(SKTexture(imageNamed: "poof-5")))
            }
            NSTimer.after(0.5.seconds) {
                self.ball.runAction(SKAction.setTexture(SKTexture(imageNamed: "poof-6")))
            }
            NSTimer.after(0.6.seconds) {
                self.ball.alpha = 0
                self.ball.xScale = 1
                self.ball.yScale = 1
            }
            
            if ball.position.y > 500
            {
                self.ball.runAction(SKAction.setTexture(SKTexture(imageNamed: "ball-" + self.charScene.s_ball)))
                ball.xScale = 1
                ball.yScale = 1
                ball.alpha = 1
            }
        }
        else if ball.special == "peach" && ball.position.y < 400 && tick % 10 == 1
        {
            ball.peachHeart()
        }
        else if ball.special == "yoshi"
        {
            self.ball.runAction(SKAction.setTexture(SKTexture(imageNamed:"egg")))
            ball.runAction(SKAction.rotateByAngle(0.1, duration: 0))
            ball.xScale = 2
            ball.yScale = 2
            ball.xVel += (CGFloat(arc4random_uniform(200)) - 100)/100
            if ball.xVel > 5 || ball.position.x < 200
            {
                ball.xVel = 5
            }
            else if ball.xVel < -5 || ball.position.x > 700
            {
                ball.xVel = -5
            }
        }
        else if ball.special == "wario"
        {
            ball.warioFarts()
        }
        else if ball.special == "waluigi"
        {
            ball.yVel = 2
            ball.xVel = 0
            
            dup_ball_1.alpha = 1
            dup_ball_1.xVel = 1
            dup_ball_1.yVel = 2
            
            dup_ball_2.alpha = 1
            dup_ball_2.xVel = -1
            dup_ball_2.yVel = 2
        }
        
        // Rainbow tint the player if a special shot is available
        if player.special == "available"
        {
            let frame = tick % 80
            player.colorBlendFactor = 1.0
            if frame <= 10
            {
                player.color = .redColor()
            }
            else if frame > 10 && frame <= 20
            {
                player.color = .orangeColor()
            }
            else if frame > 20 && frame <= 30
            {
                player.color = .yellowColor()
            }
            else if frame > 30 && frame <= 40
            {
                player.color = .greenColor()
            }
            else if frame > 40 && frame <= 50
            {
                player.color = .cyanColor()
            }
            else if frame > 50 && frame <= 60
            {
                player.color = .blueColor()
            }
            else if frame > 60 && frame <= 70
            {
                player.color = .purpleColor()
            }
            else if frame > 70 && frame <= 80
            {
                player.color = .magentaColor()
            }
        }
        else if player.special == "none"
        {
            player.colorBlendFactor = 0
        }

        // check to see if the ball passed the checkpoint box
        if ball.position.y >= 389 && ball.position.y <= 429 &&
           ball.position.x >= 212 && ball.position.x <= 812
        {
            ball.chkpt = true
        }
        
        // Resize player and opponent scores according to what they are now
        if player.points == 0
        {
            player_score.xScale = 3
        }
        else if player.points == 15
        {
            player_score.xScale = 93/15
        }
        else if player.points == 30
        {
            player_score.xScale = 6
        }
        else if player.points == 40
        {
            player_score.xScale = 93/15
        }
        else if player.points == 50
        {
            player_score.xScale = 108/15
        }
        
        if opponent.points == 0
        {
            opponent_score.xScale = 3
        }
        else if opponent.points == 15
        {
            opponent_score.xScale = 93/15
        }
        else if opponent.points == 30
        {
            opponent_score.xScale = 6
        }
        else if opponent.points == 40
        {
            opponent_score.xScale = 93/15
        }
        else if opponent.points == 50
        {
            opponent_score.xScale = 108/15
        }
        
        // Swing for the special shot when v is pressed
        if map["v"] == true && player.serving == 0 && player.charging == 0 && player.special == "available"
        {
            if player.foreHand == true
            {
                player.physicsBody = SKPhysicsBody(circleOfRadius: 15, center: CGPoint(x: 20, y: 0))
                player.physicsBody?.dynamic = false
                player.physicsBody?.affectedByGravity = false
                player.physicsBody!.categoryBitMask = CollisionType.Character.rawValue
                player.physicsBody!.collisionBitMask = 0
                player.physicsBody!.contactTestBitMask = CollisionType.Ball.rawValue
                player.xScale = abs(player.xScale)
            }
            else
            {
                player.physicsBody = SKPhysicsBody(circleOfRadius: 15, center: CGPoint(x: -20, y: 0))
                player.physicsBody?.dynamic = false
                player.physicsBody?.affectedByGravity = false
                player.physicsBody!.categoryBitMask = CollisionType.Character.rawValue
                player.physicsBody!.collisionBitMask = 0
                player.physicsBody!.contactTestBitMask = CollisionType.Ball.rawValue
                player.xScale = -abs(player.xScale)
            }

            player.runAction(SKAction.setTexture(SKTexture(imageNamed: player.character + "-charge-1r")))
            NSTimer.after(0.1.seconds) {
                self.player.runAction(SKAction.setTexture(SKTexture(imageNamed: self.player.character + "-charge-2r")))
                if self.ball.contact == true
                {
                    self.ball.special = self.player.character
                    self.player.special = "active"
                    if self.player.character == "mario"
                    {
                        self.ball.yVel = 15
                        self.ball.xVel = (self.ball.position.x - self.player.position.x - 20)/10
                    }
                    else if self.player.character == "yoshi"
                    {
                        self.ball.yVel = 3
                        self.ball.xVel = 0
                    }
                    else if self.player.character == "waluigi"
                    {
                        self.dup_ball_1.position = self.ball.position
                        self.dup_ball_2.position = self.ball.position
                    }
                    else
                    {
                        self.ball.yVel = 2
                        if self.player.foreHand == true
                        {
                            self.ball.xVel = (self.ball.position.x - self.player.position.x + 20)/10
                        }
                        else
                        {
                            self.ball.xVel = (self.ball.position.x - self.player.position.x - 20)/10
                        }
                    }
                }
            }
            NSTimer.after(0.2.seconds) {
                self.player.runAction(SKAction.setTexture(SKTexture(imageNamed: self.player.character + "-charge-3r")))
            }
            NSTimer.after(0.3.seconds) {
                self.player.runAction(SKAction.setTexture(SKTexture(imageNamed: self.player.character + "-idle-u")))
            }
        }
        
        // If you're serving, press space to serve
        if map["space"] == true && player.serving == 1
        {
            player.serving = 2
            player.runAction(SKAction.setTexture(SKTexture(imageNamed: player.character + "-serve-2r")))
            ball.yVel = 7
            for var i:Double = 0; i < 55; i++
            {
                let sec:Double = i/100
                NSTimer.after(sec.seconds){
                    self.ball.yVel -= 0.2
                }
            }
            NSTimer.after(0.65.seconds) {
                self.player.runAction(SKAction.setTexture(SKTexture(imageNamed: self.player.character + "-serve-3r")))
            }
            NSTimer.after(0.75.seconds) {
                self.player.runAction(SKAction.setTexture(SKTexture(imageNamed: self.player.character + "-serve-4r")))
                self.ball.yVel = 2
                self.ball.xVel = -2
                self.ball.chkpt = false
            }
            NSTimer.after(0.85.seconds) {
                self.player.runAction(SKAction.setTexture(SKTexture(imageNamed: self.player.character + "-idle-u")))
                self.player.serving = 0
            }
        }
        
        // Have the opponent serve
        if opponent.serving == 1
        {
            opponent.serving = 2
            NSTimer.after (1.seconds) {
                self.opponent.runAction(SKAction.setTexture(SKTexture(imageNamed: self.opponent.character + "-serve-2l")))
                self.ball.yVel = 7
                for var i:Double = 0; i < 40; i++
                {
                    let sec:Double = i/100
                    NSTimer.after(sec.seconds){
                        self.ball.yVel -= 0.2
                    }
                }
                NSTimer.after(0.65.seconds) {
                    self.opponent.runAction(SKAction.setTexture(SKTexture(imageNamed: self.opponent.character + "-serve-3l")))
                }
                NSTimer.after(0.75.seconds) {
                    self.opponent.runAction(SKAction.setTexture(SKTexture(imageNamed: self.opponent.character + "-serve-4l")))
                    self.ball.yVel = -2
                    self.ball.xVel = 2
                    self.ball.chkpt = false
                }
                NSTimer.after(0.85.seconds) {
                    self.opponent.runAction(SKAction.setTexture(SKTexture(imageNamed: self.opponent.character + "-idle-u")))
                    self.opponent.serving = 0
                }
            }
        }
        
        
        
        // If the space bar is being pressed, charge a shot and impede movement
        if map["space"] == true && player.charging != 2 && player.serving == 0
        {
            player.runAction(SKAction.setTexture(SKTexture(imageNamed: player.character + "-charge-1r")))
            player.xScale = 4
            if player.foreHand == false
            {
                player.xScale = -abs(player.xScale)
            }
            else
            {
                player.xScale = abs(player.xScale)
            }
            player.charging = 1
            player.charge++
            
            if map["left"] == true
            {
                player.xVel -= 0.1
            }
            if map["right"] == true
            {
                player.xVel += 0.1
            }
            if map["up"] == true
            {
                player.yVel += 0.1
            }
            if map["down"] == true
            {
                player.yVel -= 0.1
            }
        }
        
        // If the space button was just released, swing
        if map["space"] == false && player.charging == 1 && player.serving == 0
        {
            if player.foreHand == true
            {
                player.physicsBody = SKPhysicsBody(circleOfRadius: 15, center: CGPoint(x: 20, y: 0))
                player.physicsBody?.dynamic = false
                player.physicsBody?.affectedByGravity = false
                player.physicsBody!.categoryBitMask = CollisionType.Character.rawValue
                player.physicsBody!.collisionBitMask = 0
                player.physicsBody!.contactTestBitMask = CollisionType.Ball.rawValue
            }
            else
            {
                player.physicsBody = SKPhysicsBody(circleOfRadius: 15, center: CGPoint(x: -20, y: 0))
                player.physicsBody?.dynamic = false
                player.physicsBody?.affectedByGravity = false
                player.physicsBody!.categoryBitMask = CollisionType.Character.rawValue
                player.physicsBody!.collisionBitMask = 0
                player.physicsBody!.contactTestBitMask = CollisionType.Ball.rawValue
            }
            
            player.charging = 2
            player.runAction(SKAction.setTexture(SKTexture(imageNamed: player.character + "-charge-2r")))
            if player.foreHand == true
            {
                player.xScale = 80/15
            }
            else
            {
                player.xScale = -80/15
            }
            player.swinging = true
            
            NSTimer.after(0.1.seconds) {
                self.player.swinging = false
                if self.player.foreHand == true
                {
                    self.player.xScale = 4
                }
                else
                {
                    self.player.xScale = -4
                }
                self.player.runAction(SKAction.setTexture(SKTexture(imageNamed: self.player.character + "-charge-3r")))
            }
            
            NSTimer.after(0.8.seconds) {
                self.player.runAction(SKAction.setTexture(SKTexture(imageNamed: self.player.character + "-idle-u")))
                self.player.charging = 0
                self.player.charge = 0
            }
        }
        
        
        
        // If the player isn't charging or serving, move according to the arrow keys
        if player.charging == 0 && player.serving == 0
        {
            if map["down"] == true && map["space"] == false
            {
                player.walkDown(tick, map:map)
            }
            
            if map["up"] == true && map["space"] == false
            {
                player.walkUp(tick, map:map)
            }
            
            if map["left"] == true && map["space"] == false
            {
                player.walkLeft(tick, map:map)
            }
            
            if map["right"] == true && map["space"] == false
            {
                player.walkRight(tick, map:map)
            }
        }
        
        // If the ball is in contact, check for racquet hits
        if ball.contact == true
        {
            // If the player is swinging and the ball is on his half or the player is swinging and the ball is on his half
            if (player.swinging == true && ball.position.y < size.height/2) ||
                (opponent.swinging == true && ball.position.y > size.height/2)
            {
                self.player.meter += self.player.charge
                
                // Send the ball back
                ball.yVel = 2 + player.charge/100
                if player.foreHand == true
                {
                    ball.xVel = (ball.position.x - player.position.x - 20)/10
                }
                else
                {
                    ball.xVel = -(ball.position.x - player.position.x + 20)/10
                }
                ball.chkpt = false
            }
        }
        
        // Make bounds that the player can't cross
        if player.position.y >= 400 {
            // Can't go past the net
            player.yVel = -1
        }
        else if player.position.y <= 100 {
            // Can't leave the screen below
            player.yVel = 1
        }
        if player.position.x <= 100 {
            // Can't leave the screen to the left
            player.xVel = 1
        }
        else if player.position.x >= 920 {
            // Can't leave the screen to the right
            player.xVel = -1
        }
        
        // If the ball is moving towards the player, position the opponent in the center
        if ball.yVel < 0 && player.serving == 0 && opponent.serving != 2
        {
            opponent.walkCenter(tick)
        }
            
        // If the ball is coming to the opponent, intercept it
        else if ball.yVel > 0 && player.serving == 0 && player.special != "active"
        {
            // Calculate the predicted x coordinate for y = 600
            prediction = ball.position.x + (600 - ball.position.y)/(ball.yVel/ball.xVel)
            opponent.interceptBall(prediction, ball_pos:ball.position.y, tick: tick)
        }
        
        // Do a diceroll to check if the opponent will hit the ball
        if ball.yVel < 0
        {
            diceroll = Int(arc4random_uniform(100))
        }
        
        // Have the opponent swing at the ball if the diceroll was sucessful and the ball's approaching
        if diceroll < 85 && ball.position.y >= 500 && ball.position.y <= 501 + ball.yVel
        && opponent.serving == 0 && ball.chkpt == true && player.special != "active"
        {
            opponent.swing_anim = true
            opponent.returnBall()
            NSTimer.after(1.seconds) {
                self.opponent.swing_anim = false
            }
        }
        
        // Have the opponent hit the ball back if the diceroll was successful and the ball arrived
        if ball.position.y >= 600 && ball.yVel > 0 && opponent.serving == 0 && diceroll < 85
        && ball.chkpt == true && player.special != "active"
        {
            self.ball.yVel = -self.ball.yVel
            if self.opponent.position.x > 768/2
            {
                self.ball.xVel = -(CGFloat(arc4random_uniform(100)))/100
            }
            else
            {
                self.ball.xVel = (CGFloat(arc4random_uniform(100)))/100
            }
            ball.returning = false
            ball.chkpt = false
        }
        
        // Move the player and ball according to the velocity
        player.runAction(SKAction.moveByX(1.3 * player.xVel, y:1.3 * player.yVel, duration: 0.0))
        ball.runAction(SKAction.moveByX(1 * ball.xVel, y:1.3 * ball.yVel, duration: 0.0))
        dup_ball_1.runAction(SKAction.moveByX(1 * dup_ball_1.xVel, y:1.3 * dup_ball_1.yVel, duration: 0.0))
        dup_ball_2.runAction(SKAction.moveByX(1 * dup_ball_2.xVel, y:1.3 * dup_ball_2.yVel, duration: 0.0))
        
        // Slow the player down by friction
        player.xVel = player.xVel/FRICTION
        player.yVel = player.yVel/FRICTION
        
        // Check if someone scored and change the score if so and even win if so
        if ball.position.y > size.height && ball.chkpt == true
        {
            getPoint("player")
            
            if player.games >= 3
            {
                player.games = 0
                opponent.games = 0
                winGame("player")
            }
            ball.backToServe(server)
            setUpServe()
            updateScore(player.points, opponentScore:opponent.points, playergames: player.games, opponentgames: opponent.games)
        }
        else if ball.position.y > size.height && ball.chkpt == false
        {
            getPoint("opponent")
            
            if opponent.games >= 3
            {
                player.games = 0
                opponent.games = 0
                winGame("opponent")
            }
            
            ball.backToServe(server)
            setUpServe()
            updateScore(player.points, opponentScore:opponent.points, playergames: player.games, opponentgames: opponent.games)
        }
        else if ball.position.y < 0 && ball.chkpt == true
        {
            getPoint("opponent")
            
            if opponent.games >= 3
            {
                player.games = 0
                opponent.games = 0
                winGame("opponent")
            }
            
            ball.backToServe(server)
            setUpServe()
            updateScore(player.points, opponentScore:opponent.points, playergames: player.games, opponentgames: opponent.games)
        }
        else if ball.position.y < 0 && ball.chkpt == false
        {
            getPoint("player")
            
            if player.games >= 3
            {
                player.games = 0
                opponent.games = 0
                winGame("player")
            }
            ball.backToServe(server)
            setUpServe()
            updateScore(player.points, opponentScore:opponent.points, playergames: player.games, opponentgames: opponent.games)
        }
    }
}