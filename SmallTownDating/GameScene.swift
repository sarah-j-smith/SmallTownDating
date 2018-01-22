//
//  GameScene.swift
//  SmallTownDating
//
//  Created by Sarah Smith on 20/1/18.
//  Copyright © 2018 Sarah Smith. All rights reserved.
//

import SpriteKit
import GameplayKit

protocol Dumpable {
    var moreInfo: String { get }
}

extension SKLabelNode: Dumpable
{
    var moreInfo: String {
        get {
            return text ?? "<EMPTY>"
        }
    }
}

extension SKSpriteNode: Dumpable
{
    var moreInfo: String {
        get {
            return "(\(position.x), \(position.y)) \(size.width)w x \(size.height)h"
        }
    }
}

extension SKNode
{
    func printNamePlusType(withInfo moreInfo: String, indent: Int)
    {
        let indentSpace = String(repeating: " ", count: indent)
        let idString = String(UInt(bitPattern: ObjectIdentifier(self)))
        print(indentSpace + "\(self.name ?? "Unnamed") \(idString) - \(String(describing: type(of: self))) \(moreInfo)")
    }
    
    func dump(indent: Int = 0)
    {
        let moreInfo = (self as? Dumpable)?.moreInfo ?? ""
        printNamePlusType(withInfo: moreInfo, indent: indent)
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
            if focussedFriend < FriendManager.shared.friends.count - 1
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
        else if button.name == "hangOutButton"
        {
            moveToDateScene()
        }
    }
    
    func setupButtons()
    {
        let leftButton = childNode(withName: "leftButton") as! Button
        let rightButton = childNode(withName: "rightButton") as! Button
        leftButton.downName = "arrow_left"
        leftButton.delegate = self
        rightButton.delegate = self
        rightButton.downName = "arrow_right"
        leftButton.loadView()
        rightButton.loadView()
        
        let hangOutButton = childNode(withName: "hangOutButton") as! Button
        hangOutButton.delegate = self
        hangOutButton.downName = "buttonDown"
        hangOutButton.upName = "buttonUp"
        hangOutButton.loadView()
        hangOutButton.buttonNotation.fontName = "Nunito-Black"
    }
}

class GameScene: SKScene
{
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    static let POP_SCALE:CGFloat = 1.0
    static let SUB_SCALE:CGFloat = 0.92
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    private var focussedFriend = 2
    
    private var friendViewSpan: CGFloat = 0.0
    private var selectorIsAnimating = false
    
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
        let popUp = SKAction.scale(to: GameScene.POP_SCALE, duration: 0.2)
        let popDown = SKAction.scale(to: GameScene.SUB_SCALE, duration: 0.2)
        let prevFocussed = slider.children[focussedFriend]
        if prevFocussed.xScale != GameScene.SUB_SCALE
        {
            prevFocussed.run(popDown)
        }
        let newlyFocussed = slider.children[friend]
        sliderAction.timingMode = .easeInEaseOut
        selectorIsAnimating = true
        slider.run(sliderAction) {[unowned self] in
            self.selectorIsAnimating = false
            self.focussedFriend = friend
            
            FriendManager.shared.currentDate = friend
            
            newlyFocussed.run(popUp)
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
        var xPos:CGFloat = -600.0
        for friend in friendNodes.enumerated() {
            let ref = friend.element as! SKReferenceNode
            let pos = ref.position
            ref.removeFromParent()
            let newFriendView = SKScene(fileNamed: "FriendView")
            let friendView = newFriendView?.childNode(withName: "friendView") as! FriendView
            friendView.removeFromParent()
            slider.addChild(friendView)
            friendView.position = CGPoint(x: xPos, y: pos.y)
            friendView.setScale( friend.offset == 2 ? 1.0 : 0.92)
            xPos += 300.0
            let ff = FriendManager.shared.friends[friend.offset]
            friendView.loadView(withData: ff)
        }
        
        FriendManager.shared.currentDate = 2
    }
    
    // MARK: - Date Scene
    
    func moveToDateScene()
    {
        let dateScene = SKScene(fileNamed: "DatingScene")!
        view?.presentScene(dateScene, transition: SKTransition.flipHorizontal(withDuration: 0.3))
    }
}
