//
//  MallSpuModel.swift
//  lanlan
//
//  Created by lanlan on 2021/6/15.
//  Copyright © 2021 lanlan. All rights reserved.
//

import UIKit
import HandyJSON

class MallCategoryModel: HandyJSON {
    
    var firstShowName: String?
    
    var firstCategoryId: String?
    
    var isSeleted: Bool = false
    
    var secondCategory: [MallCategorySecondModel]?
    
    required init() {
        
    }
}

class MallCategorySecondModel: HandyJSON {
    
    var secondCategoryId: String?
    
    var secondShowName: String?

    var firstCategory : MallCategoryModel?
    ///该等级产品列表
    var products:[MallProductModel]?
    
    var isSeleted: Bool = false
    
    required init() {
        
    }
}


class   MallProductModel: HandyJSON {
    ///商品spu主键id
    var productSpuId: String?
    ///商品sku主键id
    var productSkuId: String?
    ///标题
    var title: String?
    ///副标题
    var subTitle: String?
    ///头图（逗号分隔多个）
    var headImg: String?
    ///详情图
    var descInfoImgs: String?
    ///spu与sku关联id
    var productId: String?
    ///0-下架，1-上架
    var publicStatus: String?
    ///市场价
    var marketPrice: String?
    ///最低售卖价
    var minSalePrice: String?
    ///最高售卖价
    var maxSalePrice: String?
    ///会员价
    var vipPrice: String?
    ///销量
    var saleCount: String?
    ///sku数量
    var productSkuNum: Int?
    ///缩略图
    var thumbnail: String?
    
    var salePrice : String?
    
    ///记录上次选中的商品规格
    var lastSeletedSkuId:String?
    
    required init() {
        
    }
}
