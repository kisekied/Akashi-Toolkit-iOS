//
//  LSPageTabView.swift
//  akashiToolkit
//
//  Created by LarrySue on 2017/10/13.
//  Copyright © 2017年 kcwikizh. All rights reserved.
//

import UIKit

public enum LSPageTabViewType: Int {
    case stationary
    case scrollable
}

@objc protocol LSPageTabViewDataSource {
    func numberOfTab(in pageTabView: LSPageTabView) -> Int
    func pageTabView(_ pageTabView: LSPageTabView, childViewAt index: Int) -> UIView
    
    @objc optional func pageTabView(_ pageTabView: LSPageTabView, titleForTabAt index: Int) -> String
    @objc optional func pageTabView(_ pageTabView: LSPageTabView, attributedTitleForTabAt index: Int) -> NSAttributedString
    @objc optional func pageTabView(_ pageTabView: LSPageTabView, selectedTitleViewForTabAt index: Int) -> UIView
    @objc optional func pageTabView(_ pageTabView: LSPageTabView, unselectedTitleViewForTabAt index: Int) -> UIView
}

@objc protocol LSPageTabViewDelegate {
    @objc optional func pageTabViewDidScroll(_ pageTabView: LSPageTabView)
}

class LSPageTabView: UIView {
    
    // MARK: *** 属性 ***
    
    ///当前类型 固定/可滚动
    private var type: LSPageTabViewType = .stationary
    
    ///DataSource
    public var dataSource: LSPageTabViewDataSource? {
        didSet {
            if let tabCount = dataSource?.numberOfTab(in: self) {
                for i in 0 ..< tabCount {
                    let tabBtn = UIButton(type: .custom)
                    tabBtn.tag = i
                    tabBtn.addTarget(self, action: #selector(tapOnTabBtn), for: .touchUpInside)
                    tabs.append(tabBtn)
                    tabBar.addSubview(tabBtn)
                    
                    if let childView = dataSource?.pageTabView(self, childViewAt: i) {
                        childViews.append(childView)
                        mainScrollView.addSubview(childView)
                        if let selectedTitleView = dataSource?.pageTabView?(self, selectedTitleViewForTabAt: i) {
                            selectedTitleViews.append(selectedTitleView)
                            tabBtn.addSubview(selectedTitleView)
                            if let unselectedTitleView = dataSource?.pageTabView?(self, unselectedTitleViewForTabAt: i) {
                                selectedTitleView.isHidden = true
                                unselectedTitleViews.append(unselectedTitleView)
                                tabBtn.addSubview(unselectedTitleView)
                            }
                        } else {
                            let titleLbl = UILabel()
                            titleLbl.textAlignment = .center
                            titleLbl.font = UIFont.boldSystemFont(ofSize: 15.0)
                            if let  attributedTitle = dataSource?.pageTabView?(self, attributedTitleForTabAt: i) {
                                titleLbl.attributedText = attributedTitle
                            } else {
                                if let  title = dataSource?.pageTabView?(self, titleForTabAt: i) {
                                    titleLbl.text = title
                                } else {
                                    titleLbl.text = "\(i)"
                                }
                            }
                            titleViews.append(titleLbl)
                            tabBtn.addSubview(titleLbl)
                        }
                    }
                }
                tabBar.addSubview(slider)
            }
        }
    }
    ///Delegate
    public var delegate: LSPageTabViewDelegate?
    
    ///移动距离
    public var contentOffset: CGPoint {
        get {
            return mainScrollView.contentOffset
        }
    }
    
    ///标签栏
    private lazy var tabBar: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        return view
    }()
    ///标签组
    private var tabs: [UIButton] = []
    ///标签数量
    private var tabsCount: Int {
        get {
            return tabs.count
        }
    }
    ///标签栏高度
    public var tabBarHeight: CGFloat = 35
    ///标签栏底色
    public var tabBarColor: UIColor? {
        didSet {
            tabBar.backgroundColor = tabBarColor
        }
    }
    ///标签附件组
    private var titleViews: [UIView] = []
    ///外部定义标签附件组(选择
    private var selectedTitleViews: [UIView] = []
    ///外部定义标签附件组(未选择
    private var unselectedTitleViews: [UIView] = []
    ///标签附件染色(选中
    public var selectedTitleColor: UIColor = UIColor.black
    ///标签附件染色(未选择
    public var unselectedTitleColor: UIColor = UIColor.lightGray
    
    ///滑块
    private lazy var slider: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = sliderCornerRadius
        view.layer.masksToBounds = true
        return view
    }()
    ///滑块高度(可见部分
    public var sliderVisibleHeight: CGFloat = 3 {
        didSet {
            sliderRealHeight = sliderVisibleHeight * 2
            sliderCornerRadius = sliderVisibleHeight * 0.5
        }
    }
    ///滑块高度(实际部分
    private var sliderRealHeight: CGFloat = 6
    ///滑块圆角
    private var sliderCornerRadius: CGFloat = 1.5 {
        didSet {
            slider.layer.cornerRadius = sliderCornerRadius
        }
    }
    ///滑块色彩
    public var sliderColor: UIColor? {
        didSet {
            slider.backgroundColor = sliderColor
        }
    }
    ///滑块是否显示
    public var showSlider: Bool = true {
        didSet {
            slider.isHidden = !showSlider
        }
    }
    
    ///主题ScrollView
    private lazy var mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        
        return scrollView
    }()
    
    ///子View列表
    private var childViews: [UIView] = []
    
    ///当前所选索引
    private var selectedIndex: Int = 0 {
        willSet {
            if selectedIndex != newValue  {
                for (idx, lbl) in titleViews.enumerated() {
                    if let lbl = lbl as? UILabel {
                        if idx != newValue {
                            lbl.textColor = unselectedTitleColor
                        } else {
                            lbl.textColor = selectedTitleColor
                        }
                    }
                }
                for (idx, view) in unselectedTitleViews.enumerated() {
                    if idx != newValue {
                        selectedTitleViews[idx].isHidden = true
                        view.isHidden = false
                    } else {
                        selectedTitleViews[idx].isHidden = false
                        view.isHidden = true
                    }
                }
            }
        }
    }
    
    // MARK: *** 构造方法 ***
    
    convenience init(type: LSPageTabViewType) {
        self.init()
        
        self.type = type
        
        addSubview(tabBar)
        addSubview(mainScrollView)
    }
    
    // MARK: *** 布局 ***
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tabBar.frame.origin = CGPoint(x: 0, y: 0)
        tabBar.frame.size = CGSize(width: width, height: tabBarHeight)
        
        let tabWidth = width / CGFloat(tabsCount)
        for (idx, tab) in tabs.enumerated() {
            tab.frame = CGRect(x: CGFloat(idx) * tabWidth, y: 0, width: tabWidth, height: tabBarHeight)
        }
        slider.frame = CGRect(x: CGFloat(selectedIndex) * tabWidth, y: tabBar.height - sliderVisibleHeight, width: tabWidth, height: sliderRealHeight)
        
        mainScrollView.frame = CGRect(x: 0, y: tabBar.height, width: width, height: height - tabBar.height)
        mainScrollView.contentSize = CGSize(width: CGFloat(tabsCount) * width, height: height - tabBar.height)
        mainScrollView.contentOffset = CGPoint(x: CGFloat(selectedIndex) * width, y: 0)

        for (idx, childView) in childViews.enumerated() {
            childView.frame = CGRect(x: CGFloat(idx) * width, y: 0, width: width, height: height - tabBar.height)
        }
        for titleView in titleViews {
            titleView.frame = (titleView.superview?.bounds)!
        }
        for view in selectedTitleViews {
            view.frame = (view.superview?.bounds)!
        }
        for view in unselectedTitleViews {
            view.frame = (view.superview?.bounds)!
        }
    }
    
    
    // MARK: *** 回调 ***
    
    @objc private func tapOnTabBtn(sender: UIButton) {
        let targetIndex = sender.tag
        if targetIndex == selectedIndex {
            return
        }
        
        selectedTab(at: targetIndex, animated: true)
    }
    
    // MARK: *** 逻辑 ***
    
    public func selectedTab(at index: Int, animated: Bool) {
        mainScrollView.setContentOffset(CGPoint(x: CGFloat(index) * width, y: 0), animated: animated)
    }
}

extension LSPageTabView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        
        selectedIndex = Int(x / width + 0.5)
        
        slider.transform = CGAffineTransform(translationX: x / CGFloat(tabsCount), y: 0)
        
        if let _ = delegate?.pageTabViewDidScroll?(self) {
            print("larry sue : pageTabViewDidScroll")
        }
    }
}














