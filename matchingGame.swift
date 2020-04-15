//
//  matchingGame.swift
//  iosLab0415
//
//  Created by student on 2020/4/15.
//  Copyright © 2020年 student. All rights reserved.
//

import Foundation

class MatchingGame    {
    
    var cards=Array<Card>()
    var matchCards = [Card]()
    var addpoint : Int = 0
    
    
    
    var indexOfOneAndOnlyFaceUpCard: Int?{
        get{
            var foundIndex: Int?
            for index in cards.indices{
                if cards[index].isFaceUp{
                    if foundIndex == nil{
                        foundIndex = index
                    }
                    else{
                        return nil
                    }
                }
            }
            return foundIndex
        }
        set{
            for index in cards.indices{
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    
    
    func chooseCard2(at index: Int){
        if cards[index].isFaceUp{
            cards[index].isFaceUp=false
        }else{
            cards[index].isFaceUp = true
        }
    }
    
    func chooseCard(at index:Int){
        if !cards[index].isTouched{
            cards[index].isTouched = true
        }
        if !cards[index].isMatched{
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index{
                if cards[matchIndex] == cards[index]{
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }//matched
                cards[index].isFaceUp = true
                //indexOfOneAndOnlyFaceUpCard = nil
            }else if let matchIndex1 = indexOfOneAndOnlyFaceUpCard, matchIndex1 == index{
                cards[index].isFaceUp = false
                
            }
                // has another previous card face up
            else{//no cards face up or 2 cards are face up
                //for flipDownIndex in cards.indices{
                //    cards[flipDownIndex].isFaceUp = false
                //}// all cards set back to face down
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    
    init(numberOfPairsOfCards: Int){
        for _ in 1...numberOfPairsOfCards{
            let card = Card()
            cards += [card,card]
        }
        
        for _ in cards.indices{
            let r1 = Int(arc4random_uniform(UInt32(cards.count)))
            let r2 = Int(arc4random_uniform(UInt32(cards.count)))
            cards.swapAt(r1,r2)
        }
        
        // TODO: Shuffle Cards
    }
    
    
    func matchingCard(at index: Int){
        
        switch matchCards.count {
        case 0:
            matchCards.append(cards[index])
        case 1:
            matchCards.append(cards[index])
            
        case 2 :
            matchCards = []
            matchCards.append(cards[index])
        default:
            break
        }
        print(matchCards)
    }
    
    
    func calPoint() -> Int{
        if(matchCards.count == 2){
            if ( matchCards[0] == matchCards[1] ){
                addpoint += 2
            }else{
                matchCards.forEach{ (element) in
                    if(element.isTouched == true){
                        addpoint += -1
                    }
                }
            }
        }
        return addpoint
    }
}
