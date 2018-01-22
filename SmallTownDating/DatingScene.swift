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
        let dateResult1 = resultsFrame.childNode(withName: "dateResult1") as! SKLabelNode
        let dateResult2 = resultsFrame.childNode(withName: "dateResult2") as! SKLabelNode
        let dateResult3 = resultsFrame.childNode(withName: "dateResult3") as! SKLabelNode

        resultsFrame.setScale(0.01)
        
        let fm = FriendManager.shared
        fm.hangOut()
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
                dateResult1.text = "\(pissedFriend) crashed"
                dateResult2.text = "your evening!"
                dateResult3.text = ""
                
                let fm = FriendManager.shared
                fm.friends[ fm.currentDate ].hearts = 0
            }
            else
            {
                dateTitle.text = "Just fine"
                dateResult1.text = "Fun was had but"
                dateResult2.text = "\(pissedFriends.count) of your friends"
                dateResult3.text = "are unhappy including \(pissedFriend)"
            }
        }
        else
        {
            let fnd = FriendManager.shared.friends[ FriendManager.shared.currentDate ].friendName
            dateTitle.text = "Great!"
            dateResult1.text = "\(fnd) and you"
            dateResult2.text = "hung out & had fun!"
            dateResult3.text = ""
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
        let resultResults1 = dateTitleFrame.childNode(withName: "//dateResult1") as! SKLabelNode
        let resultResults2 = dateTitleFrame.childNode(withName: "//dateResult2") as! SKLabelNode
        let resultResults3 = dateTitleFrame.childNode(withName: "//dateResult3") as! SKLabelNode
        resultResults1.fontName = "Nunito-SemiBold"
        resultResults2.fontName = "Nunito-SemiBold"
        resultResults3.fontName = "Nunito-SemiBold"
    }
    
    func moveToGameScene()
    {
        let gameScene = SKScene(fileNamed: "GameScene")
        view?.presentScene(gameScene!, transition: SKTransition.flipHorizontal(withDuration: 0.7))
    }
}
