//
//  CenterViewController.swift
//  SlideOutNavigation
//
//  Created by James Frost on 03/08/2014.
//  Copyright (c) 2014 James Frost. All rights reserved.
//

import UIKit

@objc
protocol CenterViewControllerDelegate {
    optional func toggleLeftPanel()
    optional func toggleRightPanel()
    optional func collapseSidePanels()
}

class CenterViewController: UIViewController {
    
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var creatorLabel: UILabel!
    
    var delegate: CenterViewControllerDelegate?

    // Button actions
    // This uses optional binding to check that delegate has a value,
    // and then calls the toggleLeftPanel method if the delegate has implemented it.
    @IBAction func kittiesTapped(sender: AnyObject) {
        if let d = delegate {
            d.toggleLeftPanel?()
        }
    }
    
    @IBAction func puppiesTapped(sender: AnyObject) {
    }
}