//
//  SetGameViewModel.swift
//  Set Game
//
//  Created by Eli Manjarrez on 11/4/20.
//

import Foundation

struct SetCardContent: Equatable {
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
    
    // MARK: -  Access to the model
    var dealtCards: Array<SetGameModel<SetCardContent>.Card> {
        model.dealtCards
    }
    
    var countOfSetsFound: Int {
        model.countOfSetsFound
    }
    
    // MARK: - Intents
    func choose(card: SetGameModel<SetCardContent>.Card) {
        model.choose(card: card)
    }
}
