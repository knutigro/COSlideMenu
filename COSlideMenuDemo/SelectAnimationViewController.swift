//
//  SelectAnimationViewController.swift
//  COSlideMenuDemo
//
//  Created by Knut Inge Grosland on 2015-09-22.
//  Copyright © 2015 Cocmoc. All rights reserved.
//


import UIKit

protocol SelectAnimationDelegate: class {
    func selectAnimationViewController(controller: SelectAnimationViewController, didSelectMenuAnimation animation: MenuAnimation)
}

class SelectAnimationViewController: UIViewController {
    
    weak var delegate: SelectAnimationDelegate?
    var menuAnimation: MenuAnimation?

    @IBOutlet weak private var pickerView: UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let menuAnimation = menuAnimation, let index = MenuAnimation.all.indexOf(menuAnimation) {
            pickerView.selectRow(index, inComponent: 0, animated: true)
        }
    }
    
}

extension SelectAnimationViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
    
        return MenuAnimation.all.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return MenuAnimation.all[row].rawValue
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.delegate?.selectAnimationViewController(self, didSelectMenuAnimation: MenuAnimation.all[row])
    }
}


