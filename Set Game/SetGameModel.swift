//
//  SetGameModel.swift
//  Set Game
//
//  Created by Eli Manjarrez on 10/29/20.
//

import Foundation

enum CardState {
    case inDeck
    case dealt
    case matched
}

struct SetGameModel<CardContent> where CardContent : Equatable {
    private(set) var cards: Array<Card>
    private(set) var countOfSetsFound: Int = 0
    
    var dealtCards: Array<Card> {
        return cards.filter( { $0.cardState == .dealt } )
    }
    
    struct Card: Identifiable {
        var cardState: CardState = .inDeck
        var content: CardContent
        var id: Int
    }
    
    init(numberOfFillStyles: Int, numberOfShapeStyles: Int, numberOfShapeCounts: Int, numberOfColorIndexes: Int, cardContentFactory: (Int, Int, Int, Int) -> CardContent) {
        cards = Array<Card>()
        for fillStyleIndex in 0..<numberOfFillStyles {
            for shapeStyleIndex in 0..<numberOfShapeStyles {
                for shapeCountIndex in 0..<numberOfShapeCounts {
                    for colorIndexesIndex in 0..<numberOfColorIndexes {
                        let content = cardContentFactory(fillStyleIndex, shapeStyleIndex, shapeCountIndex, colorIndexesIndex)
                        let idToUse = ((fillStyleIndex + 1) * 11) + ((shapeStyleIndex + 1) * 13) + ((shapeCountIndex + 1) * 17) + ((colorIndexesIndex + 1) * 19)
                        cards.append(Card(content: content, id: idToUse))
                    }
                }
            }
        }
        cards.shuffle()
    }
    
    mutating func initialDeal() {
        for cardIndex in 0..<12 {
            cards[cardIndex].cardState = .dealt
        }
    }
    
    mutating func choose(card: Card) {
        print("card chosen \(card)");
    }
}
