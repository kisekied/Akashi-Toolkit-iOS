//
//  ATAvatarListViewController.swift
//  akashiToolkit
//
//  Created by LarrySue on 2017/10/19.
//  Copyright © 2017年 kcwikizh. All rights reserved.
//

import UIKit
import SDWebImage

private let ATAvatarListViewCellIdentifier = "ATAvatarListViewCellIdentifier"

class ATAvatarListViewController: ATViewController {
    
    private var avatarURLList: [URL?] = []
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.width * 0.5 - 1, height: UIScreen.width * 0.5 - 1)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        
        let collView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collView.backgroundColor = Constant.ui.color.lightBackground
        collView.showsVerticalScrollIndicator = false
        collView.dataSource = self
        collView.delegate = self
        
        return collView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "历史头像"
        
        view.backgroundColor = Constant.ui.color.lightBackground
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.top.equalTo(navView.snp.bottom)
        }
        
        collectionView.register(ATAvatarListViewCell.self, forCellWithReuseIdentifier: ATAvatarListViewCellIdentifier)
        
        ATDataTool.getAvatarList { (urlList, error) in
            if let urlList = urlList {
                self.avatarURLList = urlList
                self.collectionView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        SDImageCache.shared().clearMemory()
    }
}

extension ATAvatarListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return avatarURLList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ATAvatarListViewCellIdentifier, for: indexPath) as! ATAvatarListViewCell
        
        cell.imageURL = avatarURLList[indexPath.row]
        
        return cell
    }
}

extension ATAvatarListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ATImagePageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        
        vc.avatarURLList = avatarURLList
        vc.initialIndex = indexPath.row
        
        present(vc, animated: true)
    }
}

private class ATAvatarListViewCell: UICollectionViewCell {
    ///图片链接
    var imageURL: URL? {
        didSet {
            imageView.sd_setImage(with: imageURL)
        }
    }
    
    private lazy var imageView: UIImageView = {
        let imv = UIImageView()
        
        imv.backgroundColor = Constant.ui.color.lightForeground
        
        return imv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
