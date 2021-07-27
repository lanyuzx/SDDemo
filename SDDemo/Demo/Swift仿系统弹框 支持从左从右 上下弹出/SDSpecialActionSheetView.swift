//
//  SDSpecialActionSheetView.swift
//  SDAlterSheet
//
//  Created by lanlan on 2021/7/12.
//

import UIKit
typealias SpecialActionSheetCallBack = (_ index:Int,_ item:String,_ skuIndex:Int) -> Void
class SDSpecialActionSheetView: UIView {
    
    private var title:String?
    
    private var callBack:SpecialActionSheetCallBack?
    
    private weak var  alterVc:SDCustomAlertController?
    
    private  var dataSource:[SDSpecialActionSheetModel] = []
    
    private init(title:String?,lastChooseIndex:Int,titles:[String],dataSource:[String:Any],callBack:SpecialActionSheetCallBack) {
        super.init(frame: .zero)
        self.title = title
        backgroundColor = .white
        setupUI()
        setupData(lastChooseIndex: lastChooseIndex, titles: titles, dataSource: dataSource)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupData(lastChooseIndex:Int,titles:[String],dataSource:[String:Any]) {
        titles.forEach { (item) in
            let model = SDSpecialActionSheetModel()
            model.title = item
            let items = dataSource[item] as? [String]
            let seleted = dataSource["seleted"] as? String
            var itemList = [SDSpecialActionSheetItemModel]()
            items?.forEach({ (item) in
                let itemModel = SDSpecialActionSheetItemModel()
                itemModel.title = item
                if item == seleted {
                    itemModel.isSeleted = true
                }
                itemList.append(itemModel)
            })
            model.items = itemList
            self.dataSource.append(model)
        }
        segmentDataSource.titles = titles
        segmentView.reloadData()
        DispatchQueue.main.async {
            self.segmentView.selectItemAt(index: lastChooseIndex)
        }
    }
    
    private func setupUI() {
        addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(56)
        }
        
        addSubview(segmentView)
        segmentView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(topView.snp.bottom).offset(5)
            make.height.equalTo(40)
        }
        
        let lineView = UIView()
        lineView.backgroundColor = .extColorWithHex("#F3F3F3")
        addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(segmentView.snp.bottom)
            make.height.equalTo(1)
        }
        
        addSubview(listContainerView)
        listContainerView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(lineView.snp.bottom)
        }
    }
    
    @objc private func makeSureButtonClick() {
        var itemModel:SDSpecialActionSheetItemModel?
        var filterIndex:Int = 0
        
        for item in dataSource {
            for (index,filterItem) in (item.items ?? []).enumerated() {
                if filterItem.isSeleted == true {
                    filterIndex = index
                    itemModel = filterItem
                    break
                }
            }
            if itemModel?.isSeleted == true {
                break
            }
        }
        if itemModel == nil {
            return
        }
        if let callBack = self.callBack {
            alterVc?.dismiss(animated: true, completion: {
                callBack(filterIndex, itemModel?.title ?? "", self.segmentView.selectedIndex)
            })
           
        }
    }
    
    @objc private func canleButtonClick() {
        alterVc?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - 懒加载
    private lazy var segmentView:JXSegmentedView =  {
        let segmentView = JXSegmentedView()
        segmentView.dataSource = segmentDataSource
        segmentView.delegate = self
        segmentView.listContainer = listContainerView
        //配置指示器
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = 16
        indicator.indicatorHeight = 3
        indicator.indicatorColor = .extColorWithHex("#FD8B28")
        indicator.verticalOffset = 0
        segmentView.indicators = [indicator]
        return segmentView
    }()
    
    private lazy var segmentDataSource:JXSegmentedTitleDataSource = {
        let segmentDataSource = JXSegmentedTitleDataSource()
        segmentDataSource.itemWidthIncrement = 8
        //            segmentDataSource.isTitleColorGradientEnabled = true
        segmentDataSource.isItemSpacingAverageEnabled = false
        segmentDataSource.titleSelectedColor = UIColor.extColorWithHex("#000000")
        segmentDataSource.titleNormalColor = UIColor.extColorWithHex("#666666")
        segmentDataSource.titleNormalFont =  UIFont.systemFont(ofSize: 16, weight: .regular)
        segmentDataSource.titleSelectedFont =  UIFont.systemFont(ofSize: 16, weight: .medium)
        return segmentDataSource
    }()
    
    private lazy var listContainerView: JXSegmentedListContainerView! = {
        return JXSegmentedListContainerView(dataSource: self)
    }()
    
    private lazy var titleLable:UILabel = {
        let titleLable = UILabel()
        titleLable.text = self.title
        titleLable.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        titleLable.textColor = .extColorWithHex("#333333")
        return titleLable
    }()
    
    private lazy var topView:UIView = {
        let view = UIView()
        let canleButton = UIButton()
        canleButton.setTitle("取消", for: .normal)
        canleButton.setTitleColor(.extColorWithHex("#333333"), for: .normal)
        canleButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        canleButton.addTarget(self, action: #selector(canleButtonClick), for: .touchUpInside)
        view.addSubview(canleButton)
        canleButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        
        let makeSureButton = UIButton()
        makeSureButton.addTarget(self, action: #selector(makeSureButtonClick), for: .touchUpInside)
        makeSureButton.setTitle("确定", for: .normal)
        makeSureButton.setTitleColor(.extColorWithHex("#333333"), for: .normal)
        makeSureButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        view.addSubview(makeSureButton)
        makeSureButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
        
        view.addSubview(titleLable)
        titleLable.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        return view
    }()
}

extension SDSpecialActionSheetView {
    
    public class func  show(title:String? ,titles:[String],dataSource:[String :Any],lastChooseIndex:Int,callBack:@escaping SpecialActionSheetCallBack) {
        let actionView = SDSpecialActionSheetView(title: title, lastChooseIndex: lastChooseIndex, titles: titles, dataSource: dataSource, callBack: callBack)
        actionView.callBack = callBack
        let alterVc = SDCustomAlertController.alertController(withCustomAlertView: actionView, preferredStyle: .actionSheet, animationType: .fromBottom, panGestureDismissal: true)
        actionView.alterVc = alterVc
        alterVc.cornerRadius = 10
        alterVc.updateCustomViewSize(size: CGSize(width: UIScreen.main.bounds.size.width, height: 343))
        UIApplication.shared.keyWindow?.rootViewController?.present(alterVc, animated: true, completion: nil)
    }
}

extension SDSpecialActionSheetView :JXSegmentedViewDelegate,JXSegmentedListContainerViewDataSource {
    
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        
        return dataSource.count
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        //skuId 目前固定值: 2:理财、12:心理、15:国画、16播音、17日语
        let vc = SDSpecialActionSheetContentView()
        vc.items = dataSource[index].items
        vc.dataSource = self.dataSource
        return vc
    }
}


fileprivate class SDSpecialActionSheetModel {
    var title:String?
    var items:[SDSpecialActionSheetItemModel]?
}

fileprivate class SDSpecialActionSheetItemModel {
    var title:String?
    
    var isSeleted:Bool?
}


fileprivate class SDSpecialActionSheetContentView: UIView   {
    
    fileprivate var items:[SDSpecialActionSheetItemModel]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    fileprivate var dataSource:[SDSpecialActionSheetModel]?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func listWillAppear() {
        collectionView.reloadData()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = SDSpecialActionSheetCollectionViewFlowLayout()
        layout.delegate = self
        layout.rowHeight = 32
        layout.sectionInset = UIEdgeInsets(top: 16, left: 15, bottom: 16, right: 15)
        layout.minimumLineSpacing = 18
        layout.minimumInteritemSpacing = 12
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        //设置 collectionView 内容边距的底部高度为50 为了给购买数量留下位置
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SDSpecialActionSheetCollctionCell.self, forCellWithReuseIdentifier: "SDSpecialActionSheetCollctionCell")
        collectionView.backgroundColor = .white
        //        if collectionView.collectionViewLayout.responds(to: Selector.init(("_setRowAlignmentsOptions:"))) {
        //            collectionView.collectionViewLayout.perform(Selector.init(("_setRowAlignmentsOptions:")),with:NSDictionary.init(dictionary:["UIFlowLayoutCommonRowHorizontalAlignmentKey":NSNumber.init(value:NSTextAlignment.left.rawValue)]))
        //        }
        
        return collectionView
    }()
    
}

extension SDSpecialActionSheetContentView : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,SDSpecialActionSheetCollectionViewFlowLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SDSpecialActionSheetCollctionCell", for: indexPath) as! SDSpecialActionSheetCollctionCell
        cell.model = items?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let title = items?[indexPath.row].title {
            let titleWidth = (title as NSString).size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .regular)]).width
            return CGSize(width: titleWidth + 24, height: 32)
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //重置所有的选中状态
        dataSource?.forEach({ (item) in
            item.items?.forEach({ (item) in
                item.isSeleted = false
            })
        })
        //标识当前的选中状态
        items?[indexPath.row].isSeleted = true
        collectionView.reloadData()
    }
    
    func waterFlowLayout(layout: SDSpecialActionSheetCollectionViewFlowLayout, withAt indexPath: IndexPath) -> CGFloat {
        if let title = items?[indexPath.row].title {
            let titleWidth = (title as NSString).size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .regular)]).width
            return titleWidth + 24
        }
        return 0
    }
    
    func waterContentSizeHeight(height: CGFloat) {
        
    }
}

extension SDSpecialActionSheetContentView : JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self
    }
}


fileprivate class SDSpecialActionSheetCollctionCell: UICollectionViewCell {
    
    var model:SDSpecialActionSheetItemModel? {
        didSet {
            titleLable.text = model?.title
            if model?.isSeleted == true {
                contentView.backgroundColor = .extColorWithHex("#FFFAF6")
                contentView.layer.borderWidth = 0.5
                contentView.layer.borderColor = UIColor.extColorWithHex("#FF7C0B").cgColor
                titleLable.textColor = .extColorWithHex("#FF6A0B")
            }else {
                contentView.layer.borderWidth = 0
                contentView.layer.borderColor = UIColor.white.cgColor
                contentView.backgroundColor = .extColorWithHex("#F8F8F8")
                titleLable.textColor = .extColorWithHex("#333333")
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 16
        contentView.addSubview(titleLable)
        titleLable.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var titleLable:UILabel = {
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        lable.textAlignment = .center
        return lable
    }()
    
}



fileprivate protocol SDSpecialActionSheetCollectionViewFlowLayoutDelegate: NSObjectProtocol {
    /**通过代理获得每个cell的宽度*/
    func waterFlowLayout(layout: SDSpecialActionSheetCollectionViewFlowLayout, withAt indexPath: IndexPath) -> CGFloat
    //    /**获取加载的content的高度*/
    func waterContentSizeHeight(height: CGFloat)
}

fileprivate class SDSpecialActionSheetCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    weak var delegate: SDSpecialActionSheetCollectionViewFlowLayoutDelegate?
    var rowHeight: CGFloat = 0 ///< 固定行高
    
    //    private var margin: CGFloat = 0
    
    
    private var originxArray: [CGFloat] = []
    private var originyArray: [CGFloat] = []
    
    // 解决高度变小时高度不变的问题
    override func invalidateLayout() {
        super.invalidateLayout()
        self.originxArray = []
        self.originyArray = []
    }
    
    //#pragma mark - 重写父类的方法，实现瀑布流布局
    //#pragma mark - 当尺寸有所变化时，重新刷新
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func prepare() {
        super.prepare()
    }
    
    //#pragma mark - 处理所有的Item的layoutAttributes
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if let array = super.layoutAttributesForElements(in: rect) {
            var mutArray: [UICollectionViewLayoutAttributes] = []
            for item in array {
                let theAttri = self.layoutAttributesForItem(at: item.indexPath)!
                mutArray.append(theAttri)
            }
            return mutArray
        }
        return nil
    }
    
    //#pragma mark - 处理单个的Item的layoutAttributes
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let superAttributes = super.layoutAttributesForItem(at: indexPath)
        let rowHeight = superAttributes?.size.height ?? 0
        var x = self.sectionInset.left
        var y = self.sectionInset.top
        // 判断获得前一个cell的x和y
        let preRow = indexPath.row - 1
        if preRow >= 0 {
            if originyArray.count > preRow {
                x = originxArray[preRow]
                y = originyArray[preRow]
            }
            let preIndexPath = IndexPath.init(item: preRow, section: indexPath.section)
            let preWidth = self.delegate?.waterFlowLayout(layout: self, withAt: preIndexPath) ?? 0
            x += preWidth + self.minimumInteritemSpacing
        }
        var currentWidth = self.delegate?.waterFlowLayout(layout: self, withAt: indexPath)
        // 保证一个cell不超过最大宽度
        currentWidth = min((currentWidth ?? 0),(self.collectionView?.frame.width ?? 0) - self.sectionInset.left - self.sectionInset.right)
        if ((x + (currentWidth ?? 0)) > (self.collectionView?.frame.size.width ?? 0) - self.sectionInset.right)
        {
            // 超出范围，换行
            x = self.sectionInset.left
            y += rowHeight + self.minimumLineSpacing
        }
        // 创建属性
        let attrs: UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
        attrs.frame = CGRect(x: x, y: y, width: currentWidth ?? 0, height: rowHeight)
        originxArray.insert(x, at: indexPath.row)
        originyArray.insert(y, at: indexPath.row)
        return attrs
    }
    
    var maxY = 0
    override var collectionViewContentSize: CGSize {
        
        let width = self.collectionView?.frame.size.width
        var maxY : CGFloat = 0
        originyArray.forEach { (number) in
            if number > maxY {
                maxY = number
            }
        }
        let contentHeigh = maxY + rowHeight + self.sectionInset.bottom
        self.delegate?.waterContentSizeHeight(height: contentHeigh)
        return CGSize(width: width ?? 0, height: contentHeigh)
    }
}
