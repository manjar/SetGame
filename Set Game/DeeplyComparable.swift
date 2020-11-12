//
//  DeeplyComparable.swift
//  Set Game
//
//  Created by Eli Manjarrez on 11/11/20.
//

import Foundation

protocol DeeplyComparable {
    func countOfValues() -> Int
    func valueAtIndex(index: Int) -> Int?
}
