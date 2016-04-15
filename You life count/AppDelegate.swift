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
    
    func newTitle() {
//        let formatter = NSDateFormatter()
//        formatter.setLocalizedDateFormatFromTemplate("hh:mm:ss")
//        let date = formatter.stringFromDate(NSDate())
//        statusBarItem.title = date
        n += 0.15
        n -= n > 1 ? n : 0
        print(n)
//        statusBarItem.image = giveStatusImageForDone(n)
    }
    
    @IBAction func Quit(sender: AnyObject) {
        NSApp.terminate(nil)
    }
    
    
    private func addPercent() {
        statusBarPercent = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
        statusBarPercent?.menu = PercentMenu
        statusBarPercent?.title = "Percent"
        statusBarPercent?.highlightMode = true
        statusBarPercent?.toolTip = "Percent"  
        
//        percentTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(someMake), userInfo: nil, repeats: true)
    }
    var n: CGFloat = 0
    private func addCounter() {
        statusBarCounter = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
        statusBarCounter?.menu = CounterMenu
        statusBarCounter?.title = "Counter"
        statusBarCounter?.highlightMode = true
        statusBarCounter?.toolTip = "Counter"
        
//        counterTimer = NSTimer(timeInterval: <#T##NSTimeInterval#>, target: self, selector: <#T##Selector#>, userInfo: nil, repeats: true)
    }
    
    
    func percentEnableChange(percentIsEnable: Bool) {
        if percentIsEnable {
            addPercent()
        } else {
            percentTimer = nil
            statusBarPercent = nil
        }
    }
    func counterEnableChange(counterIsEnable: Bool) {
        if counterIsEnable {
            addCounter()
        } else {
            counterTimer = nil
            statusBarCounter = nil
        }
    }
    func percentTypeChange(percentType: PercentType) {
        for item in PercentMenu.itemArray {
            item.state = NSOffState
        }
        PercentMenu.itemArray[percentType.rawValue].state = NSOnState
        
        //TODO: Change view
    }
    func counterTypeChange(counterType: CounterType) {
        for item in CounterMenu.itemArray {
            item.state = NSOffState
        }
        CounterMenu.itemArray[counterType.rawValue].state = NSOnState
        
        //TODO: Change view
    }
    func counterIntegerChange(counterIsInteger: Bool) {
        
        //TODO: Change view
    }
    func birthDayChage(birthDay: NSDate) {
        
        //TODO: Change view
    }
    
    deinit {
        SettingsDelegate.sharedManager.removeDelegateWithIndex(delegateIndex ?? 0)
    }
    
    
    class func giveStatusImageForDone(done: CGFloat) -> NSImage {
        let width = String(48 * done - 48 * done % 0.01)
        
        let file = "status.eps"
        
        var path = NSBundle.mainBundle().pathForResource(file, ofType: nil) ?? file
        print(path)
        let startPath = path.startIndex
        let endPath = startPath.advancedBy(path.characters.count - file.characters.count)
        path = path.substringWithRange(startPath..<endPath)
        NNN += 1
        let newFile = "status" + String(NNN) + ".eps"
        print(path + newFile)

        
        do {
            
            //reading
            var data = String()
            data = try NSString(contentsOfFile: path + file, encoding: NSUTF8StringEncoding) as String
        
            let start = data.startIndex.advancedBy(2212)
            let endOld = start.advancedBy(10)
            let oldLength = data.substringWithRange(start..<endOld).componentsSeparatedByString(" ")[0].characters.count
            let end   = start.advancedBy(oldLength)
            data = data.stringByReplacingCharactersInRange(start..<end, withString: width)
            
            //writing
            try data.writeToFile(path + newFile, atomically: false, encoding: NSUTF8StringEncoding)
        
        }
        catch {fatalError("Can't write in file")}
        
        return NSImage(named: newFile)!
    }
    
}

var NNN = 0
