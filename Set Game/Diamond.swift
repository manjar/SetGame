//
//  Diamond.swift
//  Set Game
//
//  Created by Eli Manjarrez on 11/4/20.
//

import SwiftUI

struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        var returnPath = Path()
        let startPoint = CGPoint(x: rect.midX, y: 0.0)
        returnPath.move(to: startPoint)
        returnPath.addLine(to: CGPoint(x: 0.0, y: rect.midY))
        returnPath.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        returnPath.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        returnPath.addLine(to: startPoint)
        return returnPath
    }
}
