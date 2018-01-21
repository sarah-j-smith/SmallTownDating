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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("button \(name!) touched")
        delegate?.wasTapped(button: self)
    }
}
