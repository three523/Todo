//
//  CheckBoxButton.swift
//  Todo
//
//  Created by 김도현 on 2023/08/02.
//

import UIKit

class CheckBoxButton: UIButton, CAAnimationDelegate {
    
    var animationLayer: CAShapeLayer = CAShapeLayer()
    var animationCompleted: ()->Void = {}
        
    var isCheck: Bool = false
    
    func noAnimate() {
        if isCheck {
            let path = UIBezierPath(arcCenter: .zero, radius: self.frame.height + 10, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
            let calayer = CAShapeLayer()
            calayer.path = path.cgPath
            calayer.fillColor = UIColor.mainColor.cgColor
            calayer.strokeColor = UIColor.mainColor.cgColor
            calayer.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
            animationLayer = calayer
            self.layer.insertSublayer(calayer, at: 0)
        }
    }

    func animate() {
        animationLayer.removeFromSuperlayer()
        let path = UIBezierPath(arcCenter: .zero, radius: 3, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        let calayer = CAShapeLayer()
        calayer.path = path.cgPath
        calayer.fillColor = UIColor.mainColor.cgColor
        calayer.strokeColor = UIColor.mainColor.cgColor
        calayer.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        
        animationLayer = calayer
        
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.delegate = self
        if isCheck {
            animation.fromValue = 1
            animation.toValue = 8
            calayer.add(animation, forKey: "CompleteAnimation")
        } else {
            animation.fromValue = 8
            animation.toValue = 1
            calayer.add(animation, forKey: "notCompleteAnimation")
        }
        self.layer.insertSublayer(calayer, at: 0)
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if animationLayer.animation(forKey: "notCompleteAnimation") == anim {
            animationLayer.removeFromSuperlayer()
        } else if flag && animationLayer.animation(forKey: "CompleteAnimation") == anim {
            animationCompleted()
            return
        }
    }

}
