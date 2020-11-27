//
//  NavagationCotrollerDelegate.swift
//  CircleTransition
//
//  Created by LiQuan on 16/7/13.
//  Copyright © 2016年 LiQuan. All rights reserved.
//

import UIKit

class NavagationCotrollerDelegate: NSObject, UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CircleTransitionAnimator()
    }
}
