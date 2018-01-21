//
//  Button.swift
//  SmallTownDating
//
//  Created by Sarah Smith on 20/1/18.
//  Copyright © 2018 Sarah Smith. All rights reserved.
//

import UIKit
import SpriteKit

protocol ButtonResponder: class {
    func wasTapped(button: Button)
}

class Button: SKSpriteNode
{
    weak var delegate: ButtonResponder?
    weak var buttonNotation: SKLabelNode!
    
    /** Activated condition of the button */
    var upName: String?
    
    /** Default condition of the button */
    var downName: String?
    
    static let PLAY_BUTTON_SOUND = SKAction.playSoundFileNamed("buttonClick.caf", waitForCompletion: false)
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        isUserInteractionEnabled = true
    }
    
    private func setup()
    {
        isUserInteractionEnabled = true
    }
    
    func loadView()
    {
        color = UIColor.white
        texture = SKTexture(imageNamed: downName!)
        if let notationLoaded = childNode(withName: "buttonNotation") as? SKLabelNode
        {
            buttonNotation = notationLoaded
        }
        else
        {
            let notation = SKLabelNode(fontNamed: "Nunito-SemiBold")
            addChild(notation)
            notation.verticalAlignmentMode = .center
            notation.horizontalAlignmentMode = .center
            buttonNotation = notation
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if let buttonChangeTextureName = upName
        {
            texture = SKTexture(imageNamed: buttonChangeTextureName)
            let buttonRestoreAction = SKAction.setTexture(SKTexture(imageNamed: downName!))
            let waitAction = SKAction.wait(forDuration: 0.3)
            run(SKAction.sequence([Button.PLAY_BUTTON_SOUND, waitAction, buttonRestoreAction]))
        }
        delegate?.wasTapped(button: self)
    }
}
