//
//  RenderView.swift
//  ShedCalc
//
//  Created by Jacky Jack on 28/07/2026.
//
import SwiftUI
import RealityKit

struct RenderView: View {
    private let renderController = RenderController()
    @Environment(ParamModel.self) var paramModel
    @StateObject private var viewModel = RenderModel()
    @State private var lastDrag: CGSize = .zero
    
    var body: some View {
        VStack(spacing: 0) {
            RealityView { content in
                //add objects to scence
                let scene = renderController.createScene(dimensions: [0,0,0], rotation: [0,0])
                content.add(scene)
                
                //add lights to scene
                
                //create camera view
                let camera = renderController.createCamera()
                content.add(camera)
        
                //draw beams
                //let beam = renderController.createBeam2x4(position: [0,0,0], height: 2.4, lookFrom: camera.position, id: "beam0")
                //content.addChild(beam)
                
                //draw all beams
                let beamData = renderController.generateShedWall(position: [0,0,0], height: paramModel.height, widthNum: paramModel.widthBeamNum(), lengthNum: paramModel.lengthBeamNum(), spaceBeam: paramModel.beamSpace)
                let wallBeams = renderController.createBeams(beamData)
                wallBeams.forEach { scene.addChild($0) }
                
                //let floorBeamData = renderController.generateShedFloor(position: [0,0,0], width: Float(1.0), widthNum: paramModel.widthBeamNum(), spaceBeam: paramModel.beamSpace)
                //let floorBeams = renderController.createBeams(floorBeamData)
                //floorBeams.forEach { scene.addChild($0) }
                
            } update: { content in
                // Update box geometry directly in the scene
                //if let scene = content.entities.first(where: { $0.name == "scene" }),
                //let box = scene.findEntity(named: "box") as? ModelEntity {
                //box.model?.mesh = .generateBox(size: paramModel.dimensions(), cornerRadius: 0.02)
                //}
                if let scene = content.entities.first(where: { $0.name == "scene"}) {
                    let oldBeams = scene.children.filter { $0.name.hasPrefix("beam-") }
                              oldBeams.forEach { $0.removeFromParent() }
                    
                    let beamData = renderController.generateShedWall(position: [0,0,0], height: paramModel.height, widthNum: paramModel.widthBeamNum(), lengthNum: paramModel.lengthBeamNum(), spaceBeam: paramModel.beamSpace)
                    let beams = renderController.createBeams(beamData)
                    beams.forEach { scene.addChild($0) }
                    
                    let floorBeamData = renderController.generateShedFloor(position: [0,0,0], height: paramModel.height, width: Double(paramModel.lengthBeamNum())*paramModel.beamSpace, widthNum: paramModel.widthBeamNum(), spaceBeam: paramModel.beamSpace)
                    let floorBeams = renderController.createBeams(floorBeamData)
                    floorBeams.forEach { scene.addChild($0) }
                    
                    let roofBeamData = renderController.generateShedRoof(position: [0,0,0], height: paramModel.height, width: Double(paramModel.lengthBeamNum())*paramModel.beamSpace, widthNum: paramModel.widthBeamNum(), spaceBeam: paramModel.beamSpace)
                    let roofBeams = renderController.createBeams(roofBeamData)
                    roofBeams.forEach { scene.addChild($0) }
                }
                   
                // Update scene rotation directly
                if let scene = content.entities.first(where: { $0.name == "scene" }) {
                    let xRot = simd_quatf(angle: Float(viewModel.rotationX), axis: [1, 0, 0])
                    let yRot = simd_quatf(angle: Float(viewModel.rotationY), axis: [0, 1, 0])
                    scene.transform.rotation = yRot * xRot
                }
                //update amount of beams
            }.gesture(
                DragGesture()
                    .onChanged { value in
                        let result = renderController.handleDragGesture(
                            value,
                            lastDrag: lastDrag,
                            currentRotation: [viewModel.rotationX, viewModel.rotationY]
                        )
                        viewModel.rotationX = result.rotation.x
                        viewModel.rotationY = result.rotation.y
                        lastDrag = result.drag
                    }
                    .onEnded { _ in
                        lastDrag = .zero
                    }
            )
        }
        .frame(minWidth: 500, minHeight: 500)
    }
}
