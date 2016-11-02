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
    fileprivate init() {}
    
    var delegates = [ChangeValues]()
    func removeDelegateWithIndex(_ index: Int) {
        delegates.remove(at: index)
    }
    func setDelegate(_ delegate: ChangeValues) -> Int {
        delegates.append(delegate)
        return delegates.count - 1
    }
    
    var youBirthDay: Date? {
        set {
            UserDefaults.standard.set(newValue, forKey: "birthDay")
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.object(forKey: "birthDay") as? Date
        }
    }
    var percentIsEnable: Bool {
        set {
            let def = UserDefaults.standard
            def.set(newValue, forKey: "percentIsHidden")
            def.synchronize()
            for n in delegates {
                n.percentEnableChange(newValue)
            }
        }
        get {
            return UserDefaults.standard.bool(forKey: "percentIsHidden")
        }
    }
    var counterIsEnable: Bool {
        set {
            let def = UserDefaults.standard
            def.set(newValue, forKey: "counterIsHidden")
            def.synchronize()
            for n in delegates {
                n.counterEnableChange(newValue)
            }
        }
        get {
            return UserDefaults.standard.bool(forKey: "counterIsHidden")
        }
    }
    var percentType: PercentType {
        set {
            let def = UserDefaults.standard
            def.set(newValue.rawValue, forKey: "percentType")
            def.synchronize()
            for n in delegates {
                n.percentTypeChange(newValue)
            }
        }
        get {
            return PercentType(rawValue: UserDefaults.standard.integer(forKey: "percentType")) ?? .life
        }
    }
    func setPercentTypeWithTag(_ tag: Int) {
        if let type = PercentType(rawValue: tag) {
            percentType = type
        }
    }
    var counterType: CounterType {
        set {
            let def = UserDefaults.standard
            def.set(newValue.rawValue, forKey: "counterType")
            def.synchronize()
            for n in delegates {
                n.counterTypeChange(newValue)
            }
        }
        get {
            return CounterType(rawValue: UserDefaults.standard.integer(forKey: "counterType"))!
        }
    }
    func setCounterTypeWithTag(_ tag: Int) {
        if let type = CounterType(rawValue: tag) {
            counterType = type
        }
        
    }
    var counterIsInteger: Bool {
        set {
            let def = UserDefaults.standard
            def.set(newValue, forKey: "counterIsInteger")
            def.synchronize()
            for n in delegates {
                n.counterIntegerChange(newValue)
            }
        }
        get {
            if UserDefaults.standard.object(forKey: "counterIsInteger") == nil {
                return true
            }
            return UserDefaults.standard.bool(forKey: "counterIsInteger")
        }
    }
    
    
    
    
}


protocol ChangeValues {
    func percentEnableChange(_ percentIsEnable: Bool)
    func counterEnableChange(_ counterIsEnable: Bool)
    func percentTypeChange(_ percentType: PercentType)
    func counterTypeChange(_ counterType: CounterType)
    func counterIntegerChange(_ counterIsInteger: Bool)
    func birthDayChage(_ birthDay: Date)
}

enum PercentType: Int {
    case life
    case year
    case month
    case week
    case day
}

enum CounterType: Int {
    case year
    case week
    case day
    case hour
    case minute
    case second
}



