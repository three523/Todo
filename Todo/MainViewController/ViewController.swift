//
//  ViewController.swift
//  Todo
//
//  Created by 김도현 on 2023/07/31.
//

import UIKit

final class ViewController: UIViewController {

    @IBOutlet weak var todoListButton: UIButton!
    @IBOutlet weak var doneListButton: UIButton!
    @IBOutlet weak var mainImageView: UIImageView!
    
    override func loadView() {
        super.loadView()
        guard let url = URL(string: "https://spartacodingclub.kr/css/images/scc-og.jpg") else { return }
        
        let urlSesstion = URLSession.shared
        urlSesstion.dataTask(with: url) { data, _, error in
            guard let data,
                   error == nil else {
                print(error!.localizedDescription)
                return
            }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self.mainImageView.image = image
            }
        }.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ViewController {
    
}

