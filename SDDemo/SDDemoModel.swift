//
//  SDDemoModel.swift
//  SDDemo
//
//  Created by lanlan on 2021/4/25.
//

import UIKit

class SDDemoModel {
    
    var date: String?
    lazy var items:[SDDemoItemModel] = [SDDemoItemModel]()
    
}

struct SDDemoItemModel {
    
    var item:String?
    
    var vcName:String?
    
}
