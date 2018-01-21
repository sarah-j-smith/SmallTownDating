//
//  FriendData.swift
//  SmallTownDating
//
//  Created by Sarah Smith on 21/1/18.
//  Copyright © 2018 Sarah Smith. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

struct FriendData: Decodable
{
    typealias FriendList = [FriendData]
    
    var personality: String
    var friendName: String
    var decreaseMax: Int
    var decreaseMin: Int
    var moodBarSize: Int
    var barStart: Int
    
    mutating func sufferAngst()
    {
        let rand = GKRandomSource.sharedRandom()
        let angstRange = decreaseMax - decreaseMin
        let angst = decreaseMin + rand.nextInt(upperBound: angstRange)
        barStart = max(0, barStart - angst)
    }
    
    mutating func enjoySelf()
    {
        barStart = moodBarSize - 1
    }
}


