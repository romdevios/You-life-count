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
    private init() {}
    
    var youLifeCount: Double? {
        guard let birthDay = SettingsDelegate.sharedManager.youBirthDay else {
            return nil
        }
        return birthDay.timeIntervalSinceDate(getDestinitionTime())
    }
    
    func getDestinitionTime() -> NSDate {
        let sourceDate = NSDate()
        
        let sourceTimeZone = NSTimeZone(abbreviation: "GMT")
        let destinationTimeZone = NSTimeZone.systemTimeZone
        
        let sourceGMTOffset = sourceTimeZone!.secondsFromGMTForDate(sourceDate)
        let destinationGMTOffset = destinationTimeZone().secondsFromGMTForDate(sourceDate)
        let interval = Double(destinationGMTOffset - sourceGMTOffset)
        
        return NSDate(timeInterval: interval, sinceDate:sourceDate)
    }
    
}
