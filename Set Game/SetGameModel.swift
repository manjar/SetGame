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

struct SetGameModel<CardContent> where CardContent : DeeplyComparable {
    private(set) var cards: Array<Card>
    private(set) var countOfSetsFound: Int = 0
    
    var cardsOnBoard: Array<Card> {
        return cards.filter( { $0.cardState != .inDeck && $0.cardState != .discarded} )
    }
    
    var undealtCards: Array<Card> {
        return cards.filter( { $0.cardState == .inDeck } )
    }

    var selectedCards: Array<Card> {
        return cards.filter( { $0.cardState == .selected } )
    }
    
    var matchedCards: Array<Card> {
        return cards.filter( { $0.cardState == .matched } )
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
        clearSelectedCards()
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
        let countOfSelectedCards = matchedCards.count
        guard countOfSelectedCards == 3 else {
            return
        }
        for cardIndex in 0..<countOfSelectedCards {
            let cardToDiscard = matchedCards[cardIndex]
            indexesOfCardsToDiscard.append(cards.firstIndex(matching:cardToDiscard)!)
        }
        for cardIndex in indexesOfCardsToDiscard {
            cards[cardIndex].cardState = .discarded
            if undealtCards.count > 0 {
                let nextCardToDeal = undealtCards[0]
                let indexOfNextCardToDeal = cards.firstIndex(matching:nextCardToDeal)!
                cards[indexOfNextCardToDeal].cardState = .dealt
                cards.swapAt(cardIndex, indexOfNextCardToDeal)
            }
        }
    }
    
    
    mutating func clearSelectedCards() {
        var indexesOfCardsToDiscard = [Int]()
        let countOfSelectedCards = selectedCards.count
        guard countOfSelectedCards == 3 else {
            return
        }
        for cardIndex in 0..<countOfSelectedCards {
            let cardToDiscard = selectedCards[cardIndex]
            indexesOfCardsToDiscard.append(cards.firstIndex(matching:cardToDiscard)!)
        }
        for cardIndex in indexesOfCardsToDiscard {
            cards[cardIndex].cardState = .dealt
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
        var validSet = true
        for comparablePropertyIndex in 0..<firstCard.content.countOfValues() {
            var valueHolder = Set<Int>()
            valueHolder.insert(firstCard.content.valueAtIndex(index: comparablePropertyIndex)!)
            valueHolder.insert(secondCard.content.valueAtIndex(index: comparablePropertyIndex)!)
            valueHolder.insert(thirdCard.content.valueAtIndex(index: comparablePropertyIndex)!)
            if (valueHolder.count == 2) {
                validSet = false
                break
            }
        }
        if (validSet) {
            handleSet(firstCard, secondCard, thirdCard)
        }
    }
    
    mutating func handleSet(_ card1: Card, _ card2: Card, _ card3: Card) {
        for aCard in [card1, card2, card3] {
            let indexOfCardToMatch = cards.firstIndex(matching:aCard)!
            cards[indexOfCardToMatch].cardState = .matched
        }
        countOfSetsFound += 1
    }
    
}
