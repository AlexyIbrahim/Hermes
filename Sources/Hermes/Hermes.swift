//
//  Hermes.swift
//  Story Crafter
//
//  Created by Alexy Ibrahim on 7/28/20.
//  Copyright © 2020 Alexy Ibrahim. All rights reserved.
//

import UIKit

// 🌿 shortcuts
public let AINotificationCenter = MOTG
public let MOTG = Hermes.self

public class Hermes: NSObject {
    static var scrolls: [Hermes] = [Hermes]()
    
    private var observer: Any!
    private var scrollName: Notification.Name!
    private var scrollReceivedCallback:((_ notification:Notification, _ userInfo: [AnyHashable: Any]?) -> ())?
    
    @objc private func scrollReceived(notification: Notification) {
        self.scrollReceivedCallback?(notification, notification.userInfo)
    }
}

// MARK: - public methods
extension Hermes {
    // MARK: - notify
    public final class func notify(notificationStringName: String, fromObject object: Any? = nil, userInfo: [AnyHashable: Any]? = nil) {
        self.notify(notificationName: Notification.Name(notificationStringName), fromObject: object, userInfo: userInfo)
    }
    public final class func notify(notificationName: Notification.Name, fromObject object: Any? = nil, userInfo: [AnyHashable: Any]? = nil) {
        NotificationCenter.default.post(name: notificationName, object: object, userInfo: userInfo)
    }

    
    // MARK: - keep an eye
    public final class func keepAnEyeOn(notificationStringName: String, _ observer: Any, fromObject object: Any? = nil, block: @escaping (_ notification:Notification, _ userInfo: [AnyHashable: Any]?) -> ()) {
        self.keepAnEyeOn(notificationName: Notification.Name(notificationStringName), observer, fromObject: object, block: block)
    }
    public final class func keepAnEyeOn(notificationName: Notification.Name, _ observer: Any, fromObject object: Any? = nil, block: @escaping (_ notification:Notification, _ userInfo: [AnyHashable: Any]?) -> ()) {
        let hermes = Hermes()
        hermes.scrollReceivedCallback = block
        hermes.observer = observer
        hermes.scrollName = notificationName
        NotificationCenter.default.addObserver(hermes, selector: #selector(Hermes.scrollReceived), name: notificationName, object: nil)

        Hermes.scrolls.append(hermes)
    }
    
    // MARK: - remove
    public final class func removeObserver(observer: Any) {
        let scrolls = Hermes.scrolls.filter { (scroll) -> Bool in
            if (scroll.observer as! AnyHashable) == (observer as! AnyHashable) {
                return true
            }
            return false
        }
        
        scrolls.forEach {
            NotificationCenter.default.removeObserver($0)
        }
    }
    
    
    public final class func removeObserver(observer: Any, forNotificationStringName notificationStringName: String) {
        Hermes.removeObserver(observer:observer, forNotificationName: Notification.Name(notificationStringName))
    }
    public final class func removeObserver(observer: Any, forNotificationName notificationName: Notification.Name) {
        let scrolls = Hermes.scrolls.filter { (scroll) -> Bool in
            if (scroll.observer as! AnyHashable) == (observer as! AnyHashable)
                && scroll.scrollName == notificationName {
                return true
            }
            return false
        }
        
        scrolls.forEach {
            NotificationCenter.default.removeObserver($0, name: notificationName, object: nil)
            Hermes.scrolls.remove(object: $0)
        }
    }
    
    public final class func removeAllObservers() {
        Hermes.scrolls.forEach {
            NotificationCenter.default.removeObserver($0.observer!)
        }
        Hermes.scrolls.removeAll()
    }
}

private extension Array where Iterator.Element : Equatable {
    mutating func remove(object: Element) {
        guard let index = firstIndex(of: object) else {return}
        remove(at: index)
    }
}
