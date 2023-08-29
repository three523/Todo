//
//  CatImageViewController.swift
//  Todo
//
//  Created by 김도현 on 2023/08/29.
//

import UIKit

class CatImageViewController: UIViewController {
    
    @IBOutlet weak var mainImageView: UIImageView!
    private var task: URLSessionDataTask! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageLoader()
        // Do any additional setup after loading the view.
    }
    @IBAction func randomButtonClick(_ sender: Any) {
        mainImageView.image = nil
        task.cancel()
        imageLoader()
    }
    
    func imageLoader() {
        guard let url = URL(string: "https://api.thecatapi.com/v1/images/search?size=small") else { return }
        task = URLSession.shared.dataTask(with: url) { data, responese, error in
            if let error {
                print(error.localizedDescription)
            } else {
                guard let data else { return }
                let decoder = JSONDecoder()
                do {
                    let catImage = try decoder.decode([CatImage].self, from: data)
                    print(catImage[0].width, catImage[0].height)
                    
                    DispatchQueue.main.async {
                        self.mainImageView.constraints.first { $0.firstAttribute == .height }?.isActive = false
                        self.mainImageView.constraints.first { $0.firstAttribute == .width }?.isActive = false
                        self.mainImageView.widthAnchor.constraint(equalToConstant: CGFloat(catImage[0].width)).isActive = true
                        self.mainImageView.heightAnchor.constraint(equalToConstant: CGFloat(catImage[0].height)).isActive = true
                        self.mainImageView.backgroundColor = .systemGray3
                    }
                    guard let url = URL(string: catImage[0].url) else { return }
                    URLSession.shared.dataTask(with: url) { [self] data, responese, error in
                        if let error {
                            print(error.localizedDescription)
                        } else {
                            guard let data else { return }
                            let image = UIImage(data: data)
                            DispatchQueue.main.async {
                                self.mainImageView.image = image
                            }
                        }
                    }.resume()
                } catch let DecodingError.dataCorrupted(context) {
                    print(context)
                    self.imageLoader()
                } catch let DecodingError.keyNotFound(key, context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.valueNotFound(value, context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.typeMismatch(type, context)  {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                }
            }
        }
        
        task.resume()
    }
    
    func downSample1(scale: CGFloat = UIScreen.main.scale, data: CFData, width: CGFloat, height: CGFloat) -> UIImage {
        let imageSourceOption = [kCGImageSourceShouldCache: false] as CFDictionary
        let imageSource = CGImageSourceCreateWithData(data, nil)!
        let maxPixel = max(width, height) * scale
        let downSampleOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxPixel
        ] as CFDictionary

        let downSampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downSampleOptions)!

        let newImage = UIImage(cgImage: downSampledImage)
        return newImage
    }
    
}

struct CatImage: Codable {
    let id: String
    let url: String
    let width: Int
    let height: Int
}

extension UIImage {
    func resize(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale

        let size = CGSize(width: newWidth, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { context in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        
        print("화면 배율: \(UIScreen.main.scale)")// 배수
        print("origin: \(self), resize: \(renderImage)")
        return renderImage
    }
}
