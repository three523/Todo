//
//  CheckBoxButton.swift
//  Todo
//
//  Created by 김도현 on 2023/08/02.
//

import UIKit

final class CompleteButton: UIButton, CAAnimationDelegate, Animation {
    var animationLayer: CALayer = CALayer()
    var isCompleted: Bool = false
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
    
    func countAnimation(count: CGFloat, goal: CGFloat, isIncrease: Bool) {
        animationLayer.removeFromSuperlayer()
        let calayer = CALayer()
        calayer.frame = CGRect(x: 0, y: 0, width: bounds.width, height: ceil(bounds.height))
        calayer.backgroundColor = UIColor.mainColor.cgColor
        let caAnimation = CABasicAnimation(keyPath: "position.y")
        caAnimation.delegate = self
        let startPostion = bounds.height + bounds.height/2
        if isIncrease {
            caAnimation.fromValue = startPostion - bounds.height/goal * (count - 1)
            caAnimation.toValue = startPostion - bounds.height/goal * count
        } else {
            caAnimation.fromValue = startPostion - bounds.height/goal * (count + 1)
            caAnimation.toValue = startPostion  - bounds.height/goal * count
        }
        
        caAnimation.fillMode = .forwards
        caAnimation.isRemovedOnCompletion = false

        calayer.add(caAnimation, forKey: "frame")
        animationLayer = calayer
        self.layer.insertSublayer(animationLayer, at: 0)
    }
    
    func noAnimation(height: CGFloat, count: CGFloat, goal: CGFloat) {
        animationLayer.removeFromSuperlayer()
        let startPostion = height
        let y = startPostion - height/goal * count
        let calayer = CALayer()
        calayer.backgroundColor = UIColor.mainColor.cgColor
        calayer.frame = CGRect(x: 0, y: y, width: height, height: height)
        animationLayer = calayer
        self.layer.insertSublayer(animationLayer, at: 0)
    }
        
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if animationLayer.animation(forKey: "frame") == anim && isCompleted {
            animationCompleted()
        }
        if animationLayer.animation(forKey: "notCompleteAnimation") == anim {
            animationLayer.removeFromSuperlayer()
        } else if animationLayer.animation(forKey: "CompleteAnimation") == anim {
            animationCompleted()
            return
        }
    }
}
