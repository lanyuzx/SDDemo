//
//  SDCustomAlertController.swift
//  SDAlterSheet
//
//  Created by lanlan on 2021/7/12.
//

import UIKit

let SP_SCREEN_WIDTH: CGFloat = UIScreen.main.bounds.size.width
let SP_SCREEN_HEIGHT: CGFloat = UIScreen.main.bounds.size.height

public enum SDCustomAlertControllerStyle {
    case actionSheet
    case alert
}

public enum SDAlertAnimationType: Int {
    case `default`
    case fromBottom
    case fromTop
    case fromRight
    case fromLeft
    
    case shrink
    case expand
    case fade
    case none
}


public enum SDBackgroundViewAppearanceStyle {
    case translucent
    case blurDark
    case blurExtraLight
    case blurLight
}

//: NSObject
protocol SDCustomControllerDelegate {
    
}

extension SDCustomControllerDelegate {
    
    /// 将要present
    func willPresentAlertController(alertController: SDCustomAlertController) {
        
    }
    /// 已经present
    func didPresentAlertController(alertController: SDCustomAlertController) {
        
    }
    /// 将要dismiss
    func willDismissAlertController(alertController: SDCustomAlertController) {
        
    }
    /// 已经dismiss
    func didDismissAlertController(alertController: SDCustomAlertController) {
        
    }
}


public class SDCustomAlertController: UIViewController {
    
    /// Interactor class for pan gesture dismissal
    lazy var interactor = SDInteractiveTransition()
    /// 拖拽退出view,暂时只支持向下拖拽退出,.fromTop向上拖拽退出
    private var panGestureDismissal: Bool = true
    /// 自定义背景蒙版
    public var customOverlayView: UIView?
    
    private var _customAlertView: UIView?
   
    internal var customViewSize: CGSize = .zero
    private var dimmingKnockoutBackdropView: UIView?
    internal var alertControllerViewConstraints: [NSLayoutConstraint]?
    private var actionSequenceViewConstraints: [NSLayoutConstraint]?
    
    internal var preferredStyle: SDCustomAlertControllerStyle = .alert
    internal var delegate: SDCustomControllerDelegate?
    internal var animationType: SDAlertAnimationType = .default
    
    // 对话框的偏移量，y值为正向下偏移，为负向上偏移；x值为正向右偏移，为负向左偏移，
    //该属性只对SPAlertControllerStyleAlert样式有效,键盘的frame改变会自动偏移，如果手动设置偏移只会取手动设置的
    public var offsetForAlert: CGPoint = .zero {
        didSet{
//            isForceOffset = true
            makeViewOffsetWithAnimated(false)
        }
    }
    
    /// 是否单击背景退出对话框,默认为YES
    public var tapBackgroundViewDismiss: Bool = true
    /// 默认为 无毛玻璃效果,黑色透明(默认是0.5透明)
    internal var backgroundViewAppearanceStyle: SDBackgroundViewAppearanceStyle = .translucent
    public var backgroundViewAlpha: CGFloat = 0.5
    
    /* 距离屏幕边缘的最小间距
     * alert样式下该属性是指对话框四边与屏幕边缘之间的距离，此样式下默认值随设备变化，actionSheet样式下是指弹出边的对立边与屏幕之间的距离，比如如果从右边弹出，那么该属性指的就是对话框左边与屏幕之间的距离，此样式下默认值为70
     */
    public var minDistanceToEdges: CGFloat = 70 {
        didSet {
            if self.isViewLoaded == false {
                return
            }
            //            if let headerV = headerView {
            //                setupPreferredMaxLayoutWidthForLabel(headerV.titleLabel)
            //                setupPreferredMaxLayoutWidthForLabel(headerV.messageLabel)
            //            }
            
            if presentationController?.presentingViewController != nil {
                layoutAlertControllerView()
                //                headerView?.setNeedsUpdateConstraints()
                //                actionSequenceView?.setNeedsUpdateConstraints()
            }
        }
    }
    /// SPAlertControllerStyleAlert样式下默认6.0f，
    /// SPAlertControllerStyleActionSheet样式下默认13.0f，去除半径设置为0即可
    public var cornerRadius: CGFloat = 6.0 {
        didSet {
            _updateCornerRadius(cornerRadius: cornerRadius)
        }
    }
    
    func _updateCornerRadius(cornerRadius: CGFloat) {
        if preferredStyle == .alert {
            containerView.layer.cornerRadius = cornerRadius
            containerView.layer.masksToBounds = true
        } else {
            if cornerRadius > 0.0 {
                var corner = [UIRectCorner.topLeft, UIRectCorner.topRight]
                switch animationType {
                case .fromBottom:
                    corner = [.topLeft, .topRight]
                case .fromTop:
                    corner = [.bottomLeft, .bottomRight]
                case .fromLeft:
                    corner = [.topRight, .bottomRight]
                case .fromRight:
                    corner = [.topLeft, .bottomLeft]
                default:
                    break
                }
                
                if let maskLayer = containerView.layer.mask as? CAShapeLayer {
                    maskLayer.path = UIBezierPath.init(roundedRect: containerView.bounds, byRoundingCorners: UIRectCorner.init(corner), cornerRadii: CGSize.init(width: cornerRadius, height: cornerRadius)).cgPath
                    maskLayer.frame = containerView.bounds
                }
            } else {
                containerView.layer.mask = nil
            }
        }
    }
    
    /// 是否需要对话框拥有毛玻璃,默认为false
    public var needDialogBlur: Bool = false {
        
        didSet {
            updateDialogBlur(needDialogBlur: needDialogBlur)
        }
    }
    
    private func updateDialogBlur(needDialogBlur: Bool) {
        if needDialogBlur == true {
            containerView.backgroundColor = .clear
            if let dimmingdropView = NSClassFromString("_UIDimmingKnockoutBackdropView")?.alloc() as? UIView {
                //                DLog("_UIDimmingKnockoutBackdropView 有值")
                // 下面4行相当于self.dimmingKnockoutBackdropView = [self.dimmingKnockoutBackdropView performSelector:NSSelectorFromString(@"initWithStyle:") withObject:@(UIBlurEffectStyleLight)];
                let selector = NSSelectorFromString("initWithStyle:")
                dimmingdropView.perform(selector, with: UIBlurEffect.Style.light)
                dimmingdropView.frame = containerView.bounds
                dimmingdropView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                dimmingKnockoutBackdropView = dimmingdropView
                //
                if #available(iOS 13, *) {
                    dimmingKnockoutBackdropView?.backgroundColor = .tertiarySystemBackground
                } else {
                    dimmingKnockoutBackdropView?.backgroundColor = .white
                }
                self.containerView.insertSubview(dimmingKnockoutBackdropView!, at: 0)
            } else {
                // 这个else是防止假如_UIDimmingKnockoutBackdropView这个类不存在了的时候，做一个备案
                let blur = UIBlurEffect.init(style: UIBlurEffect.Style.extraLight)
                dimmingKnockoutBackdropView = UIVisualEffectView.init(effect: blur)
                dimmingKnockoutBackdropView!.frame = containerView.bounds
                dimmingKnockoutBackdropView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                self.containerView.insertSubview(dimmingKnockoutBackdropView!, at: 0)
            }
            
        } else {
            dimmingKnockoutBackdropView?.removeFromSuperview()
            dimmingKnockoutBackdropView = nil
            if _customAlertView != nil {
                containerView.backgroundColor = .clear
            } else {
                if #available(iOS 13, *) {
                    containerView.backgroundColor = .tertiarySystemBackground
                } else {
                    containerView.backgroundColor = .white
                }
            }
        }
    }

    private var _alertView: UIView?
    private var alertView: UIView? {
        if _alertView == nil {
            let alert = UIView()
            //alert.backgroundColor = .lightGray
            alert.frame = self.alertControllerView.bounds
            alert.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            if self.customAlertView == nil {
                _alertView = alert
                self.containerView.addSubview(alert)
            }
        }
        return _alertView
    }
    
    lazy var alertControllerView: UIView = {
        let alertC = UIView()
        // alertC.backgroundColor = .blue
        alertC.translatesAutoresizingMaskIntoConstraints = false
        return alertC
    }()
    
    var customAlertView: UIView? {
        // customAlertView有值但是没有父view
        if _customAlertView != nil && _customAlertView?.superview == nil {
            if customViewSize.equalTo(.zero) {
                // 获取_customAlertView的大小
                customViewSize = sizeForCustomView(_customAlertView!)
            }
            // 必须在在下面2行代码之前获取_customViewSize
            _customAlertView?.frame = alertControllerView.bounds
            _customAlertView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.containerView.addSubview(_customAlertView!)
        }
        return _customAlertView
    }
    
   private lazy var containerView: UIView = {
        let containerV = UIView()
        if #available(iOS 13, *) {
            containerV.backgroundColor = .tertiarySystemBackground
        } else {
            containerV.backgroundColor = .white
        }
        
        containerV.frame = self.alertControllerView.bounds
        containerV.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if preferredStyle == .alert {
            containerV.layer.cornerRadius = cornerRadius
            containerV.layer.masksToBounds = true
        } else {
            if cornerRadius > 0.0 {
                let maskLayer = CAShapeLayer.init()
                containerV.layer.mask = maskLayer
            }
        }
        alertControllerView.addSubview(containerV)
        return containerV
    }()
    
    
    deinit {
        self.transitioningDelegate = nil
        NotificationCenter.default.removeObserver(self)
    }
    // 先loadView(),后viewDidLoad()
    override public func loadView() {
        super.loadView()
        // 重新创建self.view，这样可以采用自己的一套布局，轻松改变控制器view的大小
        self.view = self.alertControllerView
        // self.view.backgroundColor = .blue
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        //        configureHeaderView()
        updateDialogBlur(needDialogBlur: self.needDialogBlur)
        if #available(iOS 11.0, *) {
            
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    override public func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layoutAlertControllerView()
        if preferredStyle == .actionSheet {
            _updateCornerRadius(cornerRadius: cornerRadius)
        }
    }
    
    
    func layoutAlertControllerViewForAlertStyle() {
        var alertControllerViewConstraints = [NSLayoutConstraint]()
        let topValue = minDistanceToEdges
        let bottomValue = minDistanceToEdges
        let maxWidth = min(SP_SCREEN_WIDTH, SP_SCREEN_HEIGHT)-minDistanceToEdges*2
        let maxHeight = SP_SCREEN_HEIGHT-topValue-bottomValue
        if self.customAlertView == nil {
            // 当屏幕旋转的时候，为了保持alert样式下的宽高不变，因此取MIN(SP_SCREEN_WIDTH, SP_SCREEN_HEIGHT)
            alertControllerViewConstraints.append(NSLayoutConstraint.init(item: alertControllerView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: maxWidth))
            
        } else {
            alertControllerViewConstraints.append(NSLayoutConstraint.init(item: alertControllerView, attribute: .width, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: maxWidth))
            // 如果宽度没有值，则会假定customAlertView水平方向能由子控件撑起
            if customViewSize.width > 0 {
                // 限制最大宽度，且能保证内部约束不报警告
                let customWidth = min(customViewSize.width, maxWidth)
                alertControllerViewConstraints.append(NSLayoutConstraint.init(item: alertControllerView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: customWidth))
            }
            // 如果高度没有值，则会假定customAlertView垂直方向能由子控件撑起
            if customViewSize.height > 0 {
                let customHeight = min(customViewSize.height, maxHeight)
                alertControllerViewConstraints.append(NSLayoutConstraint.init(item: alertControllerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: customHeight))
            }
        }
        let topConstraint = NSLayoutConstraint.init(item: alertControllerView, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: alertControllerView.superview, attribute: .top, multiplier: 1.0, constant: topValue)
        topConstraint.priority = UILayoutPriority.init(999.0)
        alertControllerViewConstraints.append(topConstraint)
        //这里优先级为999.0是为了小于垂直中心的优先级，如果含有文本输入框，键盘弹出后，特别是旋转到横屏后，对话框的空间比较小，这个时候优先偏移垂直中心，顶部优先级按理说应该会被忽略，但是由于子控件含有scrollView，所以该优先级仍然会被激活，子控件显示不全scrollView可以滑动。如果外界自定义了整个对话框，且自定义的view上含有文本输入框，子控件不含有scrollView，顶部间距会被忽略
        let bottomConstraint = NSLayoutConstraint.init(item: alertControllerView, attribute: .bottom, relatedBy: .lessThanOrEqual, toItem: alertControllerView.superview, attribute: .bottom, multiplier: 1.0, constant: -bottomValue)
        bottomConstraint.priority = UILayoutPriority.init(999.0)// 优先级跟顶部同理
        alertControllerViewConstraints.append(bottomConstraint)
        
        let centerXConstraints = NSLayoutConstraint.init(item: alertControllerView, attribute: .centerX, relatedBy: .equal, toItem: alertControllerView.superview, attribute: .centerX, multiplier: 1.0, constant: offsetForAlert.x)
        alertControllerViewConstraints.append(centerXConstraints)
        
        let constantY = (self.isBeingPresented && !self.isBeingDismissed)  ? 0 : offsetForAlert.y
        let centerYConstraints = NSLayoutConstraint.init(item: alertControllerView, attribute: .centerY, relatedBy: .equal, toItem: alertControllerView.superview, attribute: .centerY, multiplier: 1.0, constant: constantY)
        alertControllerViewConstraints.append(centerYConstraints)
        
        NSLayoutConstraint.activate(alertControllerViewConstraints)
        self.alertControllerViewConstraints = alertControllerViewConstraints
        
        //        DLog("alertControllerView=\(alertControllerView)")
    }
    
    func layoutAlertControllerViewForActionSheetStyle() {
        switch animationType {
        case .fromTop:
            layoutAlertControllerViewForAnimationTypeWithHV(hv: "H",
                                                            equalAttribute: .top,
                                                            notEqualAttribute: .bottom,
                                                            lessOrGreaterRelation: .lessThanOrEqual)
        case .fromBottom:
            layoutAlertControllerViewForAnimationTypeWithHV(hv: "H",
                                                            equalAttribute: .bottom,
                                                            notEqualAttribute: .top,
                                                            lessOrGreaterRelation: .greaterThanOrEqual)
        case .fromLeft, .fromRight:
            layoutAlertControllerViewForAnimationTypeWithHV(hv: "V",
                                                            equalAttribute: .left,
                                                            notEqualAttribute: .right,
                                                            lessOrGreaterRelation: .lessThanOrEqual)
        default:
            layoutAlertControllerViewForAnimationTypeWithHV(hv: "H",
                                                            equalAttribute: .bottom,
                                                            notEqualAttribute: .top,
                                                            lessOrGreaterRelation: .greaterThanOrEqual)
        }
    }
}

//MARK: - private method
extension SDCustomAlertController {
    
     fileprivate convenience init(
                              customAlertView: UIView?,
                              preferredStyle: SDCustomAlertControllerStyle,
                              animationType: SDAlertAnimationType,
                              panGestureDismissal: Bool) {
        
        self.init()
        //        self.mainTitle = title
        //        self.message = message
        self.preferredStyle = preferredStyle
        
        self.animationType = animationType
        // 如果是默认动画，preferredStyle为alert时动画默认为alpha，
        // preferredStyle为actionShee时动画默认为fromBottom
        if animationType == .default {
            if preferredStyle == .alert {
                self.animationType = .shrink
            } else {
                self.animationType = .fromBottom
            }
        }
        
        if preferredStyle == .alert {
            self.minDistanceToEdges = (min(SP_SCREEN_WIDTH, SP_SCREEN_HEIGHT)-275)/2
//            _actionAxis = .horizontal
        } else {
            self.minDistanceToEdges = 70
//            _actionAxis = .vertical
            self.cornerRadius = 13
        }
        self._customAlertView = customAlertView
        //        self._customHeaderView = customHeaderView
        //        self._customActionSequenceView = customActionSequenceView
        //
        //        self._componentView = componentView
        self.panGestureDismissal = panGestureDismissal
        
        let flag1 = (preferredStyle == .actionSheet && animationType == .fromRight)
        let flag2 = (preferredStyle == .actionSheet && animationType == .fromLeft)
        // Allow for dialog dismissal on dialog pan gesture
        if self.panGestureDismissal && !flag1 && !flag2{
            let panRecognizer = UIPanGestureRecognizer(target: interactor, action: #selector(SDInteractiveTransition.handlePan))
            panRecognizer.cancelsTouchesInView = false
            interactor.viewController = self
            alertControllerView.addGestureRecognizer(panRecognizer)
        }
        
        // 视图控制器定义它呈现视图控制器的过渡风格（默认为NO）
        self.providesPresentationContextTransitionStyle = true
        self.definesPresentationContext = true
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }
    
    func layoutAlertControllerViewForAnimationTypeWithHV(hv: String,
                                                         equalAttribute: NSLayoutConstraint.Attribute,
                                                         notEqualAttribute: NSLayoutConstraint.Attribute,
                                                         lessOrGreaterRelation relation: NSLayoutConstraint.Relation){
        
        var alertControllerViewConstraints = [NSLayoutConstraint]()
        if self.customAlertView == nil {
            let visualFormat = "\(hv):|-0-[alertControllerView]-0-|"
            //DLog(visualFormat)
            alertControllerViewConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: visualFormat, options: [], metrics: nil, views: ["alertControllerView": alertControllerView]))
        } else {
            let centerXorY = (hv == "H") ? NSLayoutConstraint.Attribute.centerX : NSLayoutConstraint.Attribute.centerY
            alertControllerViewConstraints.append(NSLayoutConstraint.init(item: alertControllerView, attribute: centerXorY, relatedBy: .equal, toItem: alertControllerView.superview, attribute: centerXorY, multiplier: 1.0, constant: 0))
            if customViewSize.width > 0 {
                // 如果宽度没有值，则会假定customAlertViewh水平方向能由子控件撑起
                var alertControllerViewWidth: CGFloat = 0
                if hv == "H" {
                    alertControllerViewWidth = min(customViewSize.width, SP_SCREEN_WIDTH)
                } else {
                    alertControllerViewWidth = min(customViewSize.width, SP_SCREEN_WIDTH-minDistanceToEdges)
                }
                alertControllerViewConstraints.append(NSLayoutConstraint.init(item: alertControllerView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: alertControllerViewWidth))
            }
            if (customViewSize.height > 0) {
                // 如果高度没有值，则会假定customAlertViewh垂直方向能由子控件撑起
                var alertControllerViewHeight: CGFloat = 0
                if hv == "H" {
                    alertControllerViewHeight = min(customViewSize.height, SP_SCREEN_HEIGHT-minDistanceToEdges)
                } else {
                    alertControllerViewHeight = min(customViewSize.height, SP_SCREEN_HEIGHT)
                }
                alertControllerViewConstraints.append(NSLayoutConstraint.init(item: alertControllerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: alertControllerViewHeight))
            }
        }
        
        alertControllerViewConstraints.append(NSLayoutConstraint.init(item: alertControllerView, attribute: equalAttribute, relatedBy: .equal, toItem: alertControllerView.superview, attribute: equalAttribute, multiplier: 1.0, constant: 0))
        let someSideConstraint = NSLayoutConstraint.init(item: alertControllerView, attribute: notEqualAttribute, relatedBy: relation, toItem: alertControllerView.superview, attribute: notEqualAttribute, multiplier: 1.0, constant: minDistanceToEdges)
        someSideConstraint.priority = UILayoutPriority.init(999.0)
        alertControllerViewConstraints.append(someSideConstraint)
        NSLayoutConstraint.activate(alertControllerViewConstraints)
        // 第二次和第三次 alertControllerView:frame = (0 667; 375 0)  UITransitionView: 0x7f8c4bf15620; frame = (0 0; 375 667);
        //        DLog(alertControllerView)
        self.alertControllerViewConstraints = alertControllerViewConstraints
    }
    
    internal func makeViewOffsetWithAnimated(_ animated: Bool) {
        if !self.isBeingPresented && !self.isBeingDismissed {
            layoutAlertControllerView()
            if animated {
                UIView.animate(withDuration: 0.25) {
                    self.view.superview?.layoutIfNeeded()
                }
            }
        }
    }
    
    private func sizeForCustomView(_ customView: UIView) -> CGSize{
        
        customView.layoutIfNeeded()
        let settingSize = customView.frame.size
        let fittingSize = customView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
        let width = max(settingSize.width, fittingSize.width)
        let height = max(settingSize.height, fittingSize.height)
        return CGSize.init(width:width , height: height)
    }
}

extension SDCustomAlertController{
    
    /// 创建控制器(自定义整个对话框)
    /// - Parameters:
    ///   - customAlertView: 整个对话框的自定义view
    ///   - preferredStyle: 对话框样式
    ///   - animationType: 动画类型
   public  class func alertController(withCustomAlertView customAlertView: UIView,
                               preferredStyle: SDCustomAlertControllerStyle,
                               animationType: SDAlertAnimationType,
                               panGestureDismissal: Bool = true)
           ->SDCustomAlertController {
            
        let alertVC = SDCustomAlertController.init( customAlertView: customAlertView, preferredStyle: preferredStyle, animationType: animationType, panGestureDismissal: panGestureDismissal)
        return alertVC
    }

    /// 设置alert样式下的偏移量,动画为NO则跟属性offsetForAlert等效
    public func setOffsetForAlert(_ offsetForAlert: CGPoint, animated: Bool) {
        self.offsetForAlert = offsetForAlert
//        self.isForceOffset = true
        self.makeViewOffsetWithAnimated(animated)
    }

    // 设置蒙层的外观样式,可通过alpha调整透明度
    public func setBackgroundViewAppearanceStyle(_ style: SDBackgroundViewAppearanceStyle, alpha: CGFloat) {
        backgroundViewAppearanceStyle = style
        backgroundViewAlpha = alpha
    }
    //更新自定义view的size，比如屏幕旋转，自定义view的大小发生了改变，可通过该方法更新size
    public func updateCustomViewSize(size: CGSize) {
        customViewSize = size
        layoutAlertControllerView()
    }
    
    // 对自己创建的alertControllerView布局，在这个方法里，self.view才有父视图，有父视图才能改变其约束
    public func layoutAlertControllerView() {
        if alertControllerView.superview == nil {
            return
        }
        
        if let arr = alertControllerViewConstraints {
            NSLayoutConstraint.deactivate(arr)
            alertControllerViewConstraints = nil
        }
        if preferredStyle == .alert {
            layoutAlertControllerViewForAlertStyle()
        } else {
            layoutAlertControllerViewForActionSheetStyle()
        }
    }
}


extension SDCustomAlertController: UIViewControllerTransitioningDelegate {
    
    // 2.如何弹出的动画
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return SDAlertAnimation.animationIsPresenting(isPresenting: true, interactor: self.interactor)
    }
    // 3.如何dismissed的动画
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        self.view.endEditing(true)
        return SDAlertAnimation.animationIsPresenting(isPresenting: false, interactor: self.interactor)
    }
    // 1.返回一个自定义的UIPresentationController
    // 控制控制器跳转的类,是iOS8新增的一个API，用来控制controller之间的跳转特效，
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return SDAlertPresentationController.init(customOverlay: customOverlayView, presentedViewController: presented, presenting: presenting)
        //return SPAlertPresentationController.init(presentedViewController: presented, presenting: presenting)
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}
