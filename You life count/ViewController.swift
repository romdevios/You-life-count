//
//  ViewController.swift
//  You life count
//
//  Created by Roman Filippov on 13/04/16.
//  Copyright © 2016 Roman. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, ChangeValues {
    
    @IBOutlet weak var LifePercents: NSButton!
    @IBOutlet weak var YearPercents: NSButton!
    @IBOutlet weak var MounthPercents: NSButton!
    @IBOutlet weak var WeekPercents: NSButton!
    @IBOutlet weak var DayPercents: NSButton!
    
    @IBOutlet weak var YearCounter: NSButton!
    @IBOutlet weak var WeekCounter: NSButton!
    @IBOutlet weak var DayCounter: NSButton!
    @IBOutlet weak var HourCounter: NSButton!
    @IBOutlet weak var MinuteCounter: NSButton!
    @IBOutlet weak var SecondCounter: NSButton!
    
    var percents = [NSButton]()
    var counters = [NSButton]()
    
    @IBOutlet weak var BirthDay: NSDatePicker!
    @IBOutlet weak var PercentEnable: NSButton!
    @IBOutlet weak var CounterEnable: NSButton!
    @IBOutlet weak var TypeOfCounter: NSSegmentedControl!
    
    var indexDelegate: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        percents = [LifePercents, YearPercents, MounthPercents, WeekPercents, DayPercents]
        counters = [YearCounter, WeekCounter, DayCounter, HourCounter, MinuteCounter, SecondCounter]
        
        let settings = SettingsDelegate.sharedManager
        
        indexDelegate = settings.setDelegate(self)
        
        percentEnableChange(settings.percentIsEnable)
        counterEnableChange(settings.counterIsEnable)
        percentTypeChange(settings.percentType)
        counterTypeChange(settings.counterType)
        counterIntegerChange(settings.counterIsInteger)
        birthDayChage(settings.youBirthDay ?? NSDate())
        
        
    }
    
    deinit {
        SettingsDelegate.sharedManager.removeDelegateWithIndex(indexDelegate ?? 0)
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func PercentsChange(sender: NSButton) {
        SettingsDelegate.sharedManager.setPercentTypeWithTag(sender.tag)
    }
    
    @IBAction func CounterChenged(sender: NSButton) {
        SettingsDelegate.sharedManager.setCounterTypeWithTag(sender.tag)
    }
    
    @IBAction func TypeOfCounterChanged(sender: NSSegmentedControl) {
        SettingsDelegate.sharedManager.counterIsInteger = sender.selectedSegment == 0
    }
    
    @IBAction func AddWidget(sender: NSButton) {
        if sender.tag == 0 {
            SettingsDelegate.sharedManager.percentIsEnable = sender.state == NSOnState
        } else if sender.tag == 1 {
            SettingsDelegate.sharedManager.counterIsEnable = sender.state == NSOnState
        }
    }
    
    @IBAction func NewBirthDay(sender: NSDatePicker) {
        SettingsDelegate.sharedManager.youBirthDay = sender.dateValue
    }
    
    
    
    func percentEnableChange(percentIsEnable: Bool) {
        PercentEnable.state = percentIsEnable ? NSOnState : NSOffState
    }
    func counterEnableChange(counterIsEnable: Bool) {
        CounterEnable.state = counterIsEnable ? NSOnState : NSOffState
    }
    func percentTypeChange(percentType: PercentType) {
        for button in percents {
            button.state = NSOffState
        }
        percents[percentType.rawValue].state = NSOnState
    }
    func counterTypeChange(counterType: CounterType) {
        for button in counters {
            button.state = NSOffState
        }
        counters[counterType.rawValue].state = NSOnState
    }
    func counterIntegerChange(counterIsInteger: Bool) {
        TypeOfCounter.selectedSegment = counterIsInteger ? 0 : 1
    }
    func birthDayChage(birthDay: NSDate) {
        BirthDay.dateValue = birthDay
    }
    
    
}

