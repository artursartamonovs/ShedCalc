//
//  BOMController.swift
//  ShedCalc
//
//  Created by Jacky Jack on 01/08/2026.
//
import SwiftUI
import Combine

private func roundUpPieces(_ value: Float) -> Int {
    Int(value.rounded(.up))
}

private func roundUpPieces(_ value: Double) -> Int {
    Int(value.rounded(.up))
}

struct MaterialItem: Identifiable {
    let materialName: String
    let pricePerMeter: Double
    let totalMeters: Double
    let totalPrice: Double
    let metersPerPiece: Double
    let totalPieces: Double
    
    let id = UUID()
}
class BOMController {
    
    func calcBOM(from paramModel: ParamModel) -> [MaterialItem] {
        var items: [MaterialItem] = []
        items.append(calcOSB(from: paramModel))
        items.append(calcWallTimber2x4(from: paramModel))
        items.append(calcFloorTimber2x4(from: paramModel))
        items.append(calcRoofTimber2x4(from: paramModel))
        items.append(calcRoofFelt(from: paramModel))
        items.append(calcWeatherWrap(from: paramModel))
        items.append(calcCladding(from: paramModel))
        return items
    }
    
    private func calcOSB(from paramModel: ParamModel) -> MaterialItem {
        let totalOSBarea = paramModel.floorArea()
        let OSBPrice = totalOSBarea*paramModel.OSBSheetPrice
        let OSBPricePerMeter = paramModel.OSBSheetPrice / (1.2*2.4)
        let totalPieces = roundUpPieces(totalOSBarea / (1.2*2.4))
        return MaterialItem(
            materialName: "OSB",
            pricePerMeter: Double(OSBPricePerMeter),
            totalMeters: Double(totalOSBarea),
            totalPrice: Double(totalPieces)*Double(paramModel.OSBSheetPrice),
            metersPerPiece:Double(paramModel.OSBSheetPrice),
            totalPieces: Double(totalPieces))
    }
    
    private func calcWallTimber2x4(from paramModel: ParamModel) -> MaterialItem {
        let totalLength = paramModel.totalWallBeamLength()
        let timberBeamPrice = paramModel.timberBeamPrice
        let totalPrice = totalLength*timberBeamPrice
        let pieceSize = paramModel.timberLengthSize
        let totalPieces = roundUpPieces(totalLength/pieceSize)
        return MaterialItem(
            materialName: "2x4",
            pricePerMeter: Double(timberBeamPrice),
            totalMeters: Double(totalLength),
            totalPrice: Double(totalPrice),
            metersPerPiece:Double(pieceSize),
            totalPieces: Double(totalPieces)
        )
    }
    private func calcFloorTimber2x4(from paramModel: ParamModel) -> MaterialItem {
        let joistLength = paramModel.totalJoistBeamLength() * 2
        let spacersLength = Double(paramModel.lengthBeamNum())*paramModel.beamSpace
        let timberBeamPrice = paramModel.timberBeamPrice
        let totalLength = Double(paramModel.lengthBeamNum())*paramModel.beamSpace
        let totalPrice = totalLength*timberBeamPrice
        let pieceSize = Double(paramModel.timberLengthSize)
        let totalPieces = roundUpPieces(totalLength/pieceSize)
        return MaterialItem(
            materialName: "Floor 2x4",
            pricePerMeter: Double(timberBeamPrice),
            totalMeters: Double(totalLength),
            totalPrice: Double(totalPrice),
            metersPerPiece:Double(pieceSize),
            totalPieces: Double(totalPieces)
        )
    }
    
    private func calcRoofTimber2x4(from paramModel: ParamModel) -> MaterialItem {
        let joistLength = paramModel.totalJoistBeamLength() * 2
        let spacersLength = Double(paramModel.lengthBeamNum())*paramModel.beamSpace
        let timberBeamPrice = paramModel.timberBeamPrice
        let totalLength = Double(paramModel.lengthBeamNum())*paramModel.beamSpace
        let totalPrice = totalLength*timberBeamPrice
        let pieceSize = Double(paramModel.timberLengthSize)
        let totalPieces = roundUpPieces(totalLength/pieceSize)
        return MaterialItem(
            materialName: "Roof 2x4",
            pricePerMeter: Double(timberBeamPrice),
            totalMeters: Double(totalLength),
            totalPrice: Double(totalPrice),
            metersPerPiece:Double(pieceSize),
            totalPieces: Double(totalPieces)
        )
    }
    
    private func calcRoofFelt(from paramModel: ParamModel) -> MaterialItem {
        let roofArea = paramModel.roofArea()
        let feltRollArea = Double(paramModel.feltWidth)*Double(paramModel.feltLength)
        var feltPricePerMeter:Double = 0.0
        if paramModel.feltPrice > 0.0 {
            feltPricePerMeter = Double(paramModel.feltPrice) / feltRollArea
        }
        let totalPieces = roundUpPieces(Double(roofArea)/Double(feltRollArea))
        
        let totalPrice = Double(totalPieces) * paramModel.feltPrice
        
        return MaterialItem(
            materialName: "Roof Felt",
            pricePerMeter: Double(feltPricePerMeter),
            totalMeters: Double(roofArea),
            totalPrice: Double(totalPrice),
            metersPerPiece:Double(feltRollArea),
            totalPieces: Double(totalPieces)
        )
    }
    
    private func calcWeatherWrap(from paramModel: ParamModel) -> MaterialItem {
        let wrapRollArea = paramModel.wrapWidth * paramModel.wrapLength
        let wrapPricePerMeter = paramModel.wrapPrice / wrapRollArea
        let wrapArea = paramModel.totalWallArea()
        
        let totalPieces = roundUpPieces(Double(wrapArea)/Double(wrapRollArea))
        let totalPrice = Double(totalPieces) * paramModel.wrapPrice
        
        return MaterialItem(
            materialName: "Weather Wrap",
            pricePerMeter: wrapPricePerMeter,
            totalMeters: wrapArea,
            totalPrice: totalPrice,
            metersPerPiece: paramModel.wrapPrice,
            totalPieces: Double(totalPieces)
        )
    }
    
    private func calcCladding(from paramModel: ParamModel) -> MaterialItem {
        let wallArea = Double(paramModel.length*paramModel.height)*2 + Double(paramModel.width*paramModel.height)*2
        let singleCladArea = paramModel.claddingLength * (Double(paramModel.claddingWidth) - paramModel.claddingOverlap)
        let claddingPieces = wallArea/singleCladArea
        let totalPieces = roundUpPieces(claddingPieces)
        let totalPrice = Double(totalPieces) * paramModel.claddingPrice
        return MaterialItem(
            materialName: "Cladding",
            pricePerMeter: Double(paramModel.claddingPrice),
            totalMeters: Double(claddingPieces*paramModel.claddingLength),
            totalPrice: Double(totalPrice),
            metersPerPiece:Double(paramModel.claddingLength),
            totalPieces: Double(totalPieces)
        )
    }
    
    private func calcBeam(from paramModel: ParamModel) -> MaterialItem {
        return MaterialItem(materialName: "2x4", pricePerMeter: 1.0, totalMeters: 10, totalPrice: 100, metersPerPiece: 1.2, totalPieces: 11.2)
    }
    
}
