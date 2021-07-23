//
//  SDSDCycleViewVC.swift
//  SDDemo
//
//  Created by lanlan on 2021/5/6.
//

import UIKit

class SDSDCycleViewVC: SDBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(defaultCycleView)
        defaultCycleView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.top.equalTo(view.safeAreaInsets.top).offset(108)
            make.height.equalTo(120)
        }
        
        view.addSubview(cardCycleView)
        cardCycleView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.top.equalTo(defaultCycleView.snp.bottom).offset(40)
            make.height.equalTo(150)
        }
    }
    
    private let images = ["h1","h2","h3","h4"]
    private let titles = ["h1111","h2222","h3333","h4444"]
    
    private lazy var defaultCycleView:SDCycleView = {
       let defaultCycleView = SDCycleView()
        defaultCycleView.delegate = self
        defaultCycleView.setImagesGroup(images.map{return UIImage(named: $0)},titlesGroup: titles)
        return defaultCycleView
    }()
    
    private lazy var cardCycleView:SDCycleView = {
       let cycleView = SDCycleView()
        cycleView.delegate = self
        cycleView.itemZoomScale = 1.2
        cycleView.itemSpacing = 30
        cycleView.setImagesGroup(images.map{return UIImage(named: $0)},titlesGroup: titles)
        cycleView.itemSize = CGSize(width: 250, height: 120)
        return cycleView
    }()
}

extension SDSDCycleViewVC: SDCycleViewProtocol {
    func cycleViewConfigureDefaultCellImage(_ cycleView: SDCycleView, imageView: UIImageView, image: UIImage?, index: Int) {
        imageView.image = UIImage(named: images[index])
    }
    
    func cycleViewConfigureDefaultCellText(_ cycleView: SDCycleView, titleLabel: UILabel, index: Int) {
        titleLabel.text = titles[index]
        titleLabel.textColor = .red
        titleLabel.textAlignment = .right
        titleLabel.font = UIFont.systemFont(ofSize: 16)
    }
}
