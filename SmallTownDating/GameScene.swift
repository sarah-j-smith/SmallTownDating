//
//  GameScene.swift
//  SmallTownDating
//
//  Created by Sarah Smith on 20/1/18.
//  Copyright © 2018 Sarah Smith. All rights reserved.
//

import SpriteKit
import GameplayKit

extension SKNode {
    
    func dump(indent: Int = 0)
    {
        let indentSpace = String(repeating: " ", count: indent)
        print(indentSpace + "\(self)")
        for c in children
        {
            c.dump(indent: indent + 4)
        }
    }
    
}

extension GameScene: ButtonResponder
{
    func wasTapped(button: Button) {
        if button.name == "leftButton"
        {
            if focussedFriend < friends.count - 1
            {
                select(friendIndex: focussedFriend + 1)
            }
        }
        else if button.name == "rightButton"
        {
            if focussedFriend > 0
            {
                select(friendIndex: focussedFriend - 1)
            }
        }
    }
    
    func setupButtons()
    {
        let leftButton = childNode(withName: "leftButton") as! Button
        let rightButton = childNode(withName: "rightButton") as! Button
        leftButton.delegate = self
        rightButton.delegate = self
        leftButton.loadView()
        rightButton.loadView()
        leftButton.buttonNotation.fontName = "Nunito-Semibold.ttf"
        rightButton.buttonNotation.fontName = "Nunito-Semibold.ttf"
        leftButton.buttonNotation.text = "<"
        rightButton.buttonNotation.text = ">"
        
        self.dump()
    }
}

class GameScene: SKScene
{
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    private var focussedFriend = 2
    
    private var friendViewSpan: CGFloat = 0.0
    private var selectorIsAnimating = false
    
    var friends = loadFriendData()
    
    weak private var slider: SKNode!
    
    override func sceneDidLoad() {

        self.lastUpdateTime = 0

        setupFriendsDisplay()
        setupButtons()
    }
    
    func select(friendIndex friend: Int)
    {
        if selectorIsAnimating { return }
        let delta = friendViewSpan * CGFloat(focussedFriend - friend)
        let sliderAction = SKAction.moveBy(x: delta, y: 0.0, duration: 0.3)
        sliderAction.timingMode = .easeInEaseOut
        selectorIsAnimating = true
        slider.run(sliderAction) {[unowned self] in
            self.selectorIsAnimating = false
            self.focussedFriend = friend
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
    
    // Friends display
    func setupFriendsDisplay()
    {
        let clipNode = childNode(withName: "friendSliderCropNode") as! SKCropNode
        let clipZone = clipNode.childNode(withName: "friendSliderView") as! SKSpriteNode
        slider = clipNode.childNode(withName: "slider")!
        clipZone.removeFromParent()
        clipNode.maskNode = clipZone
        let friendNodes = slider.children
        let friendsSorted = friendNodes.sorted { $0.position.x < $1.position.x }
        let lastIndex = friendsSorted.count - 1
        friendViewSpan = friendsSorted[lastIndex].position.x - friendsSorted[lastIndex - 1].position.x
        for friend in friendNodes.enumerated() {
            let friendView = friend.element.childNode(withName: "//friendView") as! FriendView
            let friendRecord = friends[friend.offset]
            friendView.loadView()
            friendView.friendName = friendRecord.friendName
        }
    }
}
