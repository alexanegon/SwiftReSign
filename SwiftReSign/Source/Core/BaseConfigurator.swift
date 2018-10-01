//
//  BaseConfigurator.swift
//  SwiftReSign
//
//  Created by Adolfo Encinas Martín on 27/09/2018.
//  Copyright © 2018 Eleven Paths. All rights reserved.
//

import Cocoa

/// Protocol to be conformed by all the configurators
protocol BaseConfigurator {
    
    /// Configure the scene with the controller, so inside we must configure the presenter with
    /// the view controller
    ///
    /// - Parameter viewController: The view controller to present
    static func prepareScene(forViewController viewController: NSViewController)
    
    /// To get the name of the storyboard where is the scene
    ///
    /// - Returns: String value
    static func storyboardName() -> String
    
    /// The identifier of the controller of the scene
    ///
    /// - Returns: Main controller of the scene
    static func identifier() -> String
}
