//
//  CatImageViewController.swift
//  Todo
//
//  Created by 김도현 on 2023/08/29.
//

import UIKit
import SnapKit

final class CatImageViewController: UIViewController {
    
    private let mainImageView: CatImageView = CatImageView(state: .loading)
    private let apiHandler: APIHandler = APIHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension CatImageViewController {
    func setup() {
        addViews()
        naviagationSetup()
        autoLayoutSetup()
        mainImageViewSetup()
        imageLoader()
    }
    func addViews() {
        view.addSubview(mainImageView)
    }
    func autoLayoutSetup() {
        mainImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.equalTo(240)
            make.width.equalTo(160)
        }
    }
    func naviagationSetup() {
        let randomBarButton = UIBarButtonItem(title: "랜덤", style: .done, target: self, action: #selector(randomButtonClick))
        navigationItem.rightBarButtonItem = randomBarButton
    }
    func mainImageViewSetup() {
        mainImageView.contentMode = .scaleAspectFill
    }
    @objc
    func randomButtonClick(_ sender: Any) {
        mainImageView.image = nil
        mainImageView.viewState = .loading
        imageLoader()
    }
}

private extension CatImageViewController {
    private func imageLoader() {
        apiHandler.getJson(type: [CatImage].self, stringUrl: "https://api.thecatapi.com/v1/images/search?") { result in
            switch result {
            case .success(let catImages):
                guard let catImage = catImages.first else { return }
                let screenSize = UIScreen.main.bounds
                DispatchQueue.main.async {
                    let imageWidth = catImage.width > screenSize.width ? screenSize.width : catImage.width
                    let imageHeight = catImage.height > screenSize.height ? screenSize.height : catImage.height
                    self.mainImageView.snp.updateConstraints { make in
                        make.width.equalTo(imageWidth)
                        make.height.equalTo(imageHeight)
                    }
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
