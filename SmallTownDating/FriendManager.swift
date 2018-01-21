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
    static let shared = FriendManager()
    
    var friends = loadFriendData()
    
    var currentDate: FriendData?
    
    let rand = GKARC4RandomSource()
    
    func getPissedOffFriends() -> [FriendData]
    {
        return friends.filter { $0.barStart == 0 }
    }
    
    func hangOut(person: FriendData)
    {
        let ix = friends.index { $0.friendName == person.friendName }
        for f in 0 ..< friends.count
        {
            if f == ix!
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
