//
//  SetGameViewModel.swift
//  Set Game
//
//  Created by Eli Manjarrez on 11/4/20.
//

import Foundation

struct SetCardContent: DeeplyComparable {
    func countOfValues() -> Int {
        return 4
    }
    
    func valueAtIndex(index: Int) -> Int? {
        switch index {
        case 0:
            return fillStyle
        case 1:
            return shapeStyle
        case 2:
            return shapeCount
        case 3:
            return colorIndex
        default:
            return nil
        }
    }
    
    let fillStyle: Int
    let shapeStyle: Int
    let shapeCount: Int
    let colorIndex: Int
}

class SetGameViewModel : ObservableObject {
    @Published private var model: SetGameModel<SetCardContent> = SetGameViewModel.createSetGame()
    
    private static func createSetGame() -> SetGameModel<SetCardContent> {
        return SetGameModel<SetCardContent>(numberOfFillStyles: 3, numberOfShapeStyles: 3, numberOfShapeCounts: 3, numberOfColorIndexes: 3) { fillStyle, shapeStyle, shapeCount, colorIndex in
            return SetCardContent(fillStyle: fillStyle, shapeStyle: shapeStyle, shapeCount: shapeCount, colorIndex: colorIndex)
        }
    }
    
    func newSetGame() {
        model = SetGameViewModel.createSetGame()
        model.initialDeal()
    }
    
    func initialDeal() {
        model.initialDeal()
    }
    
    func dealThree() {
        model.dealThree()
    }
    
    // MARK: -  Access to the model
    var dealtCards: Array<SetGameModel<SetCardContent>.Card> {
        model.cardsOnBoard
    }
    
    var countOfSetsFound: Int {
        model.countOfSetsFound
    }
    
    // MARK: - Intents
    func select(card: SetGameModel<SetCardContent>.Card) {
        model.select(card: card)
    }
}
