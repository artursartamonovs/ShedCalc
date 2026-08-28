//
//  RenderModel.swift
//  ShedCalc
//
//  Created by Jacky Jack on 01/08/2026.
//
import SwiftUI
import Combine

class RenderModel: ObservableObject {
    // Scene rotation
    @Published var rotationX: Double = 0.4
    @Published var rotationY: Double = 0.6
    
    func reset() {
        rotationX = 0.4
        rotationY = 0.6
    }
}
