//
//  MainWindowController.swift
//  Windows
//
//  Created by Zan Spiler on 28/01/2021.
//

import Foundation
import Cocoa

class MainWindowController: NSWindowController, NSWindowDelegate {

    override var windowNibName: String? {
        return "MainWindowController"
    }

    override func windowDidLoad() {
        super.windowDidLoad()
    }

    func windowDidResize(notification: NSNotification) {
        //listen the event
        print("yay!")
    }

}
