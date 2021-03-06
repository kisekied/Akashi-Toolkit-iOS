//
//  LSScrollView.swift
//  akashiToolkit
//
//  Created by LarrySue on 2017/10/25.
//  Copyright © 2017年 LarrySue. All rights reserved.
//

import UIKit

class LSScrollView: UIScrollView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        panGestureRecognizer.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LSScrollView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer.isKind(of: UIScreenEdgePanGestureRecognizer.self) {
            gestureRecognizer.require(toFail: otherGestureRecognizer)
            return true
        }
        return false
    }
}
