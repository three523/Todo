//
//  CatImageViewController.swift
//  Todo
//
//  Created by 김도현 on 2023/08/29.
//

import UIKit


class CatImageViewController: UIViewController {
    
    @IBOutlet weak var mainImageView: CatImageView!
    let apiHandler: APIHandler = APIHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageLoader()
        // Do any additional setup after loading the view.
    }
    @IBAction func randomButtonClick(_ sender: Any) {
        mainImageView.image = nil
        mainImageView.viewState = .loading
        imageLoader()
    }
    
    func imageLoader() {
        apiHandler.getJson(type: [CatImage].self, stringUrl: "https://api.thecatapi.com/v1/images/search?") { result in
            switch result {
            case .success(let catImages):
                guard let catImage = catImages.first else { return }
                DispatchQueue.main.async {
                    self.mainImageView.constraints.first { $0.firstAttribute == .height }?.isActive = false
                    self.mainImageView.constraints.first { $0.firstAttribute == .width }?.isActive = false
                    self.mainImageView.widthAnchor.constraint(equalToConstant: CGFloat(catImage.width)).isActive = true
                    self.mainImageView.heightAnchor.constraint(equalToConstant: CGFloat(catImage.height)).isActive = true
                    self.mainImageView.backgroundColor = .systemGray3
                }
                self.apiHandler.getImage(stringUrl: catImage.url) { result in
                    switch result {
                    case .success(let data):
                        let image = UIImage(data: data)
                        DispatchQueue.main.async {
                            self.mainImageView.image = image
                            self.mainImageView.viewState = .loaded
                        }
                    case .failure(let apiError):
                        switch apiError {
                        case .cancel:
                            self.mainImageView.viewState = .loading
                            print(apiError.message)
                        case .notConnectedToInternet:
                            self.mainImageView.viewState = .error(false)
                            print(apiError.message)
                        default:
                            self.mainImageView.viewState = .error(true)
                            print(apiError.message)
                        }
                    }
                }
            case .failure(let apiError):
                switch apiError {
                case .cancel:
                    self.mainImageView.viewState = .loading
                    print(apiError.message)
                case .notConnectedToInternet:
                    self.mainImageView.viewState = .error(false)
                    print(apiError.message)
                default:
                    self.mainImageView.viewState = .error(true)
                    print(apiError.message)
                }
            }
        }
    }
}
