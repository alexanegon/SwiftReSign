//
//  ResignViewInterface.swift
//  SwiftReSign
//
//  Created by Adolfo Encinas Martín on 27/09/2018.
//  Copyright © 2018 Eleven Paths. All rights reserved.
//

/// View interface to enable comunication with view logic implementation (Presenter)
protocol ResignViewInterface: FeedbackViewInterface {
    
    /// Notifies the view to update the path to the selected IPA file.
    ///
    /// - Parameter path: A `String` object containing the path.
    func updateIPAFilePath(_ path: String)
    
    /// Notifies the view to update the path to the selected provisioning profile.
    ///
    /// - Parameter path: A `String` object containing the path.
    func updateProvisioningFilePath(_ path: String)
    
    /// Notifies the view to update the path to the selected `Google Service` file.
    ///
    /// - Parameter path: A `String` object containing the path.
    func updateGoogleServiceFilePath(_ path: String)
    
    /// Notifies the view to update the list of available certificates.
    ///
    /// - Parameter certificates: An array of `String` objects specifying the name of each
    ///                           certificate included in the user's keychain.
    func updateCertificates(_ certificates: [String])
}
