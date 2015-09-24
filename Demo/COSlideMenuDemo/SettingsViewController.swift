//
//  SettingsViewController.swift
//  COSlideMenuDemo
//
//  Created by Knut Inge Grosland on 2015-09-22.
//  Copyright © 2015 Cocmoc. All rights reserved.
//

import UIKit

protocol SettingsDelegate: class {
    func settingsViewControllerDidChange(controller: SettingsViewController)
}

class SettingsViewController: UIViewController {
    
    @IBOutlet weak private var animationLabel: UILabel?
    
    weak var delegate: SettingsDelegate?

    var menuAnimation = MenuAnimation.Alpha3D {
        didSet {
            if let animationLabel = animationLabel {
                animationLabel.text = "Animation: \"" + menuAnimation.rawValue + "\""
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuAnimation = .Alpha3D
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "OpenSelectMenuSegue") {
            let selectAnimationViewController = segue.destinationViewController as! SelectAnimationViewController
            selectAnimationViewController.delegate = self
            selectAnimationViewController.menuAnimation = menuAnimation
        }
    }
}

// MARK: SelectAnimationDelegate

extension SettingsViewController: SelectAnimationDelegate {
    func selectAnimationViewController(controller: SelectAnimationViewController, didSelectMenuAnimation animation: MenuAnimation) {
        menuAnimation = animation
        self.delegate?.settingsViewControllerDidChange(self)
    }
}
