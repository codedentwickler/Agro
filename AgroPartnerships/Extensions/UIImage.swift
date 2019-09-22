import UIKit

extension UIImage {
    
    func getImageSizeCompressionRatio() -> Float {
        guard let imageData = jpegData(compressionQuality: 1) else {
            debugPrint("Could not get JPEG representation of UIImage")
            return 1.0
        }
        
        let sizeInKb = imageData.count / 1024
        AgroLogger.log(":IMAGE sizeInKb \(sizeInKb)")
        
        if sizeInKb > 8 * 1024 {
            return 0.3
        } else if sizeInKb > 6 * 1024 {
            return 0.3
        } else if sizeInKb > 4 * 1024 {
            return 0.4
        } else if sizeInKb > 2 * 1024 {
            return 0.5
        } else if sizeInKb > 1024 {
            return 0.8
        } else {
            return 1.0
        }
    }
}
