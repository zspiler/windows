//
//  ViewController.swift
//  Windows
//
//  Created by Zan Spiler on 27/01/2021.
//

import Cocoa

import LaunchAtLogin

class ViewController: NSViewController, NSTextFieldDelegate, NSWindowDelegate {

    @IBOutlet weak var QuitButton: NSButton!
    @IBOutlet weak var LaunchAtLoginSwitch: NSSwitch!
    @IBOutlet weak var label: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        if LaunchAtLogin.isEnabled {
            LaunchAtLoginSwitch.state = .on
        } else {
            LaunchAtLoginSwitch.state = .off
        }
    }
    
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func quitButtonPress(_ sender: Any) {
        exit(0)
    }
    
    @IBAction func switchTap(_ sender: Any) {
        if LaunchAtLoginSwitch.state == .on {
            LaunchAtLogin.isEnabled = true
        } else {
            LaunchAtLogin.isEnabled = false
        }
        
    }
    
}

