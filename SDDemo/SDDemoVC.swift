//
//  ViewController.swift
//  SDDemo
//
//  Created by lanlan on 2021/4/25.
//

import UIKit
import SnapKit

class SDDemoVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Demo"
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private lazy var tableView:UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.description())
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: UITableViewHeaderFooterView.description())
        return tableView
    }()
    
    private lazy var dataSource:[SDDemoModel] = {
        let dataSource = loadData()
        return dataSource
    }()
}

extension SDDemoVC {
    private func loadData() ->[SDDemoModel] {
        var dataSource = [SDDemoModel]()
        /*
         2021年04月
         */
        let year2021_april = SDDemoModel()
        year2021_april.date = "2021年04月"
        for index in 0..<3 {
            switch index {
            case 0: //加载播放小动画
                var animiModel = SDDemoItemModel(item: "CAKeyframeAnimation播放小动画")
                animiModel.vcName = "SDPlayAnimationVC"
                year2021_april.items.append(animiModel)
                break
            case 1:
                var animiModel = SDDemoItemModel(item: "贝塞尔曲线上实现粒子动画")
                animiModel.vcName = "SDParticleAnimationsVC"
                year2021_april.items.append(animiModel)
                break
            case 2:
                var animiModel = SDDemoItemModel(item: "仿系统钟表")
                animiModel.vcName = "SDClockVC"
                year2021_april.items.append(animiModel)
                break
            default:
                break
            }
        }
        dataSource.append(year2021_april)
        let year2021_May = SDDemoModel()
        year2021_May.date = "2021年05月"
        for index in 0..<3 {
            switch index {
            case 0: //加载播放小动画
                var animiModel = SDDemoItemModel(item: "swift轮播图")
                animiModel.vcName = "SDSDCycleViewVC"
                year2021_May.items.append(animiModel)
                break
            case 1: //iOS仿QQ消息粘性视图
                var animiModel = SDDemoItemModel(item: "iOS仿QQ消息粘性视图")
                animiModel.vcName = "SDQQBageValueVC"
                year2021_May.items.append(animiModel)
                break
            case 2: //iOS仿QQ消息粘性视图
                var animiModel = SDDemoItemModel(item: "swift用协议包装键盘通知")
                animiModel.vcName = "SDKeyboardProtocolVC"
                year2021_May.items.append(animiModel)
                break
                
            default:
                break
            }
        }
        dataSource.append(year2021_May)
        return dataSource
        
    }
}

extension SDDemoVC :UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].items.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: UITableViewHeaderFooterView.description())
        headerView?.textLabel?.text = dataSource[section].date
        headerView?.textLabel?.textColor = .black
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.description())
        cell?.textLabel?.text = dataSource[indexPath.section].items[indexPath.row].item
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSource[indexPath.section].items[indexPath.row]
        if let vcName = model.vcName {
            if let viewController = NSClassFromString("SDDemo.\(vcName)") as? UIViewController.Type {
                let vc = viewController.init()
                vc.title = model.item
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

