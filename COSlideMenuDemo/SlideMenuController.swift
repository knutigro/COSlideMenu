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
        
        setMainController(storyboard!.instantiateViewControllerWithIdentifier("AboutViewController"))
        self.backgroundImage = UIImage(named: "cloud")
        self.delegate = self
    }
    
    func setMainController(controller: UIViewController) {
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.viewControllers.first?.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu-ico"), style: .Plain, target: self, action: Selector("didTapLeftBarButton:"))
        self.mainViewController = navigationController
    }
}


// MARK: Actions

extension SlideMenuController {
    @IBAction func didTapLeftBarButton(sender: AnyObject?) {
        toggleMenu()
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
            setMainController(storyboard!.instantiateViewControllerWithIdentifier("AboutViewController"))
        case 2:
            setMainController(storyboard!.instantiateViewControllerWithIdentifier("SettingsViewController"))
        default:
            return
        }
    }

}
