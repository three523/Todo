//
//  ImageLoader.swift
//  Todo
//
//  Created by 김도현 on 2023/09/19.
//

import Foundation

class ImageLoader {
    func loadUrlImage(url: String, completion: @escaping (Data?)->Void) {
        guard let url = URL(string: url) else {
            completion(nil)
            return
        }
        
        let urlSesstion = URLSession.shared
        urlSesstion.dataTask(with: url) { data, _, error in
            guard let data,
                  error == nil else {
                print(error!.localizedDescription)
                completion(nil)
                return
            }
            DispatchQueue.main.async {
                completion(data)
            }
        }.resume()
    }
}
