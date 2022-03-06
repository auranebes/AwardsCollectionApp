//
//  Color.swift
//  AwardsCollectionApp
//
//  Created by Arslan Abdullaev on 06.03.2022.
//

import SwiftUI

struct AdditionalColors: Identifiable{
    var id = UUID().uuidString
    var hexValue: String
    var color: Color
    var rotateCards: Bool = false
    var addToGrid: Bool = false
    var showText: Bool = false
    var removeFromView: Bool = false
}
