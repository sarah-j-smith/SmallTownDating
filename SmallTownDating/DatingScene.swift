//
//  DatingScene.swift
//  SmallTownDating
//
//  Created by Sarah Smith on 21/1/18.
//  Copyright © 2018 Sarah Smith. All rights reserved.
//

import UIKit
import SpriteKit

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
        nextDayButton.loadView()
        nextDayButton.buttonNotation.fontName = "Nunito-Black"
    }
}

class DatingScene: SKScene
{
    override func sceneDidLoad()
    {
        setupButtons()
        setupTitles()
    }
    
    func setupTitles()
    {
        let resultTitle = childNode(withName: "//dateTitle") as! SKLabelNode
        resultTitle.fontName = "Nunito-Black"
        let resultResults = childNode(withName: "//dateResult") as! SKLabelNode
        resultResults.fontName = "Nunito-SemiBold"
    }
    
    func moveToGameScene()
    {
        let gameScene = SKScene(fileNamed: "GameScene")
        view?.presentScene(gameScene!, transition: SKTransition.flipHorizontal(withDuration: 0.7))
    }
}
