//
//  DatingScene.swift
//  SmallTownDating
//
//  Created by Sarah Smith on 21/1/18.
//  Copyright © 2018 Sarah Smith. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

extension DatingScene: ButtonResponder
{
    func wasTapped(button: Button)
    {
        if button.name == "nextDayButton"
        {
            moveToGameScene()
        }
    }
    
    func setupButtons()
    {
        let nextDayButton = childNode(withName: "nextDayButton") as! Button
        nextDayButton.delegate = self
        nextDayButton.downName = "buttonDown"
        nextDayButton.upName = "buttonUp"
        nextDayButton.loadView()
        nextDayButton.buttonNotation.fontName = "Nunito-Black"
        nextDayButton.buttonNotation.text = "Next Day"
    }
}

class DatingScene: SKScene
{
    weak var resultsFrame: SKSpriteNode!
    
    static let CRASH_CHANCE = 0.5
    
    override func sceneDidLoad()
    {
        setupButtons()
        setupTitles()
        
        resultsFrame = childNode(withName: "dateResultFrame") as! SKSpriteNode
        let dateTitle = resultsFrame.childNode(withName: "dateTitle") as! SKLabelNode
        let dateResult = resultsFrame.childNode(withName: "dateResult") as! SKLabelNode
        
        resultsFrame.setScale(0.01)
        
        let currentDate = FriendManager.shared.currentDate
        FriendManager.shared.hangOut(person: currentDate!)
        let rand = GKRandomSource.sharedRandom()
        let pissedFriends = FriendManager.shared.getPissedOffFriends()
        let chanceToCrash = Double( rand.nextInt(upperBound: 1000) ) / 1000.0
        if pissedFriends.count > 0
        {
            let randPissed = rand.nextInt(upperBound: pissedFriends.count - 1)
            let pissedFriend = pissedFriends[randPissed].friendName
            if chanceToCrash > DatingScene.CRASH_CHANCE
            {
                dateTitle.text = "Distrously!"
                dateResult.text = "\(pissedFriend) crashed your evening!"
            }
            else
            {
                dateTitle.text = "Pretty well"
                dateResult.text = "Fun was had but \(pissedFriends.count) of your friends are unhappy including \(pissedFriend)"
            }
        }
        else
        {
            let fnd = FriendManager.shared.currentDate!
            dateTitle.text = "Great!"
            dateResult.text = "\(fnd.friendName) and you hung out & had fun!"
        }
        let popAction = SKAction.scale(to: 1.2, duration: 0.4)
        let popBack = SKAction.scale(to: 1.0, duration: 0.1)
        resultsFrame.run(SKAction.sequence([ popAction, popBack ]))
    }
    
    func setupTitles()
    {
        let dateTitleFrame = childNode(withName: "dateTitleFrame")!
        let resultTitle = dateTitleFrame.childNode(withName: "//dateTitle") as! SKLabelNode
        resultTitle.fontName = "Nunito-Black"
        let resultResults = dateTitleFrame.childNode(withName: "//dateResult") as! SKLabelNode
        resultResults.fontName = "Nunito-SemiBold"
    }
    
    func moveToGameScene()
    {
        let gameScene = SKScene(fileNamed: "GameScene")
        view?.presentScene(gameScene!, transition: SKTransition.flipHorizontal(withDuration: 0.7))
    }
}
