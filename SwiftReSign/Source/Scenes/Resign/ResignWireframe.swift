//
//  ResignWireframe.swift
//  SwiftReSign
//
//  Created by Adolfo Encinas Martín on 27/09/2018.
//  Copyright © 2018 Eleven Paths. All rights reserved.
//

import Cocoa

/// The `ResignWireframe` protocol defines the route to other scenes from the Resign screen.
protocol ResignWireframe: class {
    
    /// Displays an alert indicating the description of a given error.
    ///
    /// - Parameter error: The error.
    func showError(_ error: Error)
    
    /// Displays an alert indicating a message description.
    ///
    /// - Parameter message: A `String` object containing the message.
    func showError(message: String)
    
    /// Presents an `Open panel` to query the user for the path of a file.
    ///
    /// - Parameters:
    ///   - types: An array of `String` objects specifying the allowed file types for the panel.
    ///   - completion: The completion block returning the path of the selected file.
    func showFileBrowser(forTypes types: [String], completion: @escaping (String) -> ())
    
    /// Displays an alert indicating a given success message.
    ///
    /// - Parameter message: A `String` object containing the message.
    func showSuccess(message: String)
}

extension ResignViewController: ResignWireframe {
    
    func showError(_ error: Error) {
        
        self.showError(message: error.localizedDescription)
    }
    
    func showError(message: String) {
        
        guard let sheetWindow = NSApp.keyWindow else { return }
        let alert = NSAlert()
        alert.messageText = Bundle.main.displayName ?? ""
        alert.informativeText = message
        alert.alertStyle = .critical
        alert.addButton(withTitle: Constants.Global.Text.close)
        alert.beginSheetModal(for: sheetWindow, completionHandler: nil)
    }
    
    func showFileBrowser(forTypes types: [String], completion: @escaping (String) -> ()) {
        
        let openPanel = NSOpenPanel()
        openPanel.allowedFileTypes = types
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canChooseFiles = true
        openPanel.canCreateDirectories = false
        openPanel.begin { (result) -> Void in
            
            if result == NSApplication.ModalResponse.OK, let path = openPanel.url?.path {
                
                completion(path)
            }
        }
    }
    
    func showSuccess(message: String) {
        
        guard let sheetWindow = NSApp.keyWindow else { return }
        let alert = NSAlert()
        alert.messageText = Bundle.main.displayName ?? ""
        alert.informativeText = message
        alert.alertStyle = .informational
        alert.addButton(withTitle: Constants.Global.Text.close)
        alert.beginSheetModal(for: sheetWindow, completionHandler: nil)
    }
}
