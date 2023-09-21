//
//  ProfileDesignViewController.swift
//  Todo
//
//  Created by 김도현 on 2023/09/20.
//

import UIKit
import SnapKit

final class ProfileDesignViewController: UIViewController {
    
    private let naviBar: NavigationBar = NavigationBar()
    private let profileView = ProfileView()
    private let navGalleryView: NavGalleryView = NavGalleryView()
    private let postCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    private let margin: CGFloat = 14
    private let spacing: CGFloat = 10
    private let naviBarHeight: CGFloat = 44
    private let navGalleryHeight: CGFloat = 44
    private let itemSize = (UIScreen.main.bounds.size.width/3) - 2
    private let imageList: [UIImage?] = [UIImage(named: "nabaecamp1"), UIImage(named: "nabaecamp2"), UIImage(named: "nabaecamp3"), UIImage(named: "nabaecamp4"), UIImage(named: "nabaecamp5"), UIImage(named: "nabaecamp6"), UIImage(named: "nabaecamp7")]

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension ProfileDesignViewController {
    func setup() {
        viewSetup()
        navigationSetup()
        addViews()
        autoLayoutSetup()
        collectionViewSetup()
    }
    
    func viewSetup() {
        view.backgroundColor = .white
    }
    
    func navigationSetup() {
        let menuBarButton = UIBarButtonItem(image: UIImage(named: "Meun"), style: .done, target: self, action: #selector(menuButtonClick))
        navigationItem.rightBarButtonItem = menuBarButton
    }
    
    func addViews() {
        view.addSubview(naviBar)
        view.addSubview(profileView)
        view.addSubview(navGalleryView)
        view.addSubview(postCollectionView)
    }
    
    func autoLayoutSetup() {
        let safeArea = view.safeAreaLayoutGuide
        naviBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(safeArea)
            make.height.equalTo(44)
        }
        profileView.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom)
            make.leading.trailing.equalTo(safeArea).inset(margin)
        }
        navGalleryView.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).inset(-spacing)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(navGalleryHeight)
        }
        postCollectionView.snp.makeConstraints { make in
            make.top.equalTo(navGalleryView.snp.bottom)
            make.leading.trailing.bottom.equalTo(safeArea)
        }
    }
    
    func collectionViewSetup() {
        postCollectionView.delegate = self
        postCollectionView.dataSource = self
        postCollectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: PostCollectionViewCell.resuableIdentifier)
    }
    
    @objc
    func menuButtonClick() {
        navigationController?.popViewController(animated: true)
    }
}

extension ProfileDesignViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell.resuableIdentifier, for: indexPath) as? PostCollectionViewCell else { return UICollectionViewCell() }
        cell.imageView.image = imageList[indexPath.item]
        return cell
    }
    
    
}

extension ProfileDesignViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: itemSize, height: itemSize)
    }
}
