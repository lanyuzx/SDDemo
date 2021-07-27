//
//  SDActionSheetView.swift
//  SDAlterSheet
//
//  Created by lanlan on 2021/7/12.
//

import UIKit
import SnapKit

typealias ActionSheetCallBack = (_ index:Int) -> Void

class SDActionSheetView: UIView {

    private var actions:[String]?
    
    private var callBack:ActionSheetCallBack?
    
    private weak var  alterVc:SDCustomAlertController?
  
    private init(actions:[String],callBack:ActionSheetCallBack) {
        super.init(frame: .zero)
        self.actions = actions
        backgroundColor = .white
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(canleButton)
        canleButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-17)
            make.height.equalTo(50)
        }
        
        for (index,item) in (actions ?? []).enumerated() {
            let btn = UIButton()
            btn.tag = index
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            btn.setTitle(item, for: .normal)
            btn.setTitleColor(.extColorWithHex("#333333"), for: .normal)
            btn.addTarget(self, action: #selector(itemButtonClick), for: .touchUpInside)
            addSubview(btn)
            btn.snp.makeConstraints { (make) in
                make.left.right.equalToSuperview()
                make.top.equalTo(self).offset(45 * index + 17)
                make.height.equalTo(45)
            }
        }
    }
    
    @objc private func canleButtonClick() {
        alterVc?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func itemButtonClick(btn:UIButton) {
        if let callBack = self.callBack {
            alterVc?.dismiss(animated: true, completion: {
                callBack(btn.tag)
            })
        }
    }
    
    private lazy var canleButton:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .extColorWithHex("#F6F6F6")
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        btn.setTitle("取消", for: .normal)
        btn.setTitleColor(.extColorWithHex("#333333"), for: .normal)
        btn.layer.cornerRadius = 25
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(canleButtonClick), for: .touchUpInside)
        return btn
    }()
}

extension SDActionSheetView {
    public class func  show(actions:[String],callBack:@escaping ActionSheetCallBack) {
        let actionView = SDActionSheetView(actions: actions, callBack: callBack)
        actionView.callBack = callBack
        let alterVc = SDCustomAlertController.alertController(withCustomAlertView: actionView, preferredStyle: .actionSheet, animationType: .fromBottom, panGestureDismissal: true)
        actionView.alterVc = alterVc
        alterVc.cornerRadius = 20
        alterVc.updateCustomViewSize(size: CGSize(width: UIScreen.main.bounds.size.width, height: CGFloat(actions.count * 50 + 50 + 34)))
        UIApplication.shared.keyWindow?.rootViewController?.present(alterVc, animated: true, completion: nil)
    }
}
