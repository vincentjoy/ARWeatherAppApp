
import Foundation
import ARKit
import RealityKit
import SwiftUI


// MARK: - AR Views
struct ARViewDisplay: View {
    var body: some View {
        ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    typealias UIViewType = ARView
    
    func makeUIView(context: Context) -> ARView {
        ARViewController.shared.startARSession()
        return ARViewController.shared.arView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
