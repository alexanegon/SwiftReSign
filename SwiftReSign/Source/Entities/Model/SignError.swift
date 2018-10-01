//
//  SignError.swift
//  SwiftReSign
//
//  Created by Adolfo Encinas Martín on 28/09/2018.
//  Copyright © 2018 Eleven Paths. All rights reserved.
//

import Foundation

/// An enum type to describe any custom error that may occur during a resign operation.
///
/// - invalidCertificate: The provided certificate file is not valid.
/// - invalidProvisioning: The provided provisioning profile is not valid.
/// - identityMismatch: The provisioning profile does not match with the team identifier associated
///                     to the certified authority.
/// - missingFile: A required file is missing for a given name.
enum SignError {
    
    case invalidCertificate
    case invalidProvisioning
    case identityMismatch
    case missingFile(name: String)
}

// MARK: - LocalizedError methods
extension SignError: LocalizedError {
    
    var errorDescription: String? {
        
        switch self {
            
        case .invalidCertificate:
            
            return "The provided certificate is not valid."
        case .invalidProvisioning:
            
            return "The provided provisioning profile is not valid."
        case .identityMismatch:
            
            return "The team identifiers do not match."
        case .missingFile(let name):
            
            return "\(name) file is required."
        }
    }
}
