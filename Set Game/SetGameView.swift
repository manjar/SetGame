//
//  SetGameView.swift
//  Set Game
//
//  Created by Eli Manjarrez on 10/29/20.
//

import SwiftUI

struct SetGameView: View {
    static let colorArray   = [Color.green, Color.orange, Color.purple]
    static let opacityArray = [0.0, 0.3, 1.0]

    @ObservedObject var viewModel: SetGameViewModel
    
    var body: some View {
        VStack {
            Text("Score: \(viewModel.countOfSetsFound)")
            Grid(viewModel.dealtCards) { card in
                CardView(card: card)
                    .onTapGesture() {
                        withAnimation(.linear) {
                            viewModel.select(card: card)
                        }
                    }
                    .aspectRatio(contentMode:.fit)
                    .padding(5.0)
            }
            .padding()
//            .foregroundColor(EmojiMemoryGame.themeColor)
            Button(action: {
                withAnimation(.easeInOut(duration:0.3)) {
                    viewModel.dealThree()
                }
            }, label: {
                Text("Deal three")
            }).disabled(viewModel.undealtCards.count == 0)
            Button(action: {
                withAnimation(.easeInOut) {
                    viewModel.newSetGame()
                }
            }, label: {
                Text("New Game")
            })
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.3)) {
                viewModel.initialDeal()
            }
        }
        .font(Font.system(size: 24))
    }
}

struct CardView: View {
    var card: SetGameModel<SetCardContent>.Card
    var shape: some Shape {
        self.shapeForShapeIndex(card.content.shapeStyle)
    }
    
    @ViewBuilder var body: some View {
        GeometryReader { geometry in
            body(for: geometry.size)
        }.transition(.offset(randomSizeForOffset()))
    }
    
    func randomSizeForOffset() -> CGSize {
        let randomDouble = Double.random(in: 0..<1)
        let directionInRadians = randomDouble * 2.0 * Double.pi
        let returnSize = CGSize(width: sin(directionInRadians) * 1000.0, height: cos(directionInRadians) * 1000.0)
        return returnSize
    }
    
    @ViewBuilder
    private func body(for size:CGSize) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5.0).foregroundColor(card.cardState == .dealt ? Color.white : colorForCardState(card.cardState))
            RoundedRectangle(cornerRadius: 5.0).stroke(Color.black)
            VStack {
                ForEach(0 ..< card.content.shapeCount) {_ in
                    ZStack {
                        shape.foregroundColor(.white)
                        shape.foregroundColor(SetGameView.colorArray[card.content.colorIndex].opacity(SetGameView.opacityArray[card.content.fillStyle]))
                        shape.stroke().foregroundColor(SetGameView.colorArray[card.content.colorIndex])
                    }.frame(width: size.width * itemSizeFactor, height: size.width * itemSizeFactor, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                }
            }
            .padding(5.0)
        }
    }
    
    func colorForCardState(_ cardState: CardState) -> Color {
        switch cardState {
        case .matched:
            return Color.green.opacity(cardColorOpacity)
        case .selected:
            return Color.blue.opacity(cardColorOpacity)
        default:
            return Color.white.opacity(cardColorOpacity)
        }
    }
    
    struct AnyShape: Shape {
        init<S: Shape>(_ wrapped: S) {
            _path = { rect in
                let path = wrapped.path(in: rect)
                return path
            }
        }

        func path(in rect: CGRect) -> Path {
            return _path(rect)
        }

        private let _path: (CGRect) -> Path
    }
    
    func shapeForShapeIndex(_ shapeIndex:Int) -> some Shape {
        switch shapeIndex {
        case 0:
            return AnyShape(Circle())
        case 1:
            return AnyShape(Rectangle())
        case 2:
            return AnyShape(Diamond())
        default:
            return AnyShape(Capsule())
        }
    }
    
    private let itemSizeFactor: CGFloat = 0.2
    private let cardColorOpacity = 0.3
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetGameViewModel()
        SetGameView(viewModel: game)
    }
}
