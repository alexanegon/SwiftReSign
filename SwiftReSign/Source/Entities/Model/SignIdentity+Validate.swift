//
//  SignIdentity+Validate.swift
//  SwiftReSign
//
//  Created by Adolfo Encinas Martín on 28/09/2018.
//  Copyright © 2018 Eleven Paths. All rights reserved.
//

import Foundation
import Security

extension SignIdentity {
    
    /// Validates the receiver by checking whether the team identifier matches between the
    /// provided certificate and provisioning profile. If the latter is not included within the
    /// identity, the validation always completes successfully.
    ///
    /// - Parameter completionHandler: The completion block that returns an error in case the
    ///                                validation fails. Returns `nil` if successful.
    func validate(completionHandler: @escaping ((Error?) -> Void)) {
        
        guard let provisioningPath = self.provisioning, !provisioningPath.isEmpty else {
            
            return completionHandler(nil)
        }
        guard let organization = self.organizationUnit() else {
            
            return completionHandler(SignError.invalidCertificate)
        }
        
        self.fetchTeamIdentifier { (result) in
            
            guard let teamId: String = result else {
                
                return completionHandler(SignError.invalidProvisioning)
            }
            guard organization.compare(teamId) == .orderedSame else {
                
                return completionHandler(SignError.identityMismatch)
            }
            
            completionHandler(nil)
        }
    }
}

// MARK: - Private methods
private extension SignIdentity {
    
    /// Retrieves the team identifier from the provisioning profile attached to the receiver.
    ///
    /// - Parameter completionHandler: The completion block that returns a string value containing
    ///                                the requested team identifier. Returns `nil` in case of
    ///                                failure.
    func fetchTeamIdentifier(completionHandler: @escaping ((String?) -> Void)) {
        
        let plistFileURL: URL = self.tempDir.appendingPathComponent(Constants.Global.Files.entitlements,
                                                                    isDirectory: false)
        let plistFilePath: String = plistFileURL.path
        Script.entitlements(identity: self).run { (output) in
            
            guard let _ = output?.range(of: Constants.Global.Script.success) else {
                
                return completionHandler(nil)
            }
            
            guard
                FileManager.default.fileExists(atPath: plistFilePath),
                let plist = NSDictionary(contentsOfFile: plistFilePath),
                let teamId = plist[Constants.Global.Keys.teamId] as? String else
            {
                return completionHandler(nil)
            }
            
            return completionHandler(teamId)
        }
    }
    
    /// Returns the organization unit (team identifier) from the certificate selected by the
    /// receiver.
    ///
    /// - Returns: A `String` value containing the requested identifier, or `nil` if not found.
    func organizationUnit() -> String? {
        
        let query: [String: Any] = [kSecClass as String: kSecClassCertificate,
                                    kSecAttrLabel as String: self.certificate,
                                    kSecReturnRef as String: kCFBooleanTrue]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess else { return nil }
        
        let secCertificate = item as! SecCertificate
        let keys = [kSecOIDX509V1SubjectName] as CFArray
        guard
            let subject = SecCertificateCopyValues(secCertificate, keys, nil) as? [String: Any],
            let rootDict = subject["\(kSecOIDX509V1SubjectName)"] as? [String : Any],
            let values = rootDict[Constants.Global.Keys.value] as? [Any] else
        {
            return nil
        }
        
        for case let dict as [String: Any] in values {
            
            if
                let label = dict[Constants.Global.Keys.label] as? String,
                label.compare("\(kSecOIDOrganizationalUnitName)") == .orderedSame
            {
                return dict[Constants.Global.Keys.value] as? String
            }
        }
        
        return nil
    }
}
