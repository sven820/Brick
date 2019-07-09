//
//  ZXAlertUntilHelper.swift
//  XZXTeacherPaper
//
//  Created by 靳小飞 on 2018/6/13.
//  Copyright © 2018年 iflytek. All rights reserved.
//

import Foundation

public enum ZXAlertUntilAnimateType: Int{
    case none, fromRight, fadeIn
}
// MARK: alert
public protocol ZXAlertUntil {}
//
public extension ZXAlertUntil where Self: NSObject {
    @discardableResult
    func systemAlert(title: String, message: String, preferredStyle: UIAlertController.Style = .alert, actions: [UIAlertAction]? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        if let actionArr = actions {
            for action in actionArr {
                alertController.addAction(action)
            }
        }
        if self.isKind(of: UIViewController.classForCoder()) {
            (self as? UIViewController)?.present(alertController, animated: true, completion: nil)
        }else {
            var topRootVc = UIApplication.shared.keyWindow?.rootViewController
            while ((topRootVc?.presentedViewController) != nil) {
                topRootVc = topRootVc?.presentedViewController
            }
            topRootVc?.present(alertController, animated: true, completion: nil)
        }
        return alertController
    }
    func alert(_ view: UIView, frame: CGRect?, type: ZXAlertUntilAnimateType = .fromRight, emptyClickDismiss: Bool = true) {
        self.animateType = type
        let windows = UIApplication.shared.windows
        for window in windows {
            let windowOnMainScreen = window.screen == UIScreen.main
            let windowIsVisible = !window.isHidden && window.alpha > 0
            let windowLevelNormal = window.windowLevel == UIWindow.Level.normal
            
            if !(windowOnMainScreen && windowIsVisible && windowLevelNormal) {break}
            
            alert(view, on: window, frame: frame, type: type, emptyClickDismiss: emptyClickDismiss)
            break
        }
    }
    func alert(_ view: UIView, on container: UIView, frame: CGRect?, type: ZXAlertUntilAnimateType = .fromRight, emptyClickDismiss: Bool = true) {
        self.animateType = type
        
        let bgView = UIControl(frame: container.bounds)
        bgView.backgroundColor = UIColor.clear
        if emptyClickDismiss {
            bgView.addTarget(self, action: #selector(hideAlert(_:)), for: UIControl.Event.touchDown)
        }
        container.addSubview(bgView)
        bgView.addSubview(view)
        view.frame = frame ?? container.bounds
        //right flip
        if type == .fromRight {
            view.transform = CGAffineTransform(translationX: view.bounds.width, y: 0)
            bgView.layoutIfNeeded()
            UIView.animate(withDuration: 0.25, animations: {
                view.transform = .identity
                bgView.layoutIfNeeded()
            })
        }else if type == .fadeIn {
            view.alpha = 0.1
            bgView.layoutIfNeeded()
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseIn, animations: {
                view.alpha = 1.0
                bgView.layoutIfNeeded()
            })
        }
    }
    func hideAlert(theAlertView: UIView) {
        _hideAlert(theAlertView: theAlertView)
    }
}
fileprivate var kZXAlertUntilAnimateTypeKey = 1
fileprivate extension NSObject {
    var animateType: ZXAlertUntilAnimateType {
        set {
            objc_setAssociatedObject(self, &kZXAlertUntilAnimateTypeKey, newValue.rawValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            let typeValue = objc_getAssociatedObject(self, &kZXAlertUntilAnimateTypeKey) as? Int
            let type = ZXAlertUntilAnimateType(rawValue: typeValue ?? 0)
            return  type ?? .none
        }
    }
    @objc func hideAlert(_ sender: UIView) {
        sender.subviews.forEach { _hideAlert(theAlertView: $0) }
    }
    func _hideAlert(theAlertView: UIView) {
        if animateType == .fromRight {
            UIView.animate(withDuration: 0.25, animations: {
                theAlertView.transform =  CGAffineTransform(translationX: theAlertView.bounds.width, y: 0)
                theAlertView.superview?.layoutIfNeeded()
            }, completion: { (finished) -> Void in
                theAlertView.transform = .identity
                theAlertView.superview?.removeFromSuperview()
                theAlertView.removeFromSuperview()
            })
        }else if animateType == .fadeIn {
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseIn, animations: {
                theAlertView.alpha = 0.1
                theAlertView.layoutIfNeeded()
            }, completion: { (finished) -> Void in
                theAlertView.superview?.removeFromSuperview()
                theAlertView.removeFromSuperview()
                theAlertView.alpha = 1.0
            })
        }else {
            theAlertView.superview?.removeFromSuperview()
            theAlertView.removeFromSuperview()
        }
    }
}
