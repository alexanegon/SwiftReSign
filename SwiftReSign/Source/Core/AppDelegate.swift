//
//  AppDelegate.swift
//  SwiftReSign
//
//  Created by Adolfo Encinas Martín on 27/09/2018.
//  Copyright © 2018 Eleven Paths. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        // Insert code here to initialize your application.
        RootWindowController.startScene()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        
        // Insert code here to tear down your application.
    }
}

