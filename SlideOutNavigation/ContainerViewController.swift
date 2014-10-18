//
//  ContainerViewController.swift
//  SlideOutNavigation
//
//  Created by James Frost on 03/08/2014.
//  Copyright (c) 2014 James Frost. All rights reserved.
//

import UIKit
import QuartzCore

enum SlideOutState {
    case BothCollapsed
    case LeftPanelExpanded
    case RightPanelExpanded
}

class ContainerViewController: UIViewController, CenterViewControllerDelegate {

    var centerNavigationController: UINavigationController!
    var centerViewController: CenterViewController!

    var currentState: SlideOutState = .BothCollapsed
    var leftViewController: SidePanelViewController?
    
    let centerPanelExpandedOffset: CGFloat = 60
    
    override init() {
        super.init(nibName: nil, bundle: nil)
        centerViewController = UIStoryboard.centerViewController()
        centerViewController.delegate = self
        
        // wrap the centerViewController in a navigation controller, so we can push views to it
        // and display bar button items in the navigation bar
        centerNavigationController = UINavigationController(rootViewController: centerViewController)
        view.addSubview(centerNavigationController.view)
        addChildViewController(centerNavigationController)
        
        centerNavigationController.didMoveToParentViewController(self)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
  
    // MARK: CenterViewController delegate methods
  
    func toggleLeftPanel() {
        let notAlreadyExposed: Bool = (currentState != SlideOutState.LeftPanelExpanded)
        if notAlreadyExposed { addLeftPanelViewController() }
        animateLeftPanel(shouldExpand: notAlreadyExposed)
    }
  
    func toggleRightPanel() {
    }
  
    func addLeftPanelViewController() {
        if (leftViewController == nil) {
            leftViewController = UIStoryboard.leftViewController()
            leftViewController!.animals = Animal.allCats()
            addChildSidePanelController(leftViewController!)
        }
    }
    
    func addChildSidePanelController(sidePanelController: SidePanelViewController) {
        view.insertSubview(sidePanelController.view, atIndex: 0)
        self.addChildViewController(sidePanelController)
        sidePanelController.didMoveToParentViewController(self)
    }
    
    func addRightPanelViewController() {
    }
  
    func animateLeftPanel(#shouldExpand: Bool) {
        if (shouldExpand) {
            currentState = SlideOutState.LeftPanelExpanded
            self.animateCenter(targetPosition:
                CGRectGetWidth(centerNavigationController.view.frame) - (centerPanelExpandedOffset))
        } else {
            self.animateCenter(targetPosition: 0, completion: {
                finished in
                self.currentState = .BothCollapsed
                self.leftViewController!.view.removeFromSuperview()
                self.leftViewController = nil;
            })
            
        }

    }
    
    func animateCenter(#targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.9,
            initialSpringVelocity: 0.8, options: UIViewAnimationOptions.CurveEaseInOut,
            animations: {
                self.centerNavigationController.view.frame.origin.x = targetPosition
            }, completion: completion)
    }
    
    
    func animateRightPanel(#shouldExpand: Bool) {
    }
  
    func showShadowForCenterViewControler(shouldShowShadow: Bool) {
        centerNavigationController.view.layer.opacity = (shouldShowShadow ? 0.8 : 0.0)
    }
    
    // MARK: Gesture recognizer
    func handlePanGesture(recognizer: UIPanGestureRecognizer) {
    }
}

private extension UIStoryboard {
  class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()) }
  
  class func leftViewController() -> SidePanelViewController? {
    return mainStoryboard().instantiateViewControllerWithIdentifier("LeftViewController") as? SidePanelViewController
  }
  
  class func rightViewController() -> SidePanelViewController? {
    return mainStoryboard().instantiateViewControllerWithIdentifier("RightViewController") as? SidePanelViewController
  }
  
  class func centerViewController() -> CenterViewController? {
    return mainStoryboard().instantiateViewControllerWithIdentifier("CenterViewController") as? CenterViewController
  }
}