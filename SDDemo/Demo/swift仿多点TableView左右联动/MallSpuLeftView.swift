//
//  MallSpuLeftCell.swift
//  SDDailyStudyProject
//
//  Created by lanlan on 2021/6/15.
//  Copyright © 2021 sunland. All rights reserved.
//

import UIKit
import HandyJSON

protocol MallSpuLeftCellDelegate:NSObjectProtocol {
    
    func mallSpuLeftCell(mallLeftCell:MallSpuLeftCell, didSelectCategorySecond secondModel:MallCategorySecondModel? )
}

class MallSpuLeftCell: UITableViewCell {
    
    var model: MallCategoryModel? {
        didSet {
            spuLable.text = model?.firstShowName
            if model?.isSeleted == true && (model?.secondCategory?.count ?? 0) > 0 {
                spuLable.isHidden = true
                containerMaskView.isHidden = false
                tableView.isHidden = false
                tableView.reloadData()
            }else {
                spuLable.isHidden = false
                containerMaskView.isHidden = true
                tableView.isHidden = true
            }
        }
    }
    
    weak var delegate:MallSpuLeftCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        self.backgroundColor = .white
        contentView.backgroundColor = .white
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(spuLable)
        spuLable.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(80)
        }
        
        contentView.addSubview(containerMaskView)
        containerMaskView.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.width.equalTo(88)
            make.height.equalToSuperview()
        }
        
        containerMaskView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        DispatchQueue.main.async {
            if self.model?.isSeleted == true {
                self.containerMaskView.layer.insertSublayer(self.maskLayer, at: 0)
                self.tableView.extCorner(byRoundingCorners: [.topRight,.bottomRight], radii: 6)
            }
        }

    }
    
    private lazy var spuLable: UILabel = {
       let  spuLable = UILabel()
        spuLable.backgroundColor = .extColorWithHex("#F6F7FA")
        spuLable.textColor = .extColorWithHex(SDColor.MallColor.Color_666666.rawValue)
        spuLable.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        spuLable.textAlignment = .center
        spuLable.numberOfLines = 2
        return spuLable
    }()
    
    private lazy var containerMaskView:UIView = {
        let containerMaskView = UIView()
        containerMaskView.backgroundColor = UIColor.white
        return containerMaskView
    }()
    
    private lazy var tableView:UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .blue
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(MallSpuLeftItemCell.self, forCellReuseIdentifier: MallSpuLeftItemCell.description())
        tableView.register(MallSpuLeftSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: MallSpuLeftSectionHeaderView.description())
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    private lazy var maskLayer:CAShapeLayer = {
        let maskPath = UIBezierPath(roundedRect: self.containerMaskView.bounds, byRoundingCorners: [.bottomRight,.topRight], cornerRadii: CGSize(width: 6, height: 6))
        let maskLayer = CAShapeLayer()
        maskLayer.fillColor = UIColor.white.cgColor
        maskLayer.frame = self.containerMaskView.bounds
        maskLayer.path = maskPath.cgPath
        maskLayer.masksToBounds = false
        maskLayer.shadowColor = UIColor.extColorWithHex(SDColor.MallColor.Color_E5E8F1.rawValue).cgColor
        maskLayer.shadowOffset = CGSize(width: 0, height: 1)
        maskLayer.shadowOpacity = 1
        maskLayer.shadowRadius = 5
        return maskLayer
    }()
    
}

extension MallSpuLeftCell :UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.secondCategory?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: MallSpuLeftSectionHeaderView.description()) as? MallSpuLeftSectionHeaderView
        headerView?.tableView = tableView
        headerView?.model = model
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 53
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MallSpuLeftItemCell.description()) as! MallSpuLeftItemCell
        cell.model = model?.secondCategory?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 49
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        model?.secondCategory?.forEach({ (item) in
            item.isSeleted = false
        })
        let secondCategory = model?.secondCategory?[indexPath.row]
        secondCategory?.isSeleted = true
        self.delegate?.mallSpuLeftCell(mallLeftCell: self, didSelectCategorySecond: secondCategory)
        tableView.reloadData()
    }
}


fileprivate class MallSpuLeftItemCell: UITableViewCell {
    
    var model: MallCategorySecondModel? {
        didSet {
            spuLable.text = model?.secondShowName
            spuLable.isHighlighted = model?.isSeleted ?? false
            arrowLineView.isHidden = !(model?.isSeleted ?? false)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        contentView.addSubview(arrowLineView)
        arrowLineView.snp.makeConstraints { (make) in
            make.width.equalTo(4)
            make.left.top.bottom.equalToSuperview()
        }
        
        contentView.addSubview(spuLable)
        spuLable.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(4)
            make.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
    }
    
    private lazy var spuLable: UILabel = {
       let  spuLable = UILabel()
        spuLable.highlightedTextColor = .extColorWithHex(SDColor.MallColor.Color_FF4C38.rawValue)
        spuLable.textColor = .extColorWithHex(SDColor.MallColor.Color_666666.rawValue)
        spuLable.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        spuLable.textAlignment = .center
        spuLable.numberOfLines = 2
        return spuLable
    }()
    
    private lazy var arrowLineView:UIView = {
        let arrowLineView = UIView()
        arrowLineView.backgroundColor = .extColorWithHex(SDColor.MallColor.Color_FC8B28.rawValue)
        return arrowLineView
    }()
   
}


class MallSpuLeftSectionHeaderView: UITableViewHeaderFooterView {
    
    var model:MallCategoryModel? {
        didSet {
            spuLable.text = model?.firstShowName
            spuLable.font = (model?.isSeleted ?? false) ? UIFont.systemFont(ofSize: 14, weight: .medium) : UIFont.systemFont(ofSize: 14, weight: .regular)
            spuLable.isHighlighted = model?.isSeleted ?? false
            lineView.isHidden = !(model?.isSeleted ?? false)
        }
    }
    
    weak var tableView:UITableView?
    
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        containerView.addSubview(spuLable)
        spuLable.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        containerView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(mallSpuLeftHeaderViewClick))
//        containerView.addGestureRecognizer(tap)
    }
    
//    @objc private func mallSpuLeftHeaderViewClick() {
//        if model?.isSeleted == true {
//            model?.isSeleted = false
//            let vc = contentView.yy_viewController as? MallTabBarVC
//            vc?.leftTableView.reloadData()
//        }
//    }
    
    private lazy var containerView:UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        return containerView
    }()
    
    private lazy var spuLable: UILabel = {
       let  spuLable = UILabel()
        spuLable.textColor = .extColorWithHex(SDColor.MallColor.Color_222222.rawValue)
        spuLable.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        spuLable.textAlignment = .center
        spuLable.numberOfLines = 2
        return spuLable
    }()
    
    private lazy var lineView:UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .extColorWithHex(SDColor.MallColor.Color_F1F2F5.rawValue)
        return lineView
    }()

}
