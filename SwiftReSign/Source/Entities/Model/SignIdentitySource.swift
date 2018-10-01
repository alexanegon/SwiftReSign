//
//  SignIdentitySource.swift
//  SwiftReSign
//
//  Created by Adolfo Encinas Martín on 01/10/2018.
//  Copyright © 2018 Eleven Paths. All rights reserved.
//

import Foundation

/// The `SignIdentitySource` protocol is adopted by an object that may contain all the credentials
/// and data required to resign an IPA file. That object will be suitable for generating new
/// `SignIdentity` instances, which represents the entry point for the script responsible for
/// resigning the original file.
protocol SignIdentitySource {
    
    /// The path to the IPA file.
    var ipaPath: String? { get set }
    
    /// The name of the certificate.
    var certificateName: String? { get set }
    
    /// The path to the provisioning profile.
    var provisioningPath: String? { get set }
    
    /// The path to the file that contains the data to connect with multiple Google-related
    /// services.
    var googleServicePath: String? { get set }
    
    /// The bundleID to replace the original one.
    var bundleID: String? { get set }
}
