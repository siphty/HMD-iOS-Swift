//
//  UIViewController+ChildVC.swift
//  HMD
//
//  Created by Yi JIANG on 8/6/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import Foundation

extension UIViewController {
    func popoverChildViewController(_ content: UIViewController) {
        let dismissBackgroundButton = UIButton()
        dismissBackgroundButton.frame = view.frame
        dismissBackgroundButton.accessibilityIdentifier = "DismissBackgroundButton"
        view.addSubview(dismissBackgroundButton)
        view.bringSubview(toFront: dismissBackgroundButton)
        dismissBackgroundButton.add(for: .touchDown){
            self.dismissPopoverChildViewController(content)
        }
    
        addChildViewController(content)
        view.addSubview(content.view)
        content.didMove(toParentViewController: self)
        view.bringSubview(toFront: content.view)
        
        
    }
    
    func dismissPopoverChildViewController(_ content: UIViewController) {
        content.willMove(toParentViewController: nil)
        content.view.removeFromSuperview()
        content.removeFromParentViewController()
        for subview in view.subviews {
            if subview.accessibilityIdentifier == "DismissBackgroundButton" {
                subview.removeFromSuperview()
            }
        }
    }
    
    
    func displayChildViewController(_ content: UIViewController) {
        addChildViewController(content)
        view.addSubview(content.view)
        content.didMove(toParentViewController: self)
        view.bringSubview(toFront: content.view)
        
        let dismissBackgroundButton = UIButton()
        content.view.addSubview(dismissBackgroundButton)
        dismissBackgroundButton.frame = content.view.frame
        dismissBackgroundButton.accessibilityIdentifier = "DismissBackgroundButton"
        view.bringSubview(toFront: dismissBackgroundButton)
        dismissBackgroundButton.add(for: .touchDown){
            self.hideChildViewController(content)
        }
        dismissBackgroundButton.topAnchor.constraint(equalTo: content.view.topAnchor).isActive = true
        dismissBackgroundButton.leadingAnchor.constraint(equalTo: content.view.leadingAnchor).isActive = true
        dismissBackgroundButton.trailingAnchor.constraint(equalTo: content.view.trailingAnchor).isActive = true
        dismissBackgroundButton.bottomAnchor.constraint(equalTo: content.view.bottomAnchor).isActive = true
    }
    
    func hideChildViewController(_ content: UIViewController) {
        content.willMove(toParentViewController: nil)
        content.view.removeFromSuperview()
        content.removeFromParentViewController()
        for subview in view.subviews {
            if subview.accessibilityIdentifier == "DismissBackgroundButton" {
                subview.removeFromSuperview()
            }
        }
    }
}
