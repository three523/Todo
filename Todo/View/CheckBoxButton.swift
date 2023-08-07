//
//  CheckBoxButton.swift
//  Todo
//
//  Created by 김도현 on 2023/08/02.
//

import UIKit

class CheckBoxButton: UIButton, CAAnimationDelegate, Animation {
    
    var isCompleted: Bool = false
    var animationLayer: CAShapeLayer = CAShapeLayer()
    var animationCompleted: ()->Void = {}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animation(animationRadius: CGFloat, center: CGPoint) {
        var fromValue = 1.0
        var toValue = 1.0
        var forkey: String?
        if isCompleted {
            fromValue = 1
            toValue = 8
            forkey = "CompleteAnimation"
        } else {
            fromValue = 8
            toValue = 1
            forkey = "notCompleteAnimation"
        }
        animationLayer = animateLayer(animationRadius: animationRadius, center: center, color: UIColor.mainColor, fromValue: fromValue, toValue: toValue, forKey: forkey)
        self.layer.insertSublayer(animationLayer, at: 0)
    }
        
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print(anim == animationLayer.animation(forKey: "CompleteAnimation"), flag)
        if animationLayer.animation(forKey: "notCompleteAnimation") == anim {
            animationLayer.removeFromSuperlayer()
        } else if animationLayer.animation(forKey: "CompleteAnimation") == anim {
            animationCompleted()
            return
        }
    }
}
