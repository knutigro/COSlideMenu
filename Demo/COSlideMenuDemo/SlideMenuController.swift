//
//  DemoSlideMenuController.swift
//  COSlideMenuDemo
//
//  Created by Knut Inge Grosland on 2015-09-20.
//  Copyright © 2015 Cocmoc. All rights reserved.
//

import UIKit

class SlideMenuController: COSlideMenuController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let menuController = storyboard?.instantiateViewControllerWithIdentifier("MenuViewController") as? MenuViewController
        menuController?.delegate = self
        self.menuViewController = menuController
        
        self.backgroundImage = UIImage(named: "cloud")
        self.delegate = self
        
        self.mainViewController = storyboard!.instantiateViewControllerWithIdentifier("AboutViewController")
    }
}


// MARK: COSlideMenuDelegate

extension SlideMenuController: COSlideMenuDelegate {
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

extension SlideMenuController: MenuControllerDelegate {
    func menuViewController(controller: MenuViewController, didSelectIndex index: Int) {
        switch index {
        case 1:
            self.mainViewController = storyboard!.instantiateViewControllerWithIdentifier("AboutViewController")
        case 2:
            self.mainViewController = storyboard!.instantiateViewControllerWithIdentifier("SettingsViewController")
        default:
            return
        }
    }

}
