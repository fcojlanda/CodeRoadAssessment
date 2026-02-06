import UIKit

final class ImageDownloader {
    static let shared = ImageDownloader()
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        
        if let cachedImage = cache.object(forKey: urlString as NSString) {
            completion(cachedImage)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data,
                  let image = UIImage(data: data),
                  error == nil else {
                completion(nil)
                return
            }
            
            self?.cache.setObject(image, forKey: urlString as NSString)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
    
}
