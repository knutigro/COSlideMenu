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
        self.delegate = menuController

        self.backgroundImage = UIImage(named: "cloud")
        
        self.mainViewController = storyboard!.instantiateViewControllerWithIdentifier("AboutViewController")
    }
}

extension SlideMenuController: MenuControllerDelegate {
    func menuViewController(controller: MenuViewController, didSelectIndex index: Int) {
        switch index {
        case 1:
            self.mainViewController = storyboard!.instantiateViewControllerWithIdentifier("AboutViewController")
        case 2:
            if let settingsViewController = storyboard?.instantiateViewControllerWithIdentifier("SettingsViewController") as? SettingsViewController {
                settingsViewController.menuAnimation = self.menuAnimation
                settingsViewController.delegate = self
                self.mainViewController = settingsViewController
            }
        default:
            return
        }
    }

}

// MARK: SettingsDelegate

extension SlideMenuController: SettingsDelegate {
    
    func settingsViewControllerDidChange(controller: SettingsViewController) {
        self.menuAnimation = controller.menuAnimation
    }

}

