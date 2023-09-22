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
    private let defaultImageSize = CGSize(width: 240, height: 160)
    private let viewModel: CatImageViewModel = CatImageViewModel()
    
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
            make.height.equalTo(defaultImageSize.width)
            make.width.equalTo(defaultImageSize.height)
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
        viewModel.imageLoad { result in
            switch result {
            case .success(let imageInfo):
                DispatchQueue.main.async {
                    self.mainImageView.image = UIImage(data: imageInfo.imageData)
                    self.mainImageView.viewState = .loaded
                    self.mainImageView.snp.updateConstraints { make in
                        make.width.equalTo(imageInfo.width)
                        make.height.equalTo(imageInfo.heght)
                    }
                }
            case .failure(let error):
                switch error {
                case .cancel:
                    self.mainImageView.viewState = .loading
                    print(error.message)
                case .notConnectedToInternet:
                    self.mainImageView.viewState = .error(false)
                    print(error.message)
                default:
                    self.mainImageView.viewState = .error(true)
                    print(error.message)
                }
            }
        }
    }
}
