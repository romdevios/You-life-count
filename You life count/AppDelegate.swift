//
//  AppDelegate.swift
//  You life count
//
//  Created by Roman Filippov on 13/04/16.
//  Copyright © 2016 Roman. All rights reserved.
//

import Cocoa


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, ChangeValues {

    
    @IBOutlet weak var Menu: NSMenu!
    @IBOutlet weak var PercentMenu: NSMenu!
    @IBOutlet weak var CounterMenu: NSMenu!
    var statusBarItem : NSStatusItem!
    var statusBarPercent : NSStatusItem?
    var statusBarCounter : NSStatusItem?
    var delegateIndex: Int?
    
    var percentTimer: NSTimer?
    var counterTimer: NSTimer?

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        
        let settings = SettingsDelegate.sharedManager
        
        delegateIndex = settings.setDelegate(self)
        
        percentEnableChange(settings.percentIsEnable)
        counterEnableChange(settings.counterIsEnable)
        percentTypeChange(settings.percentType)
        counterTypeChange(settings.counterType)
        counterIntegerChange(settings.counterIsInteger)
        birthDayChage(settings.youBirthDay ?? NSDate())
        
        
        NSApp.setActivationPolicy(.Regular) //show in dock
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


    override func awakeFromNib() {
        
        statusBarItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
        statusBarItem.menu = Menu
//        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(newTitle), userInfo: nil, repeats: true)
//        statusBarItem.title = "Yoo"
        statusBarItem.highlightMode = true
//        statusBarItem.image = giveStatusImageForDone(0)
        
//        addCounter()
//        addPercent()
    }
    
    @IBAction func Quit(sender: AnyObject) {
        NSApp.terminate(nil)
    }
    
    
    private func addPercent() {
        statusBarPercent = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
        statusBarPercent?.menu = PercentMenu
//        statusBarPercent?.title = "Percent"
        statusBarPercent?.highlightMode = true
        statusBarPercent?.toolTip = "Percent"
        
        percentTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(updatePercentTitle), userInfo: nil, repeats: true)
    }
    
    var n = 0
    func updatePercentTitle() {
        if let img = giveStatusImageForDone(givePercentDone()) {
            statusBarPercent?.image = img
        } else if n < 20 {
            n += 1
            print("try №" + String(n))
        } else {
            fatalError("image not found")
        }
    }
    private func addCounter() {
        statusBarCounter = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
        statusBarCounter?.menu = CounterMenu
//        statusBarCounter?.title = "Counter"
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.alignment = .Left
//        statusBarCounter?.attributedTitle = NSAttributedString(string: "", attributes: [NSParagraphStyleAttributeName: paragraphStyle])
        
        
        
        let font = NSFont(name: "Helvetica Neue Bold", size: 15.0)
        attrsDictionary = [NSFontAttributeName: font as! AnyObject]
        
        statusBarCounter?.highlightMode = true
        statusBarCounter?.toolTip = "Counter"
        
        updateCounterTimer()
    }
    var attrsDictionary = [String: AnyObject]()
    func updateCounterTitle() {
        let newText = giveCounterText()
        
        let attrString = NSAttributedString(string: newText, attributes: attrsDictionary)
        statusBarCounter?.attributedTitle = attrString
        
//        statusBarCounter?.title = newText
    }
    
    @IBAction func SelectedCounter(sender: NSMenuItem) {
        SettingsDelegate.sharedManager.setCounterTypeWithTag(sender.tag)
    }
    @IBAction func SelectedPercent(sender: NSMenuItem) {
        SettingsDelegate.sharedManager.setPercentTypeWithTag(sender.tag)
    }
    @IBAction func SelectedCounterType(sender: NSMenuItem) {
        SettingsDelegate.sharedManager.counterIsInteger = sender.tag == 0
    }
    
    
    
    func percentEnableChange(percentIsEnable: Bool) {
        if percentIsEnable {
            addPercent()
        } else {
            percentTimer?.invalidate()
            percentTimer = nil
            statusBarPercent = nil
        }
    }
    func counterEnableChange(counterIsEnable: Bool) {
        if counterIsEnable {
            addCounter()
        } else {
            counterTimer?.invalidate()
            counterTimer = nil
            statusBarCounter = nil
        }
    }
    func percentTypeChange(percentType: PercentType) {
        for item in PercentMenu.itemArray {
            item.state = NSOffState
        }
        PercentMenu.itemArray[percentType.rawValue].state = NSOnState
        
        updateStatusItem()
    }
    func counterTypeChange(counterType: CounterType) {
        for item in CounterMenu.itemArray {
            item.state = NSOffState
        }
        CounterMenu.itemArray[counterType.rawValue].state = NSOnState
        
        updateStatusItem()
    }
    func counterIntegerChange(counterIsInteger: Bool) {
        for item in CounterMenu.itemArray {
            if item.title != "Type" {
                continue
            }
            for types in (item.submenu!.itemArray) {
                types.state = counterIsInteger == (types.tag == 0) ? NSOnState : NSOffState
            }
        }
        
        updateCounterTimer()
        updateStatusItem()
    }
    func birthDayChage(birthDay: NSDate) {
        updateStatusItem()
    }
    
    func updateStatusItem() {
        if statusBarCounter != nil {
            updateCounterTitle()
        }
        if statusBarPercent != nil {
            updatePercentTitle()
        }
    }
    func updateCounterTimer() {
        counterTimer?.invalidate()
        if !SettingsDelegate.sharedManager.counterIsInteger {
            counterTimer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: #selector(updateCounterTitle), userInfo: nil, repeats: true)
            return
        }
        
        var fireDate = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let destinitionDate = DateManager.sharedManager.getDestinitionTime()
        switch SettingsDelegate.sharedManager.counterType {
        case .Year:
            let comp = calendar.components(.Year, fromDate: destinitionDate)
            comp.year += 1
            fireDate = calendar.dateFromComponents(comp)!
            
            interval = 86_400 //one day
            
        case .Week:
            var firstDayOfWeekDate: NSDate?
            calendar.rangeOfUnit(.WeekOfYear, startDate: &firstDayOfWeekDate, interval: nil, forDate: destinitionDate)
            let comp = calendar.components([.Year, .Month, .Day], fromDate: firstDayOfWeekDate!)
            comp.day += 7
            fireDate = calendar.dateFromComponents(comp)!
            
            interval = 86_400 //one day
            
        case .Day:
            let comp = calendar.components([.Year, .Month, .Day], fromDate: destinitionDate)
            comp.day += 1
            fireDate = calendar.dateFromComponents(comp)!
            
            interval = 86_400 //one day
            
        case .Hour:
            let comp = calendar.components([.Year, .Month, .Day, .Hour], fromDate: destinitionDate)
            comp.hour += 1
            fireDate = calendar.dateFromComponents(comp)!
            
            interval = 3_600 //one hour
            
        case .Minute:
            let comp = calendar.components([.Year, .Month, .Day, .Hour, .Minute], fromDate: destinitionDate)
            comp.minute += 1
            fireDate = calendar.dateFromComponents(comp)!
            
            interval = 60 //one minute
            
        case .Second:
            let comp = calendar.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: destinitionDate)
            comp.second += 1
            fireDate = calendar.dateFromComponents(comp)!
            
            interval = 0.2
        }
        fireDate = fireDate.dateByAddingTimeInterval(NSDate().timeIntervalSinceDate(destinitionDate))
        print(fireDate, "\n", NSDate(), "\n", NSDate().timeIntervalSinceDate(destinitionDate))
        
        
        NSTimer.scheduledTimerWithTimeInterval(fireDate.timeIntervalSinceDate(destinitionDate), target: self, selector: #selector(setTimer), userInfo: nil, repeats: false)
    }
    var interval: NSTimeInterval = 1
    func setTimer() {
        counterTimer?.invalidate()
        counterTimer = NSTimer.scheduledTimerWithTimeInterval(interval, target: self, selector: #selector(updateCounterTitle), userInfo: nil, repeats: true)
    }
    
    deinit {
        SettingsDelegate.sharedManager.removeDelegateWithIndex(delegateIndex ?? 0)
    }
    
    
    var firstPath: String!
    func giveStatusImageForDone(done: CGFloat) -> NSImage? {
        let width = String(48 * done - 48 * done % 0.01)
        
        let file = "status.eps"
        
        var path = NSBundle.mainBundle().pathForResource(file, ofType: nil) ?? file
        let startPath = path.startIndex
        let endPath = startPath.advancedBy(path.characters.count - file.characters.count)
        path = path.substringWithRange(startPath..<endPath)
        
        do {
            
            //reading
            var data = String()
            data = try NSString(contentsOfFile: path + file, encoding: NSUTF8StringEncoding) as String
        
            let start = data.startIndex.advancedBy(2241)
            let endOld = start.advancedBy(100)
            let oldLength = data.substringWithRange(start..<endOld).componentsSeparatedByString(" ")[0].characters.count
            let end   = start.advancedBy(oldLength)
            data = data.stringByReplacingCharactersInRange(start..<end, withString: width)
            
            //writing
            try data.writeToFile(path + file, atomically: false, encoding: NSUTF8StringEncoding)

        }
        catch {fatalError("Can't write in file")}
        
        return NSImage(contentsOfFile: path + file)
    }
    
    func givePercentDone() -> CGFloat {
        
        
        var done: NSTimeInterval = 0
        let destinitionDate = DateManager.sharedManager.getDestinitionTime()
        let calendar = NSCalendar.currentCalendar()
        switch SettingsDelegate.sharedManager.percentType {
        case .Life:
            done = -(DateManager.sharedManager.youLifeCount ?? 0) / 2_209_032_000
        case .Year:
            var comp = calendar.components(.Year, fromDate: destinitionDate)
            let firstDayOfYearDate = calendar.dateFromComponents(comp)
            
            comp = calendar.components(.Year, fromDate: destinitionDate)
            comp.year += 1
            let lastDayOfYearDate = calendar.dateFromComponents(comp)
            
            let secondInDestenitionYear = lastDayOfYearDate?.timeIntervalSinceDate(firstDayOfYearDate!)
            
            done = destinitionDate.timeIntervalSinceDate(firstDayOfYearDate!) / secondInDestenitionYear!
        case .Month:
            let dayInDestenitionMonth = calendar.rangeOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.Month, forDate: destinitionDate)
            
            let comp = calendar.components([.Year, .Month], fromDate: destinitionDate)
            let firstDayOfMonthDate = calendar.dateFromComponents(comp)
            
            done = destinitionDate.timeIntervalSinceDate(firstDayOfMonthDate!) / Double(dayInDestenitionMonth.length * 86_400)
        case .Week:
            var firstDayOfWeekDate: NSDate?
            calendar.rangeOfUnit(.WeekOfYear, startDate: &firstDayOfWeekDate, interval: nil, forDate: destinitionDate)
            
            let comp = calendar.components([.Year, .Month, .Day], fromDate: firstDayOfWeekDate!)
            comp.day += 7
            let lastDayOfWeekDate = calendar.dateFromComponents(comp)
            
            let secondInDestenitionWeek = lastDayOfWeekDate?.timeIntervalSinceDate(firstDayOfWeekDate!)
            
            done = destinitionDate.timeIntervalSinceDate(firstDayOfWeekDate!) / secondInDestenitionWeek!
        case .Day:
            let comp = calendar.components([.Year, .Month, .Day], fromDate: destinitionDate)
            let firstSecondOfDayDate = calendar.dateFromComponents(comp)
            
            comp.day += 1
            let lastSecondOfDayDate = calendar.dateFromComponents(comp)
            
            let secondInDestenitionDay = lastSecondOfDayDate?.timeIntervalSinceDate(firstSecondOfDayDate!)
            
            done = destinitionDate.timeIntervalSinceDate(firstSecondOfDayDate!) / secondInDestenitionDay!
        }
        return CGFloat(done)
    }
    
    func giveCounterText() -> String {
        
        let interval = -(DateManager.sharedManager.youLifeCount ?? 0)
        var div = 1
        switch SettingsDelegate.sharedManager.counterType {
        case .Year:
            div = 31_557_600
        case .Week:
            div = 604_800
        case .Day:
            div = 86_400
        case .Hour:
            div = 3_600
        case .Minute:
            div = 60
        default:
            div = 1
        }
        
        var str = ""
        if SettingsDelegate.sharedManager.counterIsInteger {
            str = String(Int(interval)/div)
        } else {
            let d = interval / Double(div)
            str = String(d - d % 0.00001)
            for _ in 0..<(5 - str.componentsSeparatedByString(".")[1].characters.count) {
                str += "0"
            }
        }
        
        return str
    }
    
}

