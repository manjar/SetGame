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
                withAnimation(.easeInOut) {
                    viewModel.dealThree()
                }
            }, label: {
                Text("Deal three")
            })
            Button(action: {
                withAnimation(.easeInOut) {
                    viewModel.newSetGame()
                }
            }, label: {
                Text("New Game")
            })
        }.font(Font.system(size: 24))
        .onAppear {
            viewModel.initialDeal()
        }
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
        }
    }
    
    @ViewBuilder
    private func body(for size:CGSize) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5.0).foregroundColor(card.cardState == .dealt ? Color.white : Color.init(red: 0.0, green: 0.0, blue: 1.0, opacity: 0.25))
            RoundedRectangle(cornerRadius: 5.0).stroke(Color.black)
            VStack {
                ForEach(0 ..< card.content.shapeCount) {_ in
                    ZStack {
                        shape.foregroundColor(.white)
                        shape.foregroundColor(SetGameView.colorArray[card.content.colorIndex].opacity(SetGameView.opacityArray[card.content.fillStyle]))
                        shape.stroke()
                    }.frame(width: size.width * itemSizeFactor, height: size.width * itemSizeFactor, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                }
            }
            .padding(5.0)
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
    
    func colorForCardState(_ cardState:CardState) -> Color {
        switch cardState {
        case .selected:
            return Color.blue.opacity(0.3)
        default:
            return Color.white
        }
    }
    
    private let itemSizeFactor: CGFloat = 0.2
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetGameViewModel()
        SetGameView(viewModel: game)
    }
}
