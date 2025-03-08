
import Foundation
import RealityKit
import AVKit

class WeatherARModelManager {
    
    func generateWeatherARModel(condition: String, temperature: String) -> ModelEntity {
        
        // Ball and text
        let conditionModel = weatherConditionModel(condition: condition)
        let temperatureText = createWeatherText(with: temperature)
        
        // Place text on top of ball
        conditionModel.addChild(temperatureText)
        temperatureText.setPosition(SIMD3<Float>(-0.07, 0.05, 0.0), relativeTo: conditionModel)
        
        // Name
        conditionModel.name = "weatherBall"
        
        return conditionModel
    }
    
    // MARK: - Ball create (condition)
    private func weatherConditionModel(condition: String) -> ModelEntity {
        
        // Mesh
        let ballMesh = MeshResource.generateBox(size: 0.1)
        
        // Video Material
        let videoItem = createVideoItem(with: condition)
        let videoMaterial = createVideoMaterial(with: videoItem!)
        
        // Model Entity
        let ballModel = ModelEntity(mesh: ballMesh, materials: [videoMaterial])
        
        return ballModel
    }
    
    private func createVideoItem(with fileName: String) -> AVPlayerItem? {
        
        // URL
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp4") else { return nil }
        
        // Video Item
        let asset = AVURLAsset(url: url)
        let videoItem = AVPlayerItem(asset: asset)
        
        return videoItem
    }
    
    private func createVideoMaterial(with videoItem: AVPlayerItem) -> VideoMaterial {
        
        // Video Player
        let player = AVPlayer()
        
        // Video Material
        let videoMaterial = VideoMaterial(avPlayer: player)
        
        // Play video
        player.replaceCurrentItem(with: videoItem)
        player.play()
        
        return videoMaterial
    }
    
    // MARK: - Text create (temperature)
    private func createWeatherText(with temperature: String) -> ModelEntity {
        
        let mesh = MeshResource.generateText(temperature, extrusionDepth: 0.1, font: .systemFont(ofSize: 2), containerFrame: .zero, alignment: .left, lineBreakMode: .byTruncatingTail)
        let material = SimpleMaterial(color: .white, isMetallic: false)
        
        let textEntity = ModelEntity(mesh: mesh, materials: [material])
        textEntity.scale = SIMD3<Float>(0.03, 0.03, 0.1) // To make the text bigger
        
        return textEntity
    }
}
