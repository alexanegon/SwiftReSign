//
//  RootWireframe.swift
//  SwiftReSign
//
//  Created by Adolfo Encinas Martín on 28/09/2018.
//  Copyright © 2018 Eleven Paths. All rights reserved.
//

import Cocoa

/// Objects adopting the `RootWireframe` protocol will have the ability of preparing and  presenting
/// the root (initial) interface.
protocol RootWireframe: class {
    
    /// Prepares the scene and presents the contents.
    static func startScene()
}

extension RootWindowController: RootWireframe {
    
    static func startScene() {
        
        let windowController: RootWindowController = self.setupRootWindowController()
        windowController.contentViewController = self.setupInitialViewController()
        windowController.showWindow(nil)
    }
}

// MARK: - Private methods
private extension RootWindowController {
    
    /// Setups the window controller to be displayed when presenting the scene.
    ///
    /// - Returns: The window controller instance.
    static func setupRootWindowController() -> RootWindowController {
        
        return RootWindowController(windowNibName: NSNib.Name(rawValue: String(describing: RootWindowController.self)))
    }
    
    /// Setups the view controller from which users may resign an IPA file.
    ///
    /// - Returns: The view controller instance.
    static func setupInitialViewController() -> ResignViewController {
        
        let storyboardName = NSStoryboard.Name(rawValue: ResignConfigurator.storyboardName())
        let identifier = NSStoryboard.SceneIdentifier(rawValue: ResignConfigurator.identifier())
        let viewController: ResignViewController = NSStoryboard(name: storyboardName,
                                                                bundle: nil).instantiateController(withIdentifier: identifier) as! ResignViewController
        ResignConfigurator.prepareScene(forViewController: viewController)
        
        return viewController
    }
}
