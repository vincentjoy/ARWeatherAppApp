
import ARKit
import RealityKit
import SwiftUI
import FocusEntity

struct RollingDiceRealityKitView: UIViewRepresentable {
    
    class Coordinator: NSObject, ARSessionDelegate {
        weak var view: ARView?
        var focusEntity: FocusEntity?
        var diceEntity: ModelEntity?

        func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
            guard let view = self.view else { return }
            debugPrint("Anchors added to the scene: ", anchors)
            self.focusEntity = FocusEntity(on: view, style: .classic(color: .yellow))
        }
        
        @objc func handleTap() {
            guard let view = self.view, let focusEntity = self.focusEntity else { return }

            // Create a new anchor to add content to
            let anchor = AnchorEntity()
            view.scene.anchors.append(anchor)
            
            guard diceEntity == nil else {
                diceEntity!.addForce([0, 2, 0], relativeTo: nil)
                diceEntity!.addTorque([Float.random(in: 0 ... 0.4), Float.random(in: 0 ... 0.4), Float.random(in: 0 ... 0.4)], relativeTo: nil)
                return
            }

            // Add a dice entity
            diceEntity = try! ModelEntity.loadModel(named: "Dice")
            diceEntity!.scale = [0.1, 0.1, 0.1]
            diceEntity!.position = focusEntity.position

            anchor.addChild(diceEntity!)
            
            // Enabling Physics simulation for the dice, so it can be rolled
            let size = diceEntity!.visualBounds(relativeTo: diceEntity!).extents
            let boxShape = ShapeResource.generateBox(size: size)
            diceEntity!.collision = CollisionComponent(shapes: [boxShape])
            
            diceEntity!.physicsBody = PhysicsBodyComponent(
                massProperties: .init(shape: boxShape, mass: 50),
                material: nil,
                mode: .dynamic
            )
            
            // Create a plane below the dice
            let planeMesh = MeshResource.generatePlane(width: 2, depth: 2)
            let material = SimpleMaterial(color: .init(white: 1.0, alpha: 0.1), isMetallic: false)
            let planeEntity = ModelEntity(mesh: planeMesh, materials: [material])
            planeEntity.position = focusEntity.position
            planeEntity.physicsBody = PhysicsBodyComponent(massProperties: .default, material: nil, mode: .static)
            planeEntity.collision = CollisionComponent(shapes: [.generateBox(width: 2, height: 0.001, depth: 2)])
            planeEntity.position = focusEntity.position
            anchor.addChild(planeEntity)
        }
    }
    
    func makeUIView(context: Context) -> ARView {
        let view = ARView()
        
        // Start plane detection
        let session = view.session
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        session.run(config)
        
        // Handle ARSession events via delegate
        context.coordinator.view = view
        session.delegate = context.coordinator
        
        // Handle taps
        view.addGestureRecognizer(
            UITapGestureRecognizer(
                target: context.coordinator,
                action: #selector(Coordinator.handleTap)
            )
        )
        
        // Add coaching overlay which guides the user until the first plane is found
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coachingOverlay.session = session
        coachingOverlay.goal = .horizontalPlane
        view.addSubview(coachingOverlay)
        
        // Set debug options
        #if DEBUG
        view.debugOptions = [.showAnchorOrigins, .showPhysics]
        #endif
        
        return view
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func updateUIView(_ view: ARView, context: Context) {
        
    }
}
