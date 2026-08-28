//
//  ParamModel.swift
//  ShedCalc
//
//  Created by Jacky Jack on 01/08/2026.
//
import Combine
import SwiftUI
import Observation

@Observable
class ParamModel {
    var width: Double = 3.0
    var height: Double = 1.0
    var length: Double = 1.0
    var beamSpace: Double = 0.6
    var OSBSheetPrice: Double = 1.0
    var timberBeamPrice: Double = 1.0
    var timberLengthSize: Double = 2.4
    var feltPrice: Double = 1.0
    var feltWidth: Double = 1.0
    var feltLength: Double = 10
    var claddingPrice: Double = 1.0
    var claddingLength: Double = 2.4
    var claddingWidth: Double = 0.1
    var claddingOverlap: Double = 0.01
    var wrapPrice: Double = 1.0
    var wrapWidth: Double = 1.0
    var wrapLength: Double = 10
    
    func floorArea() -> Double {
        return width*length
    }
    
    func roofArea() -> Double {
        return width*length
    }
    
    func dimensions() -> SIMD3<Double> {
        return [width,length,height]
    }
    
    func widthBeamNum() -> Int {
        return Int(width/beamSpace) + 1
    }
    
    func lengthBeamNum() -> Int {
        return Int(length/beamSpace) + 1
    }
    
    func setBeamSpace(_ bs: Double) {
        self.beamSpace = bs
    }
    
    func totalWallBeams() -> Int {
        return 2 * (widthBeamNum() + lengthBeamNum())
    }
    
    func totalWallBeamLength() -> Double {
        return Double(totalWallBeams()) * self.height
    }
    
    func totalJoistBeamLength() -> Double {
        return Double(widthBeamNum())*beamSpace
    }
    
    func totalWallArea() -> Double {
        return  (self.width * self.height)*2 + (self.length * self.height)*2
    }
}
