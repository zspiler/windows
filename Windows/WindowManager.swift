//
//  WindowManager.swift
//  Windows
//
//  Created by Zan Spiler on 29/01/2021.
//

import Foundation
import Cocoa
import HotKey

class WindowManager: NSObject, NSApplicationDelegate, NSWindowDelegate {
    
    var mousePosition = NSPoint()
    
    let leftHotKey = HotKey(key: .leftArrow, modifiers: [.control, .option])
    let rightHotKey = HotKey(key: .rightArrow, modifiers: [.control, .option])
    
    enum Side {
        case left
        case right
        case bottom
    }
  
    func listen() {
        leftHotKey.keyDownHandler = {
            self.snapWindow(side: .left)
        }
        rightHotKey.keyDownHandler = {
            self.snapWindow(side: .right)
        }
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
