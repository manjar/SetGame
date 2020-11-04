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
                        cards.append(Card(content: content, id: (fillStyleIndex * 2) + (shapeStyleIndex * 3) + (shapeCountIndex * 5) + (colorIndexesIndex * 7)))
                    }
                }
            }
        }
        cards.shuffle()
    }
}
