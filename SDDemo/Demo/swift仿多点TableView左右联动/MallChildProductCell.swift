//
//  MallChildProductCell.swift
//  SDDailyStudyProject
//
//  Created by lanlan on 2021/6/16.
//  Copyright © 2021 sunland. All rights reserved.
//

import UIKit
import HandyJSON
import Kingfisher

protocol MallChildProductCellDelegate :NSObjectProtocol {
    func mallChildProductCell(cell:MallChildProductCell ,addShopping porductModel:MallPorductModel?  )
}

class MallChildProductCell: UITableViewCell {
    
    weak var delegate: MallChildProductCellDelegate?
    
    var model:MallPorductModel? {
        didSet {
            productIV.kf.setImage(with: URL(string: model?.thumbnail ?? ""))
            titleLable.text = model?.title
            subTitleLable.text = model?.subTitle
            priceLable.text = model?.minSalePrice
            
            if model?.marketPrice == model?.minSalePrice || model?.marketPrice == model?.maxSalePrice {
                priceLineLable.isHidden = true
            }else {
                priceLineLable.isHidden = false
                if let marketPrice = model?.marketPrice {
                    let attribtStr = NSMutableAttributedString(string: "¥\(marketPrice)", attributes: [NSAttributedString.Key.strikethroughStyle : NSNumber.init(value: 1)])
                    priceLineLable.attributedText = attribtStr
                }
            }
        }
    }
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        contentView.addSubview(productIV)
        productIV.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(16)
            make.width.height.equalTo(92)
        }
        
        contentView.addSubview(titleLable)
        titleLable.snp.makeConstraints { (make) in
            make.left.equalTo(productIV.snp.right).offset(8)
            make.top.equalTo(productIV)
            make.right.equalToSuperview().offset(-15)
        }
        
        contentView.addSubview(subTitleLable)
        subTitleLable.snp.makeConstraints { (make) in
            make.left.equalTo(productIV.snp.right).offset(8)
            make.top.equalTo(titleLable.snp.bottom).offset(4)
            make.right.equalToSuperview().offset(-15)
        }
        
        
        contentView.addSubview(rmbLable)
        rmbLable.snp.makeConstraints { (make) in
            make.left.equalTo(productIV.snp.right).offset(8)
            make.bottom.equalTo(productIV).offset(-2)
        }
        
        contentView.addSubview(priceLable)
        priceLable.snp.makeConstraints { (make) in
            make.left.equalTo(productIV.snp.right).offset(14)
            make.bottom.equalTo(productIV)
        }
        
        contentView.addSubview(priceLineLable)
        priceLineLable.snp.makeConstraints { (make) in
            make.left.equalTo(priceLable.snp.right).offset(4)
            make.bottom.equalTo(priceLable).offset(-2)
        }
        
        contentView.addSubview(addButton)
        addButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(productIV)
            make.right.equalToSuperview().offset(-15)
            make.width.height.equalTo(20)
        }
        
    }
    
    private lazy var  productIV:UIImageView =  {
       let productIV = UIImageView()
        productIV.layer.cornerRadius = 5
        productIV.layer.masksToBounds = true
        return productIV
    }()
    
    private lazy var titleLable:UILabel = {
       let titleLable = UILabel()
        titleLable.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        titleLable.textColor = .extColorWithHex(SDColor.MallColor.Color_000000.rawValue)
        titleLable.numberOfLines = 2
        return titleLable
    }()
    
    private lazy var subTitleLable:UILabel = {
       let subTitleLable = UILabel()
        subTitleLable.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        subTitleLable.textColor = .extColorWithHex(SDColor.MallColor.Color_777777.rawValue)
        subTitleLable.numberOfLines = 2
        subTitleLable.numberOfLines = 1
        return subTitleLable
    }()
    
    private lazy var priceLable:UILabel = {
       let priceLable = UILabel()
        priceLable.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        priceLable.textColor = .extColorWithHex(SDColor.MallColor.Color_ED1F21.rawValue)
        return priceLable
    }()
    
    private lazy var priceLineLable:UILabel = {
       let priceLineLable = UILabel()
        priceLineLable.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        priceLineLable.textColor = .extColorWithHex(SDColor.MallColor.Color_999999.rawValue)
        return priceLineLable
    }()

    
    private lazy var rmbLable:UILabel = {
       let rmbLable = UILabel()
        rmbLable.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        rmbLable.textColor = .extColorWithHex(SDColor.MallColor.Color_ED1F21.rawValue)
        rmbLable.text = "¥"
        return rmbLable
    }()
    
    private lazy var addButton:UIButton = {
       let addButton = UIButton()
        addButton.backgroundColor = .extColorWithHex(SDColor.MallColor.Color_FD8B28.rawValue)
        addButton.setTitle("＋", for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        addButton.setTitleColor(.white, for: .normal)
        addButton.layer.cornerRadius = 10
        addButton.layer.masksToBounds = true
        addButton.addTarget(self, action: #selector(addButtonClick), for: .touchUpInside)
//        addButton.extSetEnlargeEdgeWithTop(15, left: 15, bottom: 15, right: 15)
        return addButton
    }()
}


extension MallChildProductCell {
    // MARK: - 添加购物车按钮点击事件
    @objc private func addButtonClick() {
        delegate?.mallChildProductCell(cell: self, addShopping: model)
    }
}
