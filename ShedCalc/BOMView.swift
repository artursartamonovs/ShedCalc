//
//  BOMView.swift
//  ShedCalc
//
//  Created by Jacky Jack on 28/07/2026.
//

import SwiftUI
import Combine

struct BOMView: View {
    @Environment(ParamModel.self) private var paramModel
    private let bomController = BOMController()
    
    private var materials: [MaterialItem] {
        bomController.calcBOM(from: paramModel)
    }
    
    private var totalPrice: Double {
        materials.reduce(0) { $0 + $1.totalPrice }
    }
    
    /*@State private var materials = [
        MaterialItem(materialName: "2x4", pricePerMeter: 1.2, totalMeters: 10, totalPrice: 12, metersPerPiece: 4.8, totalPieces: 23),
        MaterialItem(materialName: "OSB", pricePerMeter: 1.2, totalMeters: 10, totalPrice: 12, metersPerPiece: 4.8, totalPieces: 23),
        MaterialItem(materialName: "Roof Felt", pricePerMeter: 1.2, totalMeters: 10, totalPrice: 12, metersPerPiece: 4.8, totalPieces: 23),
        MaterialItem(materialName: "Nails", pricePerMeter: 1.2, totalMeters: 10, totalPrice: 12, metersPerPiece: 4.8, totalPieces: 23),
        MaterialItem(materialName: "Cladding", pricePerMeter: 1.2, totalMeters: 10, totalPrice: 12, metersPerPiece: 4.8, totalPieces: 23)
    ]*/
    
    var body: some View {
        VStack {
            Text("BOM")
        }
        VStack {
            Table(materials) {
                TableColumn("Material", value: \.materialName)
                TableColumn("Total m") { material in
                    Text(material.totalMeters, format: .number.precision(.fractionLength(2)))
                }
                TableColumn("Price per m") { material in
                    Text(material.pricePerMeter, format: .number.precision(.fractionLength(2)))
                }
                TableColumn("m per Piece") { material in
                    Text(material.metersPerPiece, format: .number.precision(.fractionLength(2)))
                }
                TableColumn("Pieces") { material in
                    Text(material.totalPieces, format: .number)
                }
                TableColumn("Total price") { material in
                    Text(material.totalPrice, format: .number.precision(.fractionLength(2)))
                }
            }
        }
        HStack {
            Text("Total price: \(totalPrice, format: .number.precision(.fractionLength(2)))")
        }
    }
}
