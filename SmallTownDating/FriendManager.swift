//
//  FriendManager.swift
//  SmallTownDating
//
//  Created by Sarah Smith on 21/1/18.
//  Copyright © 2018 Sarah Smith. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class FriendManager: NSObject
{
    // To win you have to get this many hearts across all characters
    static let WIN_HEARTS = 3
    
    static let shared = FriendManager()
    
    var friends = loadFriendData()
    
    var currentDate: Int = 2
    
    let rand = GKARC4RandomSource()
    
    func getPissedOffFriends() -> [FriendData]
    {
        return friends.filter { $0.barStart == 0 }
    }
    
    func hangOut()
    {
        for f in 0 ..< friends.count
        {
            if f != currentDate
            {
                friends[f].sufferAngst()
            }
            else
            {
                friends[f].enjoySelf()
            }
        }
    }
}
