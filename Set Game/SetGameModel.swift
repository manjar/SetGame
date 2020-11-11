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
    case selected
    case matched
    case discarded
}

struct SetGameModel<CardContent> where CardContent : Equatable {
    private(set) var cards: Array<Card>
    private(set) var countOfSetsFound: Int = 0
    
    var dealtCards: Array<Card> {
        return cards.filter( { $0.cardState != .inDeck && $0.cardState != .matched } )
    }
    
    var undealtCards: Array<Card> {
        return cards.filter( { $0.cardState == .inDeck } )
    }

    var selectedCards: Array<Card> {
        return cards.filter( { $0.cardState == .selected } )
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
                        let content = cardContentFactory(fillStyleIndex, shapeStyleIndex, shapeCountIndex + 1, colorIndexesIndex)
                        let idToUse = UUID().hashValue
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
    
    mutating func dealThree() {
        let numberOfCardsToDeal = min(undealtCards.count, 3)
        var indexesOfCardsToDeal = [Int]()
        for cardIndex in 0..<numberOfCardsToDeal {
            let cardToDeal = undealtCards[cardIndex]
            indexesOfCardsToDeal.append(cards.firstIndex(matching:cardToDeal)!)
        }
        for cardIndex in indexesOfCardsToDeal {
            cards[cardIndex].cardState = .dealt
        }
    }
    
    mutating func select(card: Card) {
        clearPreviousSet()
        toggleCardSelectedState(card: card)
        checkForSetAndHandle()
    }
    
    mutating func toggleCardSelectedState(card: Card) {
        if let indexOfCardToSelect = cards.firstIndex(matching: card) {
            switch card.cardState {
            case .dealt:
                cards[indexOfCardToSelect].cardState = .selected
            case .selected:
                cards[indexOfCardToSelect].cardState = .dealt
            default:
                break
            }
            print("card chosen \(card)");

        }
    }
    
    mutating func clearPreviousSet() {
        var indexesOfCardsToDiscard = [Int]()
        for cardIndex in 0..<selectedCards.count {
            let cardToDiscard = selectedCards[cardIndex]
            indexesOfCardsToDiscard.append(cards.firstIndex(matching:cardToDiscard)!)
        }
        for cardIndex in indexesOfCardsToDiscard {
            cards[cardIndex].cardState = .discarded
        }
    }
    
    mutating func checkForSetAndHandle() {
        let countOfSelectedCards = selectedCards.count
        guard countOfSelectedCards == 3 else {
            return
        }
        let firstCard  = selectedCards[0]
        let secondCard = selectedCards[1]
        let thirdCard  = selectedCards[2]
    }
    
}
