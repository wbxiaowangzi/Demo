//
//  Transitioning.swift
//  Demo
//
//  Created by wangbo on 2020/4/23.
//  Copyright © 2020 wangbo. All rights reserved.
//

import UIKit

class Transitioning: NSObject {

}

extension Transitioning: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //取出转场前后的视图控制器
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)

        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        
        //取出转场前后视图控制器上的视图view
        let fromeView = transitionContext.view(forKey: UITransitionContextViewKey.from)

        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        
        //containerView：要做砖茶昂动画的视图就必须加到containerView上才能进行 ，也就是说containerView管理这所有转场动画视图
        let containerView = transitionContext.containerView
        
        //如果加入了手势，就需要根据手势交互动作是否完成、取消来做操作，完成标记yes，取消标记no
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        if transitionContext.transitionWasCancelled {
            //如果取消转场动画
        } else {
            //完成转场
        }
    }
    
}

class SDInteractiveTransition: UIPercentDrivenInteractiveTransition {
    
}
