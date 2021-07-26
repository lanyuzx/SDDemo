//
//  MallSpuModel.swift
//  lanlan
//
//  Created by lanlan on 2021/6/15.
//  Copyright © 2021 lanlan. All rights reserved.
//

import UIKit
import HandyJSON


protocol MallChildProductListVCDelegate : NSObjectProtocol {
    
    func mallProductChildVC(childVC:MallChildProductListVC, scrollViewDidScroll secondCategoryModel:MallCategorySecondModel?)
}

class MallChildProductListVC: UIViewController  {
    
    var secondCategoryId:String? {
        didSet {
            //            setupData()
            var secondSectionIndex = 0
            var secondCategoryProduct:MallCategorySecondModel?
            for (index,item) in  (secondCategoryProductList ?? []).enumerated() {
                if item.secondCategoryId == secondCategoryId {
                    secondSectionIndex = index
                    secondCategoryProduct = item
                    break
                }
            }
            if  (secondCategoryProduct?.products?.count ?? 0) > 0  {
                if tableView.contentSize.height > 0 {
                    tableView.scrollToRow(at: IndexPath(item: 0, section: secondSectionIndex), at: .top, animated: true)
                }
            }
        }
    }
    
    /// 所有产品二级集合的产品
    var secondCategoryProductList:[MallCategorySecondModel]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    weak var delegate:MallChildProductListVCDelegate?
    
    private var productList:[MallProductModel]?
    ///是否加载多规格成功
    private var isLoadProductSpecsDetailsSuccess = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initWidget()
        addConstraints()
    }
    
    private func initWidget() {
        
        view.addSubview(tableView)
    }
    
    private func addConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private lazy var tableView:UITableView = {
        let leftTableView = UITableView(frame: .zero, style: .grouped)
        leftTableView.delegate = self
        leftTableView.dataSource = self
        leftTableView.register(MallChildProductCell.self, forCellReuseIdentifier: MallChildProductCell.description())
        leftTableView.backgroundColor = .white
        leftTableView.showsVerticalScrollIndicator = false
        leftTableView.showsHorizontalScrollIndicator = false
        leftTableView.separatorStyle = .none
        return leftTableView
    }()
}


extension MallChildProductListVC : UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return secondCategoryProductList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return secondCategoryProductList?[section].products?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MallChildProductCell.description()) as! MallChildProductCell
        cell.model = secondCategoryProductList?[indexPath.section].products?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 124
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        ///防止点击也会触发,乱跳问题
        if !scrollView.isDragging {
            return
        }
        let visbleIndexPath = tableView.indexPathsForVisibleRows?.first
        if let visbleIndexPath = visbleIndexPath {
            delegate?.mallProductChildVC(childVC: self, scrollViewDidScroll: secondCategoryProductList?[visbleIndexPath.section])
        }
    }
}

