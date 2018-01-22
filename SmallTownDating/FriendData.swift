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
    enum CodingKeys: String, CodingKey
    {
        case personality
        case friendName
        case decreaseMax
        case decreaseMin
        case moodBarSize
        case barStart
    }
    typealias FriendList = [FriendData]
    
    var personality: String
    var friendName: String
    var decreaseMax: Int
    var decreaseMin: Int
    var moodBarSize: Int
    var barStart: Int
    
    var hearts: Int = 0
    
    var description: String {
        get {
            return "\(friendName) [\(personality)] \(decreaseMax)-\(decreaseMin) mood max: \(moodBarSize) - mood: \(barStart) - hearts: \(hearts)"
        }
    }
    
    static let CHARATER_IMAGE_FOR_NAME = [
        "Joe": "cardCharacterJoe000",
        "Robin": "cardCharacterRobin000",
        "Riley": "cardCharacterPerlerper000",
        "Quinn": "cardCharacterQuinn000",
        "Addison": "cardCharacterAddison000"
    ]
    
    mutating func sufferAngst()
    {
        let rand = GKRandomSource.sharedRandom()
        let angstRange = decreaseMax - decreaseMin
        let angst = decreaseMin + rand.nextInt(upperBound: angstRange)
        barStart = max(0, barStart - angst)
        
        print ("Angst: \(description)")
    }
    
    mutating func enjoySelf()
    {
        barStart = moodBarSize - 1
        hearts = max(hearts + 1, 3)
        
        print ("enjoySelf: \(description)")
    }
}


