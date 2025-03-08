
import Foundation
import RealityKit
import ARKit

@Observable
final class ARViewController {
    
    static var shared = ARViewController()
    var arView: ARView
    private var weatherModelAnchor: AnchorEntity?
    
    init() {
        arView = ARView(frame: .zero)
    }
    
    func startARSession() {
        startPlaneDetection()
        startTapDetection()
    }
    
    private func startPlaneDetection() {
        
        arView.automaticallyConfigureSession = true
        
        // Configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        configuration.environmentTexturing = .automatic
        
        // Start plane detection
        arView.session.run(configuration)
    }
    
    private func startTapDetection() {
        arView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:))))
    }
    
    @objc
    private func handleTap(recognizer: UITapGestureRecognizer) {
        
        // Touch location
        let tapLocation = recognizer.location(in: arView)
        
        // Raycast (2D -> 3D pos)
        let results = arView.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .horizontal)
        
        // If plane detected
        if let firstResult = results.first {
            
            // 3D pos (x, y, z)
            let worldPosition = simd_make_float3(firstResult.worldTransform.columns.3)
            
            // Create 3D model
            let mesh = MeshResource.generateSphere(radius: 0.03)
            let material = SimpleMaterial(color: .black, isMetallic: true)
            let model = ModelEntity(mesh: mesh, materials: [material])
            
            // Place that 3D model at the plane
            placeObject(object: model, at: worldPosition)
        }
    }
    
    // Place object
    private func placeObject(object modelEntity: ModelEntity, at position: SIMD3<Float>) {
        
        // 1. Create anchor (at a 3D position)
        weatherModelAnchor = AnchorEntity(world: position)
        
        // 2. Tie model to anchor
        weatherModelAnchor!.addChild(modelEntity)
        
        // 3. Add anchor to scene
        arView.scene.addAnchor(weatherModelAnchor!)
    }
}
