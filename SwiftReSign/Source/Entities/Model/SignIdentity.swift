//
//  SignIdentity.swift
//  SwiftReSign
//
//  Created by Adolfo Encinas Martín on 28/09/2018.
//  Copyright © 2018 Eleven Paths. All rights reserved.
//

import Foundation

/// An object that groups all of the credentials required to resign an IPA file.
class SignIdentity {
    
    /// The path to the IPA file.
    let ipa: String
    /// The name of the certificate to be loaded from the user's keychain.
    let certificate: String
    /// The path to the provisioning profile. If `nil`, no profile will be used during the
    /// resign operation.
    let provisioning: String?
    /// The path to the file that contains the data to connect with multiple Google-related services
    /// and which may be replaced during the resign operation.
    let googleService: String?
    /// The bundleID to be replaced during the resign operation. If `nil`, the identifier found in
    /// the original IPA file will be used to resign the latter.
    let bundleId: String?
    /// A URL path pointing to a folder where certain temporary files may be created while
    /// performing the resign operation.
    let tempDir: URL
    
    /// Initialize a new `SignIdentify` instance from a given source.
    ///
    /// - note: This initializer will attempt to create the folder pointed by the `tempDir`
    ///         attribute. This will be automatically deleted during the deinitialization of the
    ///         instance.
    ///
    /// - Parameter source: A `SignIdentitySource` protocol which contains the group of credentials
    ///                     and data required to resign a IPA file successfully.
    /// - Throws: A `SignError.missingFile` in case the IPA file or the certificate name provided
    ///           by the source are not valid. In addition, a `FileManager` exception may be rised
    ///           when attempting to create the temporary folder.
    init(source: SignIdentitySource) throws {
        
        guard let ipa = source.ipaPath, !ipa.isEmpty else {
            
            throw SignError.missingFile(name: Constants.Global.Files.ipa)
        }
        guard let certificate = source.certificateName, !certificate.isEmpty else {
            
            throw SignError.missingFile(name: Constants.Global.Files.certificate)
        }
        self.ipa = ipa
        self.certificate = certificate
        self.provisioning = source.provisioningPath
        self.googleService = source.googleServicePath
        self.bundleId = source.bundleID
        self.tempDir = URL(fileURLWithPath: ipa)
            .deletingLastPathComponent()
            .appendingPathComponent(Constants.Global.Files.tempFolderPath, isDirectory: true)
        
        try FileManager.default.createDirectory(at: self.tempDir,
                                                withIntermediateDirectories: true,
                                                attributes: nil)
    }
    
    deinit {
        
        try? FileManager.default.removeItem(at: self.tempDir)
    }
}
