//
//  FeedbackViewInterface.swift
//  SwiftReSign
//
//  Created by Adolfo Encinas Martín on 27/09/2018.
//  Copyright © 2018 Eleven Paths. All rights reserved.
//

/// Base interface for view interface for common UI messages for user feedback.
protocol FeedbackViewInterface: class {
    
    /// Setup the view to show the data following design.
    func setupView()
    
    /// Show some UI feedback to user for loading data status.
    ///
    /// - Parameter message: optional message for loading control.
    func showLoading(message: String?)
    
    /// Dismiss from UI the current loading indicator.
    func dismissLoading()
}

// MARK: - Provide Default Implementations
extension FeedbackViewInterface {
    
    func showLoading(message: String?) { }
    
    func dismissLoading() { }
}


