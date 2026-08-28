//
//  Item.swift
//  ShedCalc
//
//  Created by Jacky Jack on 28/07/2026.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
