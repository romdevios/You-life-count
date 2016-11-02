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
    
    var percentTimer: Timer?
    var counterTimer: Timer?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        let settings = SettingsDelegate.sharedManager
        
        delegateIndex = settings.setDelegate(self)
        
        percentEnableChange(settings.percentIsEnable)
        counterEnableChange(settings.counterIsEnable)
        percentTypeChange(settings.percentType)
        counterTypeChange(settings.counterType)
        counterIntegerChange(settings.counterIsInteger)
        birthDayChage(settings.youBirthDay as Date? ?? Date())
        
        
        NSApp.setActivationPolicy(.regular) //show in dock
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


    override func awakeFromNib() {
        
        statusBarItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
        statusBarItem.menu = Menu
//        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(newTitle), userInfo: nil, repeats: true)
//        statusBarItem.title = "Yoo"
        statusBarItem.highlightMode = true
//        statusBarItem.image = giveStatusImageForDone(0)
        
//        statusBarItem.view?.addSubview(StatusView(frame: statusBarItem.view!.bounds))
//        addCounter()
//        addPercent()
    }
    
    @IBAction func Quit(_ sender: AnyObject?) {
        NSApp.terminate(nil)
    }
    
    
    fileprivate func addPercent() {
        statusBarPercent = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
        statusBarPercent?.menu = PercentMenu
//        statusBarPercent?.title = "Percent"
        statusBarPercent?.highlightMode = true
        statusBarPercent?.toolTip = "Percent"
        
        percentTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updatePercentTitle), userInfo: nil, repeats: true)
    }
    
    func updatePercentTitle() {
        if let img = giveStatusImageForDone(givePercentDone()) {
            statusBarPercent?.image = img
        } else {
            Quit(nil)
            relauchProgram()
        }
    }
    fileprivate func addCounter() {
        statusBarCounter = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
        statusBarCounter?.menu = CounterMenu
//        statusBarCounter?.title = "Counter"
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.alignment = .Left
//        statusBarCounter?.attributedTitle = NSAttributedString(string: "", attributes: [NSParagraphStyleAttributeName: paragraphStyle])
        
        
        
        let font = NSFont(name: "Helvetica Neue Bold", size: 15.0)
        attrsDictionary = [NSFontAttributeName: font as AnyObject]
        
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
    
    @IBAction func SelectedCounter(_ sender: NSMenuItem) {
        SettingsDelegate.sharedManager.setCounterTypeWithTag(sender.tag)
    }
    @IBAction func SelectedPercent(_ sender: NSMenuItem) {
        SettingsDelegate.sharedManager.setPercentTypeWithTag(sender.tag)
    }
    @IBAction func SelectedCounterType(_ sender: NSMenuItem) {
        SettingsDelegate.sharedManager.counterIsInteger = sender.tag == 0
    }
    
    
    
    func percentEnableChange(_ percentIsEnable: Bool) {
        if percentIsEnable {
            addPercent()
        } else {
            percentTimer?.invalidate()
            percentTimer = nil
            statusBarPercent = nil
        }
    }
    func counterEnableChange(_ counterIsEnable: Bool) {
        if counterIsEnable {
            addCounter()
        } else {
            counterTimer?.invalidate()
            counterTimer = nil
            statusBarCounter = nil
        }
    }
    func percentTypeChange(_ percentType: PercentType) {
        for item in PercentMenu.items {
            item.state = NSOffState
        }
        PercentMenu.items[percentType.rawValue].state = NSOnState
        
        updateStatusItem()
    }
    func counterTypeChange(_ counterType: CounterType) {
        for item in CounterMenu.items {
            item.state = NSOffState
        }
        CounterMenu.items[counterType.rawValue].state = NSOnState
        
        updateStatusItem()
    }
    func counterIntegerChange(_ counterIsInteger: Bool) {
        for item in CounterMenu.items {
            if item.title != "Type" {
                continue
            }
            for types in (item.submenu!.items) {
                types.state = counterIsInteger == (types.tag == 0) ? NSOnState : NSOffState
            }
        }
        
        updateCounterTimer()
        updateStatusItem()
    }
    func birthDayChage(_ birthDay: Date) {
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
            counterTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateCounterTitle), userInfo: nil, repeats: true)
            return
        }
        
        var fireDate = Date()
        let calendar = Calendar.current
        let destinitionDate = DateManager.sharedManager.getDestinitionTime()
        
        switch SettingsDelegate.sharedManager.counterType {
        case .year:
            var comp = (calendar as NSCalendar).components(.year, from: destinitionDate as Date)
            comp.year? += 1
            fireDate = calendar.date(from: comp)!
            
            interval = 86_400 //one day
            
        case .week:
            var firstDayOfWeekDate: NSDate?
            (calendar as NSCalendar).range(of: .weekOfYear, start: &firstDayOfWeekDate, interval: nil, for: destinitionDate)
            var comp = (calendar as NSCalendar).components([.year, .month, .day], from: firstDayOfWeekDate! as Date)
            comp.day? += 7
            fireDate = calendar.date(from: comp)!
            
            interval = 86_400 //one day
            
        case .day:
            var comp = (calendar as NSCalendar).components([.year, .month, .day], from: destinitionDate as Date)
            comp.day? += 1
            fireDate = calendar.date(from: comp)!
            
            interval = 86_400 //one day
            
        case .hour:
            var comp = (calendar as NSCalendar).components([.year, .month, .day, .hour], from: destinitionDate as Date)
            comp.hour? += 1
            fireDate = calendar.date(from: comp)!
            
            interval = 3_600 //one hour
            
        case .minute:
            var comp = (calendar as NSCalendar).components([.year, .month, .day, .hour, .minute], from: destinitionDate as Date)
            comp.minute? += 1
            fireDate = calendar.date(from: comp)!
            
            interval = 60 //one minute
            
        case .second:
            var comp = (calendar as NSCalendar).components([.year, .month, .day, .hour, .minute, .second], from: destinitionDate as Date)
            comp.second? += 1
            fireDate = calendar.date(from: comp)!
            
            interval = 0.2
        }
        fireDate = fireDate.addingTimeInterval(Date().timeIntervalSince(destinitionDate as Date))
        
        
        Timer.scheduledTimer(timeInterval: fireDate.timeIntervalSince(destinitionDate as Date), target: self, selector: #selector(setTimer), userInfo: nil, repeats: false)
    }
    var interval: TimeInterval = 1
    func setTimer() {
        counterTimer?.invalidate()
        counterTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(updateCounterTitle), userInfo: nil, repeats: true)
    }
    
    deinit {
        SettingsDelegate.sharedManager.removeDelegateWithIndex(delegateIndex ?? 0)
    }
    
    
    var pictureData: String? = nil
    func giveStatusImageForDone(_ done: CGFloat) -> NSImage? {
        let width = String(describing: 48 * done - (48 * done).truncatingRemainder(dividingBy: 0.01))
        
        if pictureData == nil {
            
            let file = "status.eps"
            let path = Bundle.main.path(forResource: file, ofType: nil) ?? file
            
            do {
                pictureData = try NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue) as String
            }
            catch {fatalError("Can't read from file")}
        }
        
        guard var data = pictureData else {
            return nil
        }
        
        let start = data.characters.index(data.startIndex, offsetBy: 2241)
        let endOld = data.index(start, offsetBy: 100)
        let oldLength = data.substring(with: start..<endOld).components(separatedBy: " ")[0].characters.count
        let end   = data.index(start, offsetBy: oldLength)
        data = data.replacingCharacters(in: start..<end, with: width)
        
        return NSImage(data: data.data(using: String.Encoding.utf8)!)
    }
    
    func givePercentDone() -> CGFloat {
        
        
        var done: TimeInterval = 0
        let destinitionDate = DateManager.sharedManager.getDestinitionTime()
        let calendar = Calendar.current
        switch SettingsDelegate.sharedManager.percentType {
        case .life:
            done = -(DateManager.sharedManager.youLifeCount ?? 0) / 2_209_032_000
        case .year:
            var comp = (calendar as NSCalendar).components(.year, from: destinitionDate as Date)
            let firstDayOfYearDate = calendar.date(from: comp)
            
            comp = (calendar as NSCalendar).components(.year, from: destinitionDate as Date)
            comp.year? += 1
            let lastDayOfYearDate = calendar.date(from: comp)
            
            let secondInDestenitionYear = lastDayOfYearDate?.timeIntervalSince(firstDayOfYearDate!)
            
            done = destinitionDate.timeIntervalSince(firstDayOfYearDate!) / secondInDestenitionYear!
        case .month:
            let dayInDestenitionMonth = (calendar as NSCalendar).range(of: NSCalendar.Unit.day, in: NSCalendar.Unit.month, for: destinitionDate as Date)
            
            let comp = (calendar as NSCalendar).components([.year, .month], from: destinitionDate as Date)
            let firstDayOfMonthDate = calendar.date(from: comp)
            
            done = destinitionDate.timeIntervalSince(firstDayOfMonthDate!) / Double(dayInDestenitionMonth.length * 86_400)
        case .week:
            var firstDayOfWeekDate: NSDate?
            (calendar as NSCalendar).range(of: .weekOfYear, start: &firstDayOfWeekDate, interval: nil, for: destinitionDate)
            
            var comp = (calendar as NSCalendar).components([.year, .month, .day], from: firstDayOfWeekDate! as Date)
            comp.day? += 7
            let lastDayOfWeekDate = calendar.date(from: comp)
            
            let secondInDestenitionWeek = lastDayOfWeekDate?.timeIntervalSince(firstDayOfWeekDate! as Date)
            
            done = destinitionDate.timeIntervalSince(firstDayOfWeekDate! as Date) / secondInDestenitionWeek!
        case .day:
            let firstSecondOfDayDate = Calendar.current.startOfDay(for: destinitionDate)
            
            let secondInDay: Double = 86_400 //one day
            
            done = (destinitionDate.timeIntervalSince(firstSecondOfDayDate) - Double(NSTimeZone.system.secondsFromGMT())) / secondInDay
        }
        return CGFloat(done)
    }
    
    func giveCounterText() -> String {
        
        let interval = -(DateManager.sharedManager.youLifeCount ?? 0)
        var div = 1
        switch SettingsDelegate.sharedManager.counterType {
        case .year:
            div = 31_557_600
        case .week:
            div = 604_800
        case .day:
            div = 86_400
        case .hour:
            div = 3_600
        case .minute:
            div = 60
        default:
            div = 1
        }
        
        var str = ""
        if SettingsDelegate.sharedManager.counterIsInteger {
            str = String(Int(interval)/div)
        } else {
            let d = interval / Double(div)
            str = String(d - d.truncatingRemainder(dividingBy: 0.00001))
            for _ in 0..<(5 - str.components(separatedBy: ".")[1].characters.count) {
                str += "0"
            }
        }
        
        return str
    }
    
    func relauchProgram() {
        let task = Process()
        task.launchPath = "/bin/sh"
        task.arguments = ["-c", "open \"\(Bundle.main.bundlePath)\""]
        task.launch()
        NSApplication.shared().terminate(nil)
    }
    
}

