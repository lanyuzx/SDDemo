//
//  ViewController.swift
//  SDAlterSheet
//
//  Created by lanlan on 2021/7/12.
//

import UIKit

class SDAlterVC: SDBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let normalButton = UIButton()
        normalButton.setTitle("常规action", for: .normal)
        normalButton.setTitleColor(.red, for: .normal)
        normalButton.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        normalButton.addTarget(self, action: #selector(normalActon), for: .touchUpInside)
        view.addSubview(normalButton)
        normalButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(150)
            make.centerX.equalToSuperview()
        }
        
        let specialButton = UIButton()
        specialButton.setTitle("特殊action", for: .normal)
        specialButton.setTitleColor(.red, for: .normal)
        specialButton.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        specialButton.addTarget(self, action: #selector(specialAction), for: .touchUpInside)
        view.addSubview(specialButton)
        specialButton.snp.makeConstraints { (make) in
            make.top.equalTo(normalButton.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        
        let alterButton = UIButton()
        alterButton.setTitle("弹框弹出一个View", for: .normal)
        alterButton.setTitleColor(.red, for: .normal)
        alterButton.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        alterButton.addTarget(self, action: #selector(alterButtonClick), for: .touchUpInside)
        view.addSubview(alterButton)
        alterButton.snp.makeConstraints { (make) in
            make.top.equalTo(specialButton.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        
        let alterActionButton = UIButton()
        alterActionButton.setTitle("从右边弹框弹出一个View", for: .normal)
        alterActionButton.setTitleColor(.red, for: .normal)
        alterActionButton.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        alterActionButton.addTarget(self, action: #selector(alterActionButtonClick), for: .touchUpInside)
        view.addSubview(alterActionButton)
        alterActionButton.snp.makeConstraints { (make) in
            make.top.equalTo(alterButton.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
    }
    

    @objc private func normalActon() {
        SDActionSheetView.show(actions: ["分享","编辑","删除"]) { (index) in
            print("常规选择  选中的索引\(index)")
        }
    }
    
    
    @objc private func specialAction() {
        
        let titles = ["国画","播音","理财","原画","周易","其他"]
        var dataSoure = [String:Any]()
        titles.forEach { (item) in
            let titles = ["国画技法","名家分享","名画介绍","国画周边（工具、书法、陶瓷）","学院快讯","其他"]
            dataSoure[item] = titles
            dataSoure["seleted"] = "国画周边（工具、书法、陶瓷）"
        }
        SDSpecialActionSheetView.show(title: "分类", titles: titles, dataSource: dataSoure,lastChooseIndex: 1) { (index, item, skuIndex) in
            print("特殊选择  选中的索引\(index) 选中的内容====\(item) 选中对应的SKU索引\(skuIndex)")
        }
    }
    
    @objc private func alterButtonClick() {
        
        let view = UIView()
        view.backgroundColor = .red
       let alterVc = SDCustomAlertController.alertController(withCustomAlertView: view, preferredStyle: .alert, animationType: .shrink, panGestureDismissal: true)
        alterVc.updateCustomViewSize(size: CGSize(width: 200, height: 200))
        UIApplication.shared.keyWindow?.rootViewController?.present(alterVc, animated: true, completion: nil)
        
    }
    
    @objc private func alterActionButtonClick() {
        
        let tableView = UITableView(frame: .zero, style: .plain)
        let alterVc = SDCustomAlertController.alertController(withCustomAlertView: tableView, preferredStyle: .actionSheet, animationType: .fromRight, panGestureDismissal: true)
        alterVc.updateCustomViewSize(size: CGSize(width: 200, height: UIScreen.main.bounds.self.height))
         UIApplication.shared.keyWindow?.rootViewController?.present(alterVc, animated: true, completion: nil)
    }
   
}

