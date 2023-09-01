//
//  Animation.swift
//  Todo
//
//  Created by 김도현 on 2023/08/03.
//

import Foundation
import UIKit

protocol Animation {
    // 애니메이션을 적용시킬 layer
    var animationLayer: CALayer { get set }
    func animation(animationRadius: CGFloat, center: CGPoint)
}

extension Animation where Self: CAAnimationDelegate {

    func animateLayer(animationRadius: CGFloat, center: CGPoint, color: UIColor, fromValue: CGFloat, toValue: CGFloat, forKey: String? = nil) -> CAShapeLayer {
        animationLayer.removeFromSuperlayer()
        let path = UIBezierPath(arcCenter: .zero, radius: animationRadius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        let calayer = CAShapeLayer()
        calayer.path = path.cgPath
        calayer.fillColor = color.cgColor
        calayer.position = center

        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.delegate = self
        calayer.add(animation, forKey: forKey)
        return calayer
    }
}
