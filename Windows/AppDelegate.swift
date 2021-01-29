//
//  AppDelegate.swift
//  Windows
//
//  Created by Zan Spiler on 27/01/2021.
//

import Cocoa


@main
class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem.button?.title = "w";
        statusItem.button?.target = self
        statusItem.button?.action = #selector(showSettings);
 
        WindowManager().listen()
    
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
}

