//
//  ParamView.swift
//  ShedCalc
//
//  Created by Jacky Jack on 28/07/2026.
//

import SwiftUI


struct ParamView: View {
    //@StateObject private var viewModel = ParamModel()
    @Environment(ParamModel.self) var paramModel
    
    var body: some View {
        @Bindable var paramModel = paramModel
        VStack {
            HStack {
                Text("Set shed dimensions")
            }
            HStack {
                Text("Width")
                TextField("Width", value: Binding(
                    get: { paramModel.width },
                    set: { newValue in
                        if !newValue.isNaN && !newValue.isInfinite && newValue > 0.5 && newValue < 10.0 {
                            paramModel.width = newValue
                        }
                    }
                    ), format: .number.precision(.fractionLength(2)))
            }
            HStack {
                Text("Length")
                TextField("Length", value: Binding(
                    get: { paramModel.length },
                    set: { newValue in
                        if !newValue.isNaN && !newValue.isInfinite && newValue > 0.5 && newValue < 10.0 {
                            paramModel.length = newValue
                        }
                    }
                    ), format: .number.precision(.fractionLength(2)))
            }
            HStack {
                Text("Height")
                TextField("Height", value: Binding(
                    get: { paramModel.height },
                    set: { newValue in
                        if !newValue.isNaN && !newValue.isInfinite && newValue > 0.5 && newValue < 3.0 {
                            paramModel.height = newValue
                        }
                    }
                    ), format: .number.precision(.fractionLength(2)))
            }
            HStack {
                Text("Spacing")
                TextField("Spacing", value: Binding(
                    get: { paramModel.beamSpace },
                    set: { newValue in
                        if !newValue.isNaN && !newValue.isInfinite && newValue > 0.15 && newValue < 10.0 {
                            paramModel.beamSpace = newValue
                        }
                    }
                ), format: .number.precision(.fractionLength(2)))
            }
            HStack {
                Text("Total floor area: \(paramModel.floorArea(), specifier: "%.2f") m^2")
            }
            HStack {
                Text("Total roof area: \(paramModel.roofArea(), specifier: "%.2f") m^2")
            }
            HStack {
                Text("Total wall beams: \(paramModel.totalWallBeams()) ")
            }
            HStack {
                Text("Set Timber Prices")
            }
            HStack {
                Text("OSB per sheet price")
                TextField("", value: Binding(
                    get: { paramModel.OSBSheetPrice },
                    set: { newValue in
                        if !newValue.isNaN && !newValue.isInfinite && newValue > 0.1 {
                            paramModel.OSBSheetPrice = newValue
                        }
                    }
                ), format: .number)
            }
            HStack {
                Text("Beam price per meter")
                TextField("", value: Binding(
                    get: { paramModel.timberBeamPrice },
                    set: { newValue in
                        if !newValue.isNaN && !newValue.isInfinite && newValue > 0.0 {
                            paramModel.timberBeamPrice = newValue
                        }
                    }
                ), format: .number)
                
                Text("Piece size")
                TextField("", value: Binding(
                    get: { paramModel.timberLengthSize },
                    set: { newValue in
                        if !newValue.isNaN && !newValue.isInfinite && newValue > 0.0 && newValue < 10.0 {
                            paramModel.timberLengthSize = newValue
                        }
                    }
                ), format: .number)
            }
            HStack {
                Text("Felt price")
                TextField("per meter", value: Binding(
                    get: { paramModel.feltPrice },
                    set: { newValue in
                        if !newValue.isNaN && !newValue.isInfinite && newValue > 0.0 {
                            paramModel.feltPrice = newValue
                        }
                    }
                ), format: .number)
                Text("Felt width")
                TextField("per meter", value: Binding(
                    get: { paramModel.feltWidth },
                    set: { newValue in
                        if !newValue.isNaN && !newValue.isInfinite && newValue > 0.0 && newValue < 10.0 {
                            paramModel.feltWidth = newValue
                        }
                    }
                ), format: .number)
                Text("Felt length")
                TextField("per meter", value: Binding(
                    get: { paramModel.feltLength },
                    set: { newValue in
                        if !newValue.isNaN && !newValue.isInfinite && newValue > 0.0 && newValue < 100.1{
                            paramModel.feltLength = newValue
                        }
                    }
                ), format: .number)
            }
            HStack {
                Text("Cladding dimensions and price")
            }
            HStack {
                Text("Cladding price per meter")
                TextField("", value: Binding(
                    get: { paramModel.claddingPrice },
                    set: { newValue in
                        if !newValue.isNaN && !newValue.isInfinite && newValue > 0.0 {
                            paramModel.claddingPrice = newValue
                        }
                    }
                ), format: .number)
                Text("Length")
                TextField("", value: Binding(
                    get: { paramModel.claddingLength },
                    set: { newValue in
                        if !newValue.isNaN && !newValue.isInfinite && newValue > 0.0 && newValue < 10.0 {
                            paramModel.claddingLength = newValue
                        }
                    }
                ), format: .number)
                Text("Width")
                TextField("", value: Binding(
                    get: { paramModel.claddingWidth },
                    set: { newValue in
                        if !newValue.isNaN && !newValue.isInfinite && newValue > 0.0 && newValue < 10.0
                            && (newValue > paramModel.claddingOverlap) {
                            paramModel.claddingWidth = newValue
                        }
                    }
                ), format: .number)
                Text("Overlap")
                TextField("", value: Binding(
                    get: { paramModel.claddingOverlap },
                    set: { newValue in
                        //overlap can't be bigger then width of cladding
                        if !newValue.isNaN && !newValue.isInfinite && (newValue > 0.0 && newValue < 10.0) && (newValue < paramModel.claddingWidth) {
                            paramModel.claddingOverlap = newValue
                        }
                    }
                ), format: .number)
            }
            HStack {
                Text("Weather wrap")
            }
            HStack {
                Text("Wrap price")
                TextField("per meter", value: Binding(
                    get: { paramModel.wrapPrice },
                    set: { newValue in
                        if !newValue.isNaN && !newValue.isInfinite && newValue > 0.0 {
                            paramModel.wrapPrice = newValue
                        }
                    }
                ), format: .number)
                Text("Wrap width")
                TextField("per meter", value: Binding(
                    get: { paramModel.wrapWidth },
                    set: { newValue in
                        if !newValue.isNaN && !newValue.isInfinite && newValue > 0.0 && newValue < 10.0 {
                            paramModel.wrapWidth = newValue
                        }
                    }
                ), format: .number)
                Text("Wrap length")
                TextField("per meter", value: Binding(
                    get: { paramModel.wrapLength },
                    set: { newValue in
                        if !newValue.isNaN && !newValue.isInfinite && newValue > 0.0 && newValue < 100.1 {
                            paramModel.wrapLength = newValue
                        }
                    }
                ), format: .number)
            }
        }
    }
}
