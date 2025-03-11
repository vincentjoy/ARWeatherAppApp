
import ARKit
import RealityKit
import SwiftUI

struct RollingDiceRealityKitView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        let view = ARView()
        
        // Start plane detection
        let session = view.session
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        session.run(config)
        
        // Add coaching overlay which guides the user until the first plane is found
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coachingOverlay.session = session
        coachingOverlay.goal = .horizontalPlane
        view.addSubview(coachingOverlay)
        
        // Set debug options
        #if DEBUG
        view.debugOptions = [.showFeaturePoints, .showAnchorOrigins, .showAnchorGeometry]
        #endif
        
        return view
    }
    
    func updateUIView(_ view: ARView, context: Context) {
        
    }
}
