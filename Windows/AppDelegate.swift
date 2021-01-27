//
//  AppDelegate.swift
//  Windows
//
//  Created by Zan Spiler on 27/01/2021.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    
    var mousePosition = NSPoint()
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem.button?.title = "h";
        statusItem.button?.target = self
        statusItem.button?.action = #selector(showSettings);
        
        listen()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @objc func showSettings() {
        let storyBoard = NSStoryboard(name: "Main", bundle: nil)
        guard let vc = storyBoard.instantiateController(withIdentifier: "ViewController")
                as? ViewController else {
            fatalError("Unable to find vc in storyboard")
        }
        
        let popoverView = NSPopover()
        
        popoverView.contentViewController = vc
        
        popoverView.behavior = .transient
        
        popoverView.show(relativeTo: statusItem.button!.bounds, of: statusItem.button!, preferredEdge: .maxY)
        
    }
    
    func windowDidMove(_ notification: Notification) {
    }
    
    
    func listen() {
        
        
        NSEvent.addGlobalMonitorForEvents(matching: NSEvent.EventTypeMask.mouseMoved, handler: {(mouseEvent:NSEvent) in
            self.mousePosition = mouseEvent.locationInWindow
//            print(self.mousePosition)
        })
        
        
        NSEvent.addGlobalMonitorForEvents(matching: NSEvent.EventTypeMask.leftMouseDragged, handler: {(mouseEvent:NSEvent) in
//            print("dragging at ")
        })
        
        
        NSEvent.addGlobalMonitorForEvents(matching: NSEvent.EventTypeMask.leftMouseDown, handler: {(mouseEvent:NSEvent) in
            print(self.mousePosition)
            
            let type = CGWindowListOption.optionOnScreenOnly
            let windowList = CGWindowListCopyWindowInfo(type, kCGNullWindowID) as NSArray? as? [[String: AnyObject]]
            
            for entry  in windowList!
            {
                let owner = entry[kCGWindowOwnerName as String] as! String
                var bounds = entry[kCGWindowBounds as String] as? [String: Int]
                let pid = entry[kCGWindowOwnerPID as String] as? Int32
                
                if owner == "Terminal"
                {
                    
                    let appRef = AXUIElementCreateApplication(pid!);  //TopLevel Accessability Object of PID
                    var value: AnyObject?
                    
                    
                    let result = AXUIElementCopyAttributeValue(appRef, kAXWindowsAttribute as CFString, &value)
                    
                    
                    if let windows = value as? [AXUIElement]
                    {
                        for window in windows {
                            var position : CFTypeRef
                            var size : CFTypeRef
                            var  newPoint = CGPoint(x: 0, y: 0)
                            var newSize = CGSize(width: 800, height: 800)
                            
                            position = AXValueCreate(AXValueType(rawValue: kAXValueCGPointType)!,&newPoint)!;
                            AXUIElementSetAttributeValue(window, kAXPositionAttribute as CFString, position);
                            
                            size = AXValueCreate(AXValueType(rawValue: kAXValueCGSizeType)!,&newSize)!;
                            AXUIElementSetAttributeValue(window, kAXSizeAttribute as CFString, size);
                        }
                        
                    }
                }
            }
            
            
        })
        
    }
    
    
}

