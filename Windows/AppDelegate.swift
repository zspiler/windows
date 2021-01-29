//
//  AppDelegate.swift
//  Windows
//
//  Created by Zan Spiler on 27/01/2021.
//

import Cocoa
import Carbon

import HotKey


@main
class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    
    var mousePosition = NSPoint()
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    let leftHotKey = HotKey(key: .leftArrow, modifiers: [.control, .option])
    let rightHotKey = HotKey(key: .rightArrow, modifiers: [.control, .option])
    
    enum Side {
        case left
        case right
        case bottom
    }
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem.button?.title = "w";
        statusItem.button?.target = self
        statusItem.button?.action = #selector(showSettings);
        
        leftHotKey.keyDownHandler = {
            self.snapWindow(side: .left)
        }
        rightHotKey.keyDownHandler = {
            self.snapWindow(side: .right)
        }
        
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
    
    
    func snapWindow(side: Side) {
        let type = CGWindowListOption.optionOnScreenOnly
        let windowList = CGWindowListCopyWindowInfo(type, kCGNullWindowID) as NSArray? as? [[String: AnyObject]]
        
        for entry in windowList! {
            
            let frontmostAppPID = NSWorkspace.shared.frontmostApplication?.processIdentifier
            
            if entry["kCGWindowOwnerPID"] as? pid_t == frontmostAppPID {
                
                let appRef = AXUIElementCreateApplication(frontmostAppPID!);
                var value: AnyObject?
                
                AXUIElementCopyAttributeValue(appRef, kAXWindowsAttribute as CFString, &value)
                
                if let windows = value as? [AXUIElement]
                {
                    for window in windows {
                        var newPoint: CGPoint?
                        var newSize: CGSize?
                        
                        if side == .left {
                            newPoint = CGPoint(x: (NSScreen.main?.visibleFrame.minX)! + 1, y: 0)
                            newSize = CGSize(width: (NSScreen.main?.frame.width)!/2 - (NSScreen.main?.visibleFrame.minX)!, height:  (NSScreen.main?.frame.height)!)
                            
                        }
                        
                        else if side == .right {
                            newPoint = CGPoint(x: (NSScreen.main?.frame.width)!/2 + 2, y: 0)
                            
                            if self.getDockPosition() == .right {
                                newSize = CGSize(width: (NSScreen.main?.frame.width)!/2 - ((NSScreen.main?.frame.width)! - (NSScreen.main?.visibleFrame.width)!)-1, height:  (NSScreen.main?.frame.height)!)
                            } else {
                                newSize = CGSize(width: (NSScreen.main?.frame.width)!/2, height:  (NSScreen.main?.frame.height)!)
                            }
            
                        }
                        
                        let position = AXValueCreate(AXValueType(rawValue: kAXValueCGPointType)!,&newPoint)!;
                        AXUIElementSetAttributeValue(window, kAXPositionAttribute as CFString, position);
                        
                        let size = AXValueCreate(AXValueType(rawValue: kAXValueCGSizeType)!,&newSize)!;
                        AXUIElementSetAttributeValue(window, kAXSizeAttribute as CFString, size);
                
                    }
                    
                }
                break
            }
            
        }
    }
    
    func getDockPosition() -> Side {
        if NSScreen.main!.visibleFrame.origin.y == 0 {
            if NSScreen.main!.visibleFrame.origin.x == 0 {
                return .right
            } else {
                return .left
            }
        } else {
            return .bottom
        }
    }
    
}

