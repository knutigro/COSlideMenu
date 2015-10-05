//
//  COSlideMenuController.swift
//  COSlideMenuDemo
//
//  Created by Knut Inge Grosland on 2015-09-20.
//  Copyright © 2015 Cocmoc. All rights reserved.
//

import UIKit

@objc protocol COSlideMenuDelegate {
    optional func willOpenMenu()
    optional func didOpenMenu()
    optional func willCloseMenu()
    optional func didCloseMenu()
}

enum MenuAnimation: String {
    case Alpha3D = "Alpha3D"
    case Slide = "Slide"
    static let all = [MenuAnimation.Alpha3D, MenuAnimation.Slide]
}

class COSlideMenuController: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: Public
    
    weak var delegate: COSlideMenuDelegate?
    var menuAnimation = MenuAnimation.Slide {
        didSet {
            resetMenu()
        }
    }
    
    var menuViewController: UIViewController?  {
        willSet {
            if let menuViewController = self.menuViewController {
                menuViewController.willMoveToParentViewController(nil)
                menuViewController.removeFromParentViewController()
                menuViewController.view.removeFromSuperview()
            }
        }
        didSet {
            if let menuViewController = self.menuViewController {
                menuContainer.view.frame = self.view.bounds;
                menuContainer.addChildViewController(menuViewController)
                menuContainer.view.addSubview(menuViewController.view)
                menuContainer.didMoveToParentViewController(menuViewController)
            }
        }
    }
    var mainViewController: UIViewController? {
        willSet {
            if mainContainer == newValue {
                if (CGRectGetMinX(mainContainer.view.frame) == distanceOpenMenu) {
                    closeMenu()
                }
            }
        }
        didSet {
            if let mainViewController = self.mainViewController {
                mainContainer.setViewControllers([mainViewController], animated: false)
                mainViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu-ico"), style: .Plain, target: self, action: Selector("didTapLeftBarButton:"))
            }
            
            if (CGRectGetMinX(mainContainer.view.frame) == distanceOpenMenu) {
                closeMenu()
            }
        }
    }
    
    var backgroundImage: UIImage? {
        get {  return bgImageContainer.image }
        set {  bgImageContainer.image = newValue }
    }
    
    var backgroundImageContentMode = UIViewContentMode.ScaleAspectFill {
        didSet {
            bgImageContainer.contentMode = backgroundImageContentMode
        }
    }
    
    // MARK: Private
    
    private var mainContainer: UINavigationController!
    private var menuContainer: UIViewController!
    private var tapGestureRecognizer: UITapGestureRecognizer?
    private var bgImageContainer: UIImageView!
    private var panGestureRecognizer: UIPanGestureRecognizer?
    private var draggingPoint: CGPoint?
    private var distanceOpenMenu: CGFloat = 210.0
    private let kDefaultAngle3DMenu = 35.0


    // MARK: Setup
    
    private func setup() {
        view.backgroundColor = UIColor.blackColor()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("didRotate:"), name: UIDeviceOrientationDidChangeNotification, object: nil)
        
        bgImageContainer = UIImageView(frame: view.bounds)
        bgImageContainer.contentMode = backgroundImageContentMode
        bgImageContainer.layer.zPosition = -2000
        view.addSubview(bgImageContainer)
        
        menuContainer = UIViewController()
        menuContainer.view.layer.anchorPoint = CGPointMake(1.0, 0.5)
        menuContainer.view.frame = view.bounds
        menuContainer.view.backgroundColor = UIColor.clearColor()
        addChildViewController(menuContainer)
        view.addSubview(menuContainer.view)
        menuContainer.didMoveToParentViewController(self)
        
        mainContainer = UINavigationController(rootViewController: UIViewController())
        mainContainer.view.frame = self.view.bounds
        mainContainer.view.backgroundColor = UIColor.clearColor()
        addChildViewController(mainContainer)
        view.addSubview(mainContainer.view)
        mainContainer.didMoveToParentViewController(self)

        
        enablePan = true
    }

    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: Rotation

    func didRotate(notification: NSNotification) {
        let fMain = mainContainer.view.frame
        if CGRectGetMinX(fMain) == 0 {
            let layer = menuContainer.view.layer
            layer.transform = CATransform3DIdentity
        }
    }
}

// MARK: Actions

extension COSlideMenuController {
    @IBAction func didTapLeftBarButton(sender: AnyObject?) {
        toggleMenu()
    }
}

// MARK: Menu Actions

extension COSlideMenuController {
    
    func toggleMenu() {
        let fMain = mainContainer.view.frame
        if CGRectGetMinX(fMain) == distanceOpenMenu {
            closeMenu()
        } else {
            openMenu()
        }
    }
    
    func openMenu() {
        delegate?.willOpenMenu?()
        addTapGestures()
        
        var toFrame = mainContainer.view.frame
        toFrame.origin.x = distanceOpenMenu
        
        animateView(mainContainer.view, toFrame: toFrame, duration: 0.2, delay: 0) { (finished: Bool) -> Void in
            delegate?.didOpenMenu?()
        }
        
        setMenuVisible(false, animated: false)
        setMenuVisible(true, animated: true)
    }
    
    func closeMenu() {
        let delayInSeconds = 0.1
        
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
        dispatch_after(popTime, dispatch_get_main_queue()) { () -> Void in
            delegate?.willCloseMenu?()
        }
        
        var toFrame = mainContainer.view.frame
        toFrame.origin.x = 0
        
        animateView(mainContainer.view, toFrame: toFrame, duration: 0.2, delay: 0.2) { [weak self] (finished: Bool) -> Void in
            self?.removeTapGestures()
            self?.delegate?.didCloseMenu?()
        }

        setMenuVisible(false, animated: true)
    }
}

// MARK: Tap Gestures Recognizer

extension COSlideMenuController {
    
    private func addTapGestures() {
        if tapGestureRecognizer == nil {
            self.mainViewController?.view.userInteractionEnabled = false
            tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("tapMainAction:"))
            mainContainer.view.addGestureRecognizer(tapGestureRecognizer!)
        }
    }
    
    private func removeTapGestures() {
        if let tapGestureRecognizer = self.tapGestureRecognizer {
            mainContainer.view.removeGestureRecognizer(tapGestureRecognizer)
        }
        mainViewController?.view.userInteractionEnabled = true
        tapGestureRecognizer = nil
    }
    
    func tapMainAction(sender: AnyObject?) {
        closeMenu()
    }
}


// MARK: Pan Gesture Recognizer

extension COSlideMenuController {
    
    private var shouldOpen: Bool {
        get {
            return (mainContainer.view.frame.origin.x >= distanceOpenMenu / 2)
        }
    }
    
    var enablePan: Bool {
        set {
            if (enablePan == true) {
                addPanGestures()
            } else{
                removePanGestures()
            }
        }
        get {
            return panGestureRecognizer == nil
        }
    }

    private func addPanGestures() {
        if panGestureRecognizer == nil {
            panGestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("panDetected:"))
            panGestureRecognizer?.delegate = self;
            self.mainContainer.view.addGestureRecognizer(panGestureRecognizer!)
        }
    }
    
    private func removePanGestures() {
        if let panGestureRecognizer = self.panGestureRecognizer {
            mainContainer.view.removeGestureRecognizer(panGestureRecognizer)
        }
        self.panGestureRecognizer = nil
    }
    
    func panDetected(panRecognizer: UIPanGestureRecognizer) {
        let translation = panRecognizer.translationInView(panRecognizer.view)
        let velocity = panRecognizer.velocityInView(panRecognizer.view)
        
        if panGestureRecognizer?.state == .Began {
            self.draggingPoint = translation
        } else if panGestureRecognizer?.state == .Changed {
            
            var offset = fabs(self.draggingPoint!.x - translation.x)

            if offset == 0 { return  }
            
            self.draggingPoint = translation
            
            if velocity.x <= 0 {
                offset = -offset
            }
            
            var fMain = mainContainer.view.frame
            fMain.origin.x += offset
            
            let isOutsideMenuBounds = (fMain.origin.x <= 0) || (fMain.origin.x >= distanceOpenMenu)
            if (isOutsideMenuBounds) {  return  }
            
            mainContainer.view.frame = fMain
            
            setPanMenuAction(panGestureRecognizer!.state, offset: offset)
            
        } else if (panGestureRecognizer?.state == .Ended) || (panGestureRecognizer?.state == .Cancelled) {

            var fMain = mainContainer.view.frame
            let newSeg: CGFloat!
            
            if (shouldOpen) {
                addTapGestures()
                newSeg = (distanceOpenMenu - fMain.origin.x) / distanceOpenMenu
                fMain.origin.x = distanceOpenMenu
            } else {
                removeTapGestures()
                newSeg = fMain.origin.x / distanceOpenMenu
                fMain.origin.x = 0
            }
            
            animateView(mainContainer.view, toFrame: fMain, duration: Double(newSeg), delay: 0.0, completion: nil)
            
            setPanMenuAction(panGestureRecognizer!.state, offset: 0)
        }
    }
}

// MARK: Main Animations

extension COSlideMenuController {
    
    private func animateView(view: UIView, toFrame: CGRect, duration: NSTimeInterval, delay: NSTimeInterval, completion: ((Bool) -> Void)?) {
        UIView.animateWithDuration(duration, delay: delay, options: .CurveLinear, animations: { () -> Void in
            view.frame = toFrame
            }) { (finished: Bool) -> Void in
                completion?(finished)
        }
    }
    
}

// MARK: Menu Animations

extension COSlideMenuController {
    
    func resetMenu() {
        set3DMenuVisible(true, animated: false)
        setSlideMenuVisible(true, animated: false)
    }
    
    func setMenuVisible(visible: Bool, animated: Bool) {
        switch menuAnimation {
            case .Alpha3D:
                set3DMenuVisible(visible, animated: animated)
            case .Slide:
                setSlideMenuVisible(visible, animated: animated)
        }
    }
    
    func setPanMenuAction(panState: UIGestureRecognizerState, offset: CGFloat) {
        switch menuAnimation {
        case .Alpha3D:
            setPan3DMenuAction(panState, offset: offset)
        case .Slide:
            setPanSlideMenuAction(panState, offset: offset)
        }
    }
}


// MARK: 3D-Menu Animations

extension COSlideMenuController {
    
    private func setPan3DMenuAction(panState: UIGestureRecognizerState, offset: CGFloat) {
        if panState == .Changed {
            var fMain = mainContainer.view.frame
            fMain.origin.x += offset
            let newAngle = ((Double(distanceOpenMenu - fMain.origin.x) * kDefaultAngle3DMenu) / Double(distanceOpenMenu)) * -1
            let newAlpha = ((0.7 * (fMain.origin.x)) / distanceOpenMenu) + 0.3;

            rotate3DView(menuContainer.view, toAngle: newAngle)
            menuContainer.view.alpha = newAlpha
        } else if (panState == .Ended) || (panState == .Cancelled) {
            let fMain = mainContainer.view.frame
            
            let new3dSeg: CGFloat!
            let newAngle: Double!
            let newAlpha: CGFloat!

            if (self.shouldOpen) {
                new3dSeg = ((distanceOpenMenu - fMain.origin.x) * 0.3) / distanceOpenMenu
                newAngle = 0.0
                newAlpha = 1.0
            } else {
                new3dSeg = ((fMain.origin.x) * 0.3 ) / distanceOpenMenu
                newAngle = -kDefaultAngle3DMenu
                newAlpha = 0.3
            }
            
            animateView3D(menuContainer.view, toAngle: newAngle, toAlpha: newAlpha, duration: Double(new3dSeg), delay: 0.1, completion:nil)
        }
    }
    
    private func set3DMenuVisible(visible: Bool, animated: Bool) {
        if visible == true {
            if animated == true {
                animateView3D(menuContainer.view, toAngle: 0, toAlpha: 1.0, duration: 0.3, delay: 0.1, completion:nil)
            } else {
                menuContainer.view.layer.transform = CATransform3DIdentity
                menuContainer.view.alpha = 1.0
            }
        } else {
            if animated == true {
                animateView3D(menuContainer.view, toAngle: -kDefaultAngle3DMenu, toAlpha: 0.3, duration: 0.3, delay: 0.1, completion:nil)
            } else {
                rotate3DView(menuContainer.view, toAngle: -kDefaultAngle3DMenu)
                menuContainer.view.alpha = 0.3
            }
        }
    }
    
    private func animateView3D(view: UIView, toAngle: Double, toAlpha: CGFloat, duration: NSTimeInterval, delay: NSTimeInterval, completion: ((Bool) -> Void)?) {
        
        UIView.animateWithDuration(duration, delay: delay, options: .CurveLinear, animations: { [weak self] () -> Void in

            if toAngle == 0 {
                view.layer.transform = CATransform3DIdentity
            } else {
                self?.rotate3DView(view, toAngle: toAngle)
            }
            
            view.alpha = toAlpha

            }) { (finished: Bool) -> Void in
                completion?(finished)
        }
    }
    
    private func rotate3DView(view: UIView, toAngle: Double) {
        let layer = view.layer
        layer.zPosition = -1000
        var t = CATransform3DIdentity
        t.m34 = 1.0 / -500
        t = CATransform3DRotate(t, CGFloat(toAngle * M_PI / 180.0), 0, 1, 0)
        layer.transform = t
    }

}

// MARK: Slide Animations

extension COSlideMenuController {
    
    private func setPanSlideMenuAction(panState: UIGestureRecognizerState, offset: CGFloat) {
        
        let slidePosition = mainContainer.view.frame.origin.x + offset
        let offset: CGFloat = -((distanceOpenMenu - slidePosition) * 0.2)
        
        print("offset \(offset)")
        
        if panState == .Changed {
            menuContainer.view.frame = CGRectMake(offset, view.frame.origin.y, view.frame.size.width, view.frame.size.height)
        } else if (panState == .Ended) || (panState == .Cancelled) {
            let fMain = mainContainer.view.frame
            let duration: CGFloat!
            
            if (shouldOpen) {
                duration = ((distanceOpenMenu - fMain.origin.x) * 0.3 ) / distanceOpenMenu
            } else {
                duration = ((fMain.origin.x) * 0.3 ) / distanceOpenMenu
            }
            animateViewSlide(menuContainer.view, toOffset: offset, toAlpha: 0, duration: Double(duration), delay: 0.1, completion:nil)
        }
    }
    
    private func setSlideMenuVisible(visible: Bool, animated: Bool) {
        
        if visible == true {
            if animated == true {
                animateViewSlide(menuContainer.view, toOffset: 0, toAlpha: 0.3, duration: 0.3, delay: 0.0, completion:nil)
            } else {
                menuContainer.view.frame = CGRectMake(0, view.frame.origin.y, view.frame.size.width, view.frame.size.height)
            }
        } else {
            let offset = -(distanceOpenMenu * 0.2)
            if animated == true {
                animateViewSlide(menuContainer.view, toOffset: offset, toAlpha: 0.3, duration: 0.3, delay: 0.1, completion:nil)
            } else {
                menuContainer.view.frame = CGRectMake(offset, view.frame.origin.y, view.frame.size.width, view.frame.size.height)
            }
        }
    }
    
    private func animateViewSlide(view: UIView, toOffset: CGFloat, toAlpha: CGFloat, duration: NSTimeInterval, delay: NSTimeInterval, completion: ((Bool) -> Void)?) {
        
        UIView.animateWithDuration(duration, delay: delay, options: .CurveLinear, animations: { () -> Void in
            
            view.frame = CGRectMake(toOffset, view.frame.origin.y, view.frame.size.width, view.frame.size.height)
            }) { (finished: Bool) -> Void in
                completion?(finished)
        }
    }
}


