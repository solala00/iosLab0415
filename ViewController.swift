//
//  ViewController.swift
//  iosLab0415
//
//  Created by student on 2020/4/15.
//  Copyright © 2020年 student. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var game = MatchingGame(numberOfPairsOfCards: (deck.count+1) / 2)
    
    @IBAction func startGame(_ sender: UIButton) {
        for index in deck.indices{
            deck[index].setTitle("", for: UIControlState.normal)
            deck[index].backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            game.cards[index].isFaceUp = false
            game.cards[index].isMatched = false
            game.cards[index].isTouched = false
            game = MatchingGame(numberOfPairsOfCards: (deck.count+1) / 2)
            randomThemeIndex = Int(arc4random_uniform(UInt32(emojiThemes.count)))
            emojiChoices = emojiThemes[randomThemeIndex]
            //emojiChoices = "👻🎃😈🦇🙀⚽️🌏♥️"
        }
        point = 0
        game.addpoint = 0
        game.matchCards = []
        //sender.setTitle("", for: UIControl.State.normal)
        //sender.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 0)
    }
    
    @IBOutlet var deck: [UIButton]!
    
    @IBOutlet weak var flipCounter: UILabel!
    var flips = 0{
        didSet{
            //flipCounter.text = "Flips: \(flips)"
            let attributes:[NSAttributedStringKey:Any] = [
                .strokeWidth:5.0,
                .strokeColor:UIColor.orange
            ]
            let attributedString = NSAttributedString(string: "Flips:\(flips)", attributes: attributes)
            flipCounter.attributedText = attributedString
        }
    }
    
    
    @IBOutlet weak var pointLabel: UILabel!
    
    var point: Int = 0
    {
        didSet{
            pointLabel.text = "point : \(point)"
        }
    }
    
    
    
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = deck.index(of: sender){
            let card = game.cards[cardNumber]
            if !card.isMatched  {
                if(game.matchCards.count == 1 && card.isFaceUp ){
                    print("It's the same card")
                }else{
                    game.matchingCard(at: cardNumber)
                }
                point = game.calPoint()
            }
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }else{
            print("This card is not in the collection!")
        }
        flips+=1
    }
    
    func updateViewFromModel(){
        for index in deck.indices{
            let button = deck[index]
            let card = game.cards[index]
            if card.isFaceUp{
                button.setTitle(emoji(for: card), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }else{
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 0.6965228873) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        flips = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let emojiThemes = ["🍏🍎🍐🍊🍋🍌🍉🍇","🐶🐱🐭🐹🐰🦊🐻🐼","⚽️🏀🏈🎾🏉🎱⚾️🏐","🚗🏎🚓🚑🚜🚲🛵🏍","❤️💛💚💙💜🖤💔❣️","🏳️‍🌈🇹🇹🇹🇷🇹🇨🇹🇲🇧🇹🇨🇫🇨🇳"]
    lazy var randomThemeIndex = Int(arc4random_uniform(UInt32(emojiThemes.count)))
    lazy var emojiChoices = emojiThemes[randomThemeIndex]
    var emojiDict = Dictionary<Card,String>()
    
    func emoji(for card: Card)->String{
        if emojiDict[card] == nil, emojiChoices.count > 0{
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy:emojiChoices.count.arc4random)
            emojiDict[card] = String(emojiChoices.remove(at: randomStringIndex))
        }
        return emojiDict[card] ?? "?"
    }
    
}
extension Int{
    var arc4random:Int{
        if self > 0{
            return Int(arc4random_uniform(UInt32(self)))
        }else if self < 0{
            return -Int(arc4random_uniform(UInt32(abs(self))))
        }else{
            return 0
        }
    }
}

