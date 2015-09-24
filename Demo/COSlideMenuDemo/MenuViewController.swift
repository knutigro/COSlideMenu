//
//  DemoMenuViewController.swift
//  COSlideMenuDemo
//
//  Created by Knut Inge Grosland on 2015-09-20.
//  Copyright © 2015 Cocmoc. All rights reserved.
//

import UIKit


protocol MenuControllerDelegate: class {
    func menuViewController(controller: MenuViewController, didSelectIndex index: Int)
}

class MenuViewController: UITableViewController {
    
    weak var delegate: MenuControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.menuViewController(self, didSelectIndex: indexPath.row)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

// MARK: COSlideMenuDelegate

extension MenuViewController: COSlideMenuDelegate {
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

