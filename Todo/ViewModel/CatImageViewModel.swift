//
//  CatImageViewModel.swift
//  Todo
//
//  Created by 김도현 on 2023/09/21.
//

import Foundation
import UIKit

struct ImageInfo {
    let imageData: Data
    let width: CGFloat
    let heght: CGFloat
}

struct CatImageViewModel {
    private let apiHandler = APIHandler()
    private let imageLoder = ImageLoader()
    
    func imageLoad(completion: @escaping (Result<ImageInfo, NetworkError>) -> Void) {
        apiHandler.getJson(type: [CatImage].self, stringUrl: "https://api.thecatapi.com/v1/images/search?") { result in
            switch result {
            case .success(let catImages):
                guard let catImage = catImages.first else { return }
                let screenSize = UIScreen.main.bounds
                let imageWidth = catImage.width > screenSize.width ? screenSize.width : catImage.width
                let imageHeight = catImage.height > screenSize.height ? screenSize.height : catImage.height
                self.apiHandler.getImage(stringUrl: catImage.url) { result in
                    switch result {
                    case .success(let data):
                        let imageInfo = ImageInfo(imageData: data, width: imageWidth, heght: imageHeight)
                        completion(.success(imageInfo))
                    case .failure(let apiError):
                        completion(.failure(apiError))
                    }
                }
            case .failure(let apiError):
                completion(.failure(apiError))
            }
        }
    }
}
