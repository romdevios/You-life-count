//
//  SettingsDelegate.swift
//  You life count
//
//  Created by Roman Filippov on 13/04/16.
//  Copyright © 2016 Roman. All rights reserved.
//

import Foundation

class SettingsDelegate {
    
    static let sharedManager = SettingsDelegate()
    private init() {}
    
    var delegates = [ChangeValues]()
    func removeDelegateWithIndex(index: Int) {
        delegates.removeAtIndex(index)
    }
    func setDelegate(delegate: ChangeValues) -> Int {
        delegates.append(delegate)
        return delegates.count - 1
    }
    
    var youBirthDay: NSDate? {
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "birthDay")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        get {
            return NSUserDefaults.standardUserDefaults().objectForKey("birthDay") as? NSDate
        }
    }
    var percentIsEnable: Bool {
        set {
            let def = NSUserDefaults.standardUserDefaults()
            def.setBool(newValue, forKey: "percentIsHidden")
            def.synchronize()
            for n in delegates {
                n.percentEnableChange(newValue)
            }
        }
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey("percentIsHidden")
        }
    }
    var counterIsEnable: Bool {
        set {
            let def = NSUserDefaults.standardUserDefaults()
            def.setBool(newValue, forKey: "counterIsHidden")
            def.synchronize()
            for n in delegates {
                n.counterEnableChange(newValue)
            }
        }
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey("counterIsHidden")
        }
    }
    var percentType: PercentType {
        set {
            let def = NSUserDefaults.standardUserDefaults()
            def.setInteger(newValue.rawValue, forKey: "percentType")
            def.synchronize()
            for n in delegates {
                n.percentTypeChange(newValue)
            }
        }
        get {
            return PercentType(rawValue: NSUserDefaults.standardUserDefaults().integerForKey("percentType")) ?? .Life
        }
    }
    func setPercentTypeWithTag(tag: Int) {
        if let type = PercentType(rawValue: tag) {
            percentType = type
        }
    }
    var counterType: CounterType {
        set {
            let def = NSUserDefaults.standardUserDefaults()
            def.setInteger(newValue.rawValue, forKey: "counterType")
            def.synchronize()
            for n in delegates {
                n.counterTypeChange(newValue)
            }
        }
        get {
            return CounterType(rawValue: NSUserDefaults.standardUserDefaults().integerForKey("counterType"))!
        }
    }
    func setCounterTypeWithTag(tag: Int) {
        if let type = CounterType(rawValue: tag) {
            counterType = type
        }
        
    }
    var counterIsInteger: Bool {
        set {
            let def = NSUserDefaults.standardUserDefaults()
            def.setBool(newValue, forKey: "counterIsInteger")
            def.synchronize()
            for n in delegates {
                n.counterIntegerChange(newValue)
            }
        }
        get {
            if NSUserDefaults.standardUserDefaults().objectForKey("counterIsInteger") == nil {
                return true
            }
            return NSUserDefaults.standardUserDefaults().boolForKey("counterIsInteger")
        }
    }
    
    
    
    
}


protocol ChangeValues {
    func percentEnableChange(percentIsEnable: Bool)
    func counterEnableChange(counterIsEnable: Bool)
    func percentTypeChange(percentType: PercentType)
    func counterTypeChange(counterType: CounterType)
    func counterIntegerChange(counterIsInteger: Bool)
    func birthDayChage(birthDay: NSDate)
}

enum PercentType: Int {
    case Life
    case Year
    case Mounth
    case Week
    case Day
}

enum CounterType: Int {
    case Year
    case Week
    case Day
    case Hour
    case Minute
    case Second
}



