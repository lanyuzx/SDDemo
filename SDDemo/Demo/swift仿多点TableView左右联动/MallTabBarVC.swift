//
//  MallTabBarVC.swift
//  SDDailyStudyProject
//
//  Created by lanlan on 2021/6/15.
//  Copyright © 2021 sunland. All rights reserved.
//

import UIKit
import HandyJSON


class MallTabBarVC: UIViewController {
    
    private var categoryList:[MallCategoryModel]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initWidget()
        addConstraints()
        initData()
    }

    private func initWidget() {
        
        view.backgroundColor = .extColorWithHex(SDColor.MallColor.Color_F6F7FA.rawValue)
        
        view.addSubview(leftBgView)
        view.addSubview(leftTableView)
        
        view.addSubview(productChildVc.view)
        
    }
    
    private func addConstraints() {
       
        
        leftBgView.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.width.equalTo(80)
            make.bottom.equalToSuperview()
        }
        
        leftTableView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(94)
        }
        
        productChildVc.view.snp.makeConstraints { (make) in
            make.left.equalTo(leftTableView.snp.right).offset(2)
            make.top.equalTo(leftTableView)
            make.bottom.equalTo(leftTableView.snp.bottom)
            make.right.equalToSuperview()
        }
    }
    
    private func initData() {
        //模拟异步加载数据
        DispatchQueue.global().async {
            if  let path = Bundle.main.path(forResource: "category", ofType: "json") {
                if let url = URL(string: path) {
                    if let data = try? Data.init(contentsOf: url) {
                        if let jsonDict = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)  {
//                            self.categoryList = JSONDeserializer<MallCategoryModel>.deserializeModelArrayFrom(json: <#T##String?#>)
                            DispatchQueue.main.async {
                                self.leftTableView.reloadData()
                            }
                        }
                    }
                   
                }
                
            }
            
        }
    }
    
    // MARK: - 根据二级id拼接所有商品列表
    private func setupSecondCategoryIdProductList() {
        
        var secondCategoryList = [MallCategorySecondModel]()
        let  group = DispatchGroup()
        
        categoryList?.forEach({ (item) in
            item.secondCategory?.forEach({ (secondCategoryItem) in
                
            })
        })
        
        group.notify(queue: DispatchQueue.main) {
            self.productChildVc.secondCategoryProductList = secondCategoryList
        }
    }
    
    lazy var  productChildVc:MallChildProductListVC  =  {
        let productChildVc = MallChildProductListVC()
        addChild(productChildVc)
        productChildVc.delegate = self
        return productChildVc
    }()
    
    
    
    lazy var leftTableView:UITableView = {
        let leftTableView = UITableView(frame: .zero, style: .plain)
        leftTableView.backgroundColor = .clear
        leftTableView.delegate = self
        leftTableView.dataSource = self
        leftTableView.register(MallSpuLeftCell.self, forCellReuseIdentifier: MallSpuLeftCell.description())
        leftTableView.showsVerticalScrollIndicator = false
        leftTableView.showsHorizontalScrollIndicator = false
        leftTableView.separatorStyle = .none
        leftTableView.clipsToBounds = false
        leftTableView.backgroundView = nil
        leftTableView.tableFooterView = UIView()
        leftTableView.isOpaque = false
        return leftTableView
    }()
    
    private lazy var leftBgView:UIView = {
        let leftBgView = UIView()
        leftBgView.backgroundColor = .extColorWithHex(SDColor.MallColor.Color_F6F7FA.rawValue)
        return leftBgView
    }()
    
    private lazy var emptyView: UIView = {
       let emptyView = UIView()
        emptyView.isHidden = true
        emptyView.backgroundColor = .white
        let emptyIV = UIImageView(image: UIImage(named: "icon_mall_empty"))
        emptyView.addSubview(emptyIV)
        emptyIV.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(163)
            make.centerX.equalToSuperview()
        }
        let label = UILabel()
        label.text = "商城建设中…"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .extColorWithHex(SDColor.MallColor.Color_999999.rawValue)
        emptyView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.top.equalTo(emptyIV.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        return emptyView
    }()
    
}

// MARK: - UITableViewDataSource/UITableViewDelegate
extension MallTabBarVC : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MallSpuLeftCell.description()) as! MallSpuLeftCell
        cell.delegate = self
        cell.model = categoryList?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = categoryList?[indexPath.row]
        if model?.isSeleted == true {
            let height = (49.0 * CGFloat(model?.secondCategory?.count ?? 0)) + 53
            return (model?.secondCategory?.count ?? 0) > 0 ? height : 0.001
        }
        return  53
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = categoryList?[indexPath.row]
        for item in categoryList  ?? [] {
            item.isSeleted = false
            item.secondCategory?.forEach({ (item) in
                item.isSeleted = false
            })
        }
        model?.isSeleted = true
        model?.secondCategory?.first?.isSeleted = true
        productChildVc.secondCategoryId = model?.secondCategory?.first?.secondCategoryId
        tableView.reloadData()
    }
    
}
// MARK: - 自定义代理
extension MallTabBarVC : MallSpuLeftCellDelegate, MallChildProductListVCDelegate{
    
    func mallSpuLeftCell(mallLeftCell: MallSpuLeftCell, didSelectCategorySecond secondModel: MallCategorySecondModel?) {
        productChildVc.secondCategoryId = secondModel?.secondCategoryId
    }
    
    func mallProductChildVC(childVC: MallChildProductListVC, scrollViewDidScroll secondCategoryModel: MallCategorySecondModel?) {
        var categoryIndex = 0
        //闭合所有未选中的
        for (index,item) in (categoryList ?? []).enumerated() {
            item.isSeleted = false
            item.secondCategory?.forEach({ (secondItemCategory) in
                secondItemCategory.isSeleted = false
            })
            if item.firstCategoryId ==  secondCategoryModel?.firstCategory?.firstCategoryId {
                categoryIndex = index
                item.isSeleted = true
            }
        }
        secondCategoryModel?.firstCategory?.isSeleted = true
        secondCategoryModel?.isSeleted = true
        self.leftTableView.reloadData()
        UIView.animate(withDuration: 0.0) {
            self.leftTableView.scrollToRow(at: IndexPath(item: categoryIndex, section: 0), at: .top, animated: false)
        }
    }
}




