//
//  FriendView.swift
//  SmallTownDating
//
//  Created by Sarah Smith on 20/1/18.
//  Copyright © 2018 Sarah Smith. All rights reserved.
//

import UIKit
import SpriteKit

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
    
    static let HEART_TEX = SKTexture(image: #imageLiteral(resourceName: "heart0001"))
    static let NO_HEART_TEX = SKTexture(image: #imageLiteral(resourceName: "heart0002"))
    
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
    
    func setHeart(score: Int)
    {
        let scoreBar = childNode(withName: "scoreBar")!
        let heart1 = scoreBar.childNode(withName: "heart1") as! SKSpriteNode
        let heart2 = scoreBar.childNode(withName: "heart2") as! SKSpriteNode
        let heart3 = scoreBar.childNode(withName: "heart3") as! SKSpriteNode
        heart1.texture = score > 0 ? FriendView.HEART_TEX : FriendView.NO_HEART_TEX
        heart2.texture = score > 1 ? FriendView.HEART_TEX : FriendView.NO_HEART_TEX
        heart3.texture = score > 2 ? FriendView.HEART_TEX : FriendView.NO_HEART_TEX
    }
    
    private weak var friendNameLabel: SKLabelNode!
    private weak var characterPortrait: SKSpriteNode!
 
    func loadView(withData friendData: FriendData)
    {
        characterPortrait = childNode(withName: "portrait") as! SKSpriteNode
        friendNameLabel = childNode(withName: "friendName") as! SKLabelNode
        
        moodBar = childNode(withName: "//moodBarFrame") as! MoodBar
        moodBar.loadView()
        
        friendName = friendData.friendName
        moodBar.moodNodeCount = friendData.moodBarSize
        moodBar.currentMood = friendData.barStart
        
        let portraitName = "cardCharacterPerlerper000\(friendData.barStart)"
        let tex = SKTexture(imageNamed: portraitName)
        print("Tex sz: \(tex.size())")
        //portrait = tex
        characterPortrait.texture = tex
    }

}
