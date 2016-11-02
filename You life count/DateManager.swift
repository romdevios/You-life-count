//
//  DateManager.swift
//  You life count
//
//  Created by Roman Filippov on 13/04/16.
//  Copyright © 2016 Roman. All rights reserved.
//

import Foundation

class DateManager {
    
    static let sharedManager = DateManager()
    fileprivate init() {}
    
    var youLifeCount: TimeInterval? {
        guard let birthDay = SettingsDelegate.sharedManager.youBirthDay else {
            return nil
        }
        return birthDay.timeIntervalSince(getDestinitionTime())
    }
    
    func getDestinitionTime() -> Date {
        let sourceDate = Date()
        
        let sourceTimeZone = TimeZone(abbreviation: "GMT")
        let destinationTimeZone = TimeZone.current
        
        let sourceGMTOffset = sourceTimeZone!.secondsFromGMT(for: sourceDate)
        let destinationGMTOffset = destinationTimeZone.secondsFromGMT(for: sourceDate)
        let interval = Double(destinationGMTOffset - sourceGMTOffset)
        
        return Date(timeInterval: interval, since:sourceDate)
    }
    
}
