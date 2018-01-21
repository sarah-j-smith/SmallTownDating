//
//  FriendView.swift
//  SmallTownDating
//
//  Created by Sarah Smith on 20/1/18.
//  Copyright © 2018 Sarah Smith. All rights reserved.
//

import UIKit
import SpriteKit

struct FriendData: Decodable
{
    typealias FriendList = [FriendData]
    
    let personality: String
    let friendName: String
    let decreaseMax: Float
    let decreaseMin: Float
    let moodBarSize: Int
    let barStart: Int
}

func loadFriendData() -> [ FriendData ]
{
    var results: [ FriendData ] = []
    guard let friendDataPath = Bundle.main.url(forResource: "FriendData", withExtension: "plist") else
    {
        print("No file FriendData.plist found!")
        return results
    }
    do {
        let friendRawData = try Data(contentsOf: friendDataPath)
        print("Got raw data from: \(friendDataPath) - \(friendRawData.count) bytes")
        let decoder = PropertyListDecoder()
        let friendStructuredData = try decoder.decode(FriendData.FriendList.self, from: friendRawData)
        results = friendStructuredData
    }
    catch {
        print("Error reading friend data file \(friendDataPath): \(error.localizedDescription)")
    }
    return results
}

class FriendView: SKSpriteNode
{
    static let FRIEND_VIEW_MARGINS = CGSize(width: 25, height: 25)
    
    weak var moodBar: MoodBar!
    
    class func createFriendView(withImageName backgroundName: String, friendName: String) -> FriendView
    {
        let friendTexture = SKTexture(imageNamed: backgroundName)
        let friendView = FriendView(texture: friendTexture)
        friendView.friendName = friendName
        return friendView
    }
    
    var friendName: String? {
        set {
            friendNameLabel.text = newValue
        }
        get {
            return friendNameLabel.text
        }
    }
    
    var portrait: SKTexture? {
        set {
            characterPortrait.texture = portrait
        }
        get {
            return characterPortrait.texture
        }
    }
    
    private weak var friendNameLabel: SKLabelNode!
    private weak var characterPortrait: SKSpriteNode!
 
    func loadView()
    {
        characterPortrait = childNode(withName: "portrait") as! SKSpriteNode
        friendNameLabel = childNode(withName: "friendName") as! SKLabelNode
        
        moodBar = childNode(withName: "//moodBarFrame") as! MoodBar
        moodBar.loadView()
    }

}
