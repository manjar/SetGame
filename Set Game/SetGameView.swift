//
//  SetGameView.swift
//  Set Game
//
//  Created by Eli Manjarrez on 10/29/20.
//

import SwiftUI

struct SetGameView: View {
    static let colorArray = [Color.green, Color.orange, Color.purple]

    @ObservedObject var viewModel: SetGameViewModel
    
    var body: some View {
        VStack {
            Text("Score: \(viewModel.countOfSetsFound)")
            Grid(viewModel.dealtCards) { card in
                CardView(content: card.content)
                    .onTapGesture() {
                        withAnimation(.linear) {
                            viewModel.choose(card: card)
                        }
                    }
                    .aspectRatio(contentMode:.fit)
                    .padding(5.0)
            }
            .padding()
//            .foregroundColor(EmojiMemoryGame.themeColor)
            Button(action: {
                withAnimation(.easeInOut) {
                    viewModel.newSetGame()
                }
            }, label: {
                Text("New Game")
            })
        }.font(Font.system(size: 32))
        .onAppear {
            viewModel.initialDeal()
        }
    }
}

struct CardView: View {
    var content: SetCardContent
    
    var body: some View {
        RoundedRectangle(cornerRadius: 5.0).foregroundColor(SetGameView.colorArray[content.colorIndex])
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetGameViewModel()
        SetGameView(viewModel: game)
    }
}
