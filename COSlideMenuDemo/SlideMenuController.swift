//
//  DemoSlideMenuController.swift
//  COSlideMenuDemo
//
//  Created by Knut Inge Grosland on 2015-09-20.
//  Copyright © 2015 Cocmoc. All rights reserved.
//

import UIKit

class DemoSlideMenuController: COSlideMenuController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.menuViewController = storyboard?.instantiateViewControllerWithIdentifier("MenuViewController")
        self.mainViewController = storyboard?.instantiateViewControllerWithIdentifier("NavigationViewController")
        if let navigationController = self.mainViewController as? UINavigationController {
            navigationController.viewControllers.first?.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu-ico"), style: .Plain, target: self, action: Selector("didTapLeftBarButton:"))
        }
        
        self.backgroundImage = UIImage(named: "cloud")
        self.delegate = self
    }
}

// MARK: Actions

extension DemoSlideMenuController {
    @IBAction func didTapLeftBarButton(sender: AnyObject?) {
        toggleMenu()
    }
}

// MARK: COSlideMenuDelegate

extension DemoSlideMenuController: COSlideMenuDelegate {
    func willOpenMenu() {
        print("willOpenMenu")
    }
    
    func didOpenMenu() {
        print("didOpenMenu")
    }

    func willCloseMenu() {
        print("willCloseMenu")
    }

    func didCloseMenu() {
        print("didCloseMenu")
    }
}
