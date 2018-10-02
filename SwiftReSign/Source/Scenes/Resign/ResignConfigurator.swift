//
//  ResignConfigurator.swift
//  SwiftReSign
//
//  Created by Adolfo Encinas Martín on 27/09/2018.
//  Copyright © 2018 Eleven Paths. All rights reserved.
//

import Cocoa

/// Configurator class to provide a complete module ready to use.
class ResignConfigurator: BaseConfigurator {
    
    static func prepareScene(forViewController viewController: NSViewController) {
        
        let viewController = viewController as! ResignViewController
        let presenter = ResignPresenter(view: viewController)
        viewController.eventHandler = presenter
    }
    
    static func storyboardName() -> String {
        
        return Constants.Global.Storyboard.main
    }
    
    static func identifier() -> String {
        
        return String(describing: ResignViewController.self)
    }
}
