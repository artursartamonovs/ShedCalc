//
//  RenderController.swift
//  ShedCalc
//
//  Created by Jacky Jack on 28/07/2026.
//

import SwiftUI
import RealityKit

let BEAM_2x4_WIDTH: Double = 0.02
let BEAM_2x4_LENGTH: Double = 0.04

struct BeamData {
      let id: String
      let position: SIMD3<Double>
      let height: Double
      let rotation: SIMD3<Double>
  }

class RenderController {
    var beamMaxId = 0
    
    func createScene(dimensions: SIMD3<Double>, rotation: SIMD2<Double>) -> Entity {
        let scene = Entity()
        scene.name = "scene"
        
        //let box = createBox(dimensions: [1,1,1])
        //scene.addChild(box)
        
        let beam0 = createBeam2x4(position: [1,1,0], height: 2.4, rotate: [90,0,0], id: "beam0")
        scene.addChild(beam0)
        
        //let beam1 = createBeam2x4(position: [1,0,0], height: 2.4, rotate: [0,0,0], id: "beam1")
        //scene.addChild(beam1)
        
        //let beam2 = createBeam2x4(position: [1,1,0], height: 2.4, rotate: [0,0,90], id: "beam2") //Z-around beam
        //scene.addChild(beam2)
        
        //let beam3 = createBeam2x4(position: [1,1,0], height: 2.4, rotate: [0,90,0], id: "beam3")
        //scene.addChild(beam3)
        
        let ground = createGround()
        scene.addChild(ground)
        
        return scene
    }
    
    func createLights() -> (DirectionalLight, PointLight) {
        let directional = DirectionalLight()
        directional.light.intensity = 2000
        directional.look(at: .zero, from: [2, 4, 3], relativeTo: nil)

        let point = PointLight()
        point.light.intensity = 5000
        point.position = [-2, 2, -2]

        return (directional, point)
    }
    
    func createCamera() -> PerspectiveCamera {
        let camera = PerspectiveCamera()
        camera.camera.fieldOfViewInDegrees = 60
        camera.position = [0,1,5]
        camera.look(at: .zero, from: camera.position, relativeTo: nil)
        return camera
    }
    
    // MARK: - Gesture Handling

    func handleDragGesture(
        _ value: DragGesture.Value,
        lastDrag: CGSize,
        currentRotation: SIMD2<Double>
    ) -> (rotation: SIMD2<Double>, drag: CGSize) {
        let dx = Double(value.translation.width - lastDrag.width) * 0.01
        let dy = Double(value.translation.height - lastDrag.height) * 0.01

        let newRotation = SIMD2<Double>(
            currentRotation.x + dy,
            currentRotation.y + dx
        )

        return (rotation: newRotation, drag: value.translation)
    }
    
    // MARK: - Private Helpers

    private func createBox(dimensions: SIMD3<Float>) -> ModelEntity {
        let box = ModelEntity(
            mesh: .generateBox(size: dimensions, cornerRadius: 0.02),
            materials: [SimpleMaterial(color: .yellow, isMetallic: false)]
        )
        box.position = [0,0,0]
        box.name = "box"
        return box
    }
    
    private func createBeam2x4(position: SIMD3<Float>, height: Double, rotate: SIMD3<Float>, id: String) -> ModelEntity {
        let box = ModelEntity(
            mesh: .generateBox(size: SIMD3(Float(BEAM_2x4_WIDTH),Float(BEAM_2x4_LENGTH),Float(height)), cornerRadius: 0.02),
            materials: [SimpleMaterial(color: .yellow, isMetallic: false)]
        )
        //box.look(at: position, from: lookFrom, relativeTo: nil)
        //box.setOrientation(.init(eulerAngles: lookFrom), relativeTo: nil)
        box.position = position
        // Create individual axis rotations
        let pitch = simd_quatf(angle: Float.pi*rotate.x/180.0, axis: [1, 0, 0])  // X-axis
        let yaw = simd_quatf(angle: Float.pi*rotate.y/180.0, axis: [0, 1, 0])    // Y-axis
        let roll = simd_quatf(angle: Float.pi*rotate.z/180.0, axis: [0, 0, 1])   // Z-axis

        // Combine rotations (order matters: usually yaw * pitch * roll)
        box.transform.rotation = yaw * pitch * roll
        box.name = "beam-\(id)"
        return box
    }
    
    func generateShedWall(position: SIMD3<Double>, height: Double, widthNum: Int, lengthNum: Int, spaceBeam: Double) -> [BeamData] {
        var beams: [BeamData] = []
        var id: Int = 0
        //Wall 0
        for i in 0...widthNum {
            let x0 = Double(i)*spaceBeam
            beams.append(BeamData(id: "beam-\(id)", position: [position.x+x0,position.y, position.z], height: height, rotation: [90,0,0]))
            id += 1
        }
        //Wall 1
        for i in 0...widthNum {
            let x0 = Double(i)*spaceBeam
            beams.append(BeamData(id: "beam-\(id)", position: [position.x+x0,position.y, position.z + Double(lengthNum)*spaceBeam], height: height, rotation: [90,0,0]))
            //print("\(id)")
            id += 1
        }
        //Wall 2
        for i in 0...lengthNum {
            let z0 = Double(i)*spaceBeam
            beams.append(BeamData(id: "beam-\(id)", position: [position.x,position.y, position.z + z0], height: height, rotation: [90,90,0]))
            //print("\(id)")
            id += 1
        }
        //Wall 3
        for i in 0...lengthNum {
            let z0 = Double(i)*spaceBeam
            beams.append(BeamData(id: "beam-\(id)", position: [position.x+Double(widthNum)*spaceBeam,position.y, position.z + z0], height: height, rotation: [90,90,0]))
            //print("\(id)")
            id += 1
        }
        
        self.beamMaxId = id
        return beams
    }
    
    func generateShedFloor(position: SIMD3<Double>, height: Double, width: Double, widthNum: Int, spaceBeam: Double) -> [BeamData] {
        var beams: [BeamData] = []
        var id = self.beamMaxId+1
        
        //all space
        for i in 0...widthNum {
            let x0 = Double(i)*spaceBeam
            let length = width
            beams.append(BeamData(id: "beam-\(id)", position:[position.x+x0,position.y-height/2, position.z+length/2], height: length, rotation: [0,0,0]))
            id += 1
        }
        
        //2 beams for length
        let length = Double(widthNum)*spaceBeam
            beams.append(BeamData(id: "beam-\(id)", position:[position.x+length/2, position.y-height/2, position.z], height: length, rotation: [0,90,0]))
        id += 1
        beams.append(BeamData(id: "beam-\(id)", position:[position.x+length/2,position.y-height/2, position.z+width], height: length, rotation: [0,90,0]))
        id += 1
        
        self.beamMaxId = id
        return beams
    }
    
    func generateShedRoof(position: SIMD3<Double>, height: Double, width: Double, widthNum: Int, spaceBeam: Double) -> [BeamData] {
        var beams: [BeamData] = []
        var id = self.beamMaxId+1
        
        //all space
        for i in 0...widthNum {
            let x0 = Double(i)*spaceBeam
            let length = width
            beams.append(BeamData(id: "beam-\(id)", position:[position.x+x0,position.y+height/2, position.z+length/2], height: length, rotation: [0,0,0]))
            id += 1
        }
        
        //2 beams for length
        let length = Double(widthNum)*spaceBeam
            beams.append(BeamData(id: "beam-\(id)", position:[position.x+length/2, position.y+height/2, position.z], height: length, rotation: [0,90,0]))
        id += 1
        beams.append(BeamData(id: "beam-\(id)", position:[position.x+length/2,position.y+height/2, position.z+width], height: length, rotation: [0,90,0]))
        id += 1
        
        self.beamMaxId = id
        return beams
    }
    
    func createBeams(_ beams: [BeamData]) -> [ModelEntity] {
        return beams.map { beam in
            createBeam2x4(position: SIMD3<Float>(beam.position), height: beam.height, rotate: SIMD3<Float>(beam.rotation), id: beam.id)
        }
    }

    private func createGround() -> ModelEntity {
        let ground = ModelEntity(
            mesh: .generatePlane(width: 10, depth: 10),
            materials: [UnlitMaterial(color: .green)]
        )
        ground.position.y = -0.5
        return ground
    }
}
