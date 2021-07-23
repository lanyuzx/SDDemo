//
//  MallSpuModel.swift
//  SDDailyStudyProject
//
//  Created by lanlan on 2021/6/15.
//  Copyright © 2021 sunland. All rights reserved.
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
    var products:[MallPorductModel]?
    
    var isSeleted: Bool = false
    
    required init() {
        
    }
}

class MallFirstCategoryModel: HandyJSON {
    
    var firstCategory: [MallCategoryModel]?
    
    required init() {
        
    }
}



class   MallPorductModel: HandyJSON {
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

// MARK: - 商品规格模型
struct MallPorductSpecsDetailsModel : HandyJSON {
    ///spuId
    var productSpuId :String?
    ///spu缩略图
    var thumbnail :String?
    ///划线价
    var marketPrice :String?
    ///最低售卖价
    var minSalePrice :String?
    ///最高售卖价
    var maxSalePrice :String?
    ///所有sku的库存和
    var totalStock :Int?
    ///规格集合
    var skuList :[MallPorductSpecsDetailsSkuListModel]?
}

// MARK: - 规格集合
class  MallPorductSpecsDetailsSkuListModel  :HandyJSON {
    ///规格名称
    var skuName :String?
    ///规格库存
    var skuStock :Int?
    ///缩略图
    var thumbnail :String?
    ///SKU ID
    var productSkuId :String?
    ///销售价
    var salePrice :String?
    ///市场价（划线价）
    var marketPrice :String?
    
    var isSeleted: Bool = false
    ///购买数量 默认为1 默认为1，最小为1，最大不可超过库存数量；
    var buyCount: Int = 1
    
    required init() {
        
    }
}
