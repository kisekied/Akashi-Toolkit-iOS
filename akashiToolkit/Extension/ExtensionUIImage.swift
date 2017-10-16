//
//  ExtensionUIImage.swift
//  akashiToolkit
//
//  Created by LarrySue on 2017/10/16.
//  Copyright © 2017年 kcwikizh. All rights reserved.
//

import UIKit

extension UIImage {
    ///重设图片大小
    func reSizeImage(reSize:CGSize)->UIImage {
        UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.main.scale);
        draw(in: CGRect(x: 0, y: 0, width: reSize.width, height: reSize.height))
        let reSizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        return reSizeImage;
    }
    
    ///等比率缩放
    func scaleImage(scaleSize:CGFloat)->UIImage {
        let reSize = CGSize(width: size.width * scaleSize, height: size.height * scaleSize)
        return reSizeImage(reSize: reSize)
    }
}