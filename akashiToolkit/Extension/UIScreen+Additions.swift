//
//  UIScreen+Additions.swift
//  akashiToolkit
//
//  Created by LarrySue on 2017/10/13.
//  Copyright © 2017年 kcwikizh. All rights reserved.
//

import UIKit

extension UIScreen {
    ///屏幕宽度
    class var width: CGFloat {
        return main.bounds.width
    }
    ///屏幕高度
    class var height: CGFloat {
        return main.bounds.height
    }
}
