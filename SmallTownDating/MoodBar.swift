//
//  MoodBar.swift
//  SmallTownDating
//
//  Created by Sarah Smith on 20/1/18.
//  Copyright © 2018 Sarah Smith. All rights reserved.
//

import UIKit
import SpriteKit

class MoodBar: SKSpriteNode
{
    private var _moodNodeCount: Int = 7
    private var _currentMood: Int = 3
    
    private var defaultColor: UIColor!
    
    var currentMood: Int {
        get {
            return _currentMood
        }
        set {
            if _currentMood != newValue
            {
                let currentNode = moodNodes[_currentMood]
                currentNode.color = defaultColor
                let newNode = moodNodes[newValue]
                newNode.color = UIColor.green
            }
        }
    }
    
    var moodNodeCount: Int {
        get {
            return _moodNodeCount
        }
        set {
            assert(newValue >= 3)
            assert(newValue < _moodNodeCount)
            assert(_moodNodeCount <= moodNodes.count)
            moodNodes[ newValue ..< moodNodes.count - 1 ].forEach { $0.isHidden = true }
            moodNodes.last?.position = moodNodes[ newValue ].position
            _moodNodeCount = newValue
        }
    }
    
    var moodNodes: [SKSpriteNode] {
        get {
            let sortedNodes = children.sorted { $0.position.x < $1.position.x }
            return sortedNodes as! [SKSpriteNode]
        }
    }
    
    func loadView()
    {
        defaultColor = moodNodes.first!.color
    }
}
