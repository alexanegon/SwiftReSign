//
//  ResignPresenter.swift
//  SwiftReSign
//
//  Created by Adolfo Encinas Martín on 27/09/2018.
//  Copyright © 2018 Eleven Paths. All rights reserved.
//

import Foundation

/// The number of components to be parsed from the certificate's name.
private let kCertificateNameComponents: Int = 2

/// Presenter implementation for RootPresenter scene to handle and control view logic.
class ResignPresenter: BasePresenter, SignIdentitySource {
    
    fileprivate weak var view: ResignViewInterface!
    fileprivate weak var wireframe: ResignWireframe!
    
    var ipaPath: String?
    var certificateName: String?
    var provisioningPath: String?
    var googleServicePath: String?
    var bundleID: String?
    
    init(view: ResignViewInterface) {
        
        self.view = view
        self.wireframe = (view as! ResignWireframe)
    }
    
    /// Requests a `Resign` operation.
    func performResign() {
        
        do {
            
            let identity = try SignIdentity(source: self)
            self.resign(withIdentity: identity)
        } catch let error {
            
            return self.wireframe.showError(error)
        }
    }
    
    /// Presents the user with a panel to select the IPA file to be resigned.
    func showIPABrowsing() {
        
        self.wireframe.showFileBrowser(forTypes: Constants.Global.Files.Types.ipa) {
            [weak self] (path) in
            
            self?.ipaPath = path
            self?.view.updateIPAFilePath(path)
        }
    }
    
    /// Presents the user with a panel to select the provisioning profile.
    func showProvisioningBrowsing() {
        
        self.wireframe.showFileBrowser(forTypes: Constants.Global.Files.Types.provisioning) {
            [weak self] (path) in
            
            self?.provisioningPath = path
            self?.view.updateProvisioningFilePath(path)
        }
    }
    
    /// Presents the user with a panel to select the `Google Service` file.
    func showGoogleServiceBrowsing() {
        
        self.wireframe.showFileBrowser(forTypes: Constants.Global.Files.Types.plist) { [weak self] (path) in
            
            self?.googleServicePath = path
            self?.view.updateGoogleServiceFilePath(path)
        }
    }
}

// MARK: - Presenter public methods to handle view events
extension ResignPresenter {
    
    func prepareView(forState state: ViewState) {
        
        switch state {
        
        case .didLoad:
            
            self.view.setupView()
            self.loadCertificates()
        default:
            
            break
        }
    }
}

// MARK: - Private methods
private extension ResignPresenter {
    
    /// Populates the view with the list of certificates installed in the user's keychain.
    func loadCertificates() {
        
        Script.certificates.run { (output) in
            
            var names: [String] = []
            output?.enumerateLines { (line, _) in
                
                // default output line format for security command:
                // 1) E00D4E3D3272ABB655CDE0C1CF53891210BAF4B8 "iPhone Developer: XXXXXXX (YYYYYYY)"
                let components = line.components(separatedBy: "\"")
                if components.count > kCertificateNameComponents {
                    
                    let commonName = components[components.count - kCertificateNameComponents]
                    names.append(commonName)
                }
            }
            names.sort(by: { $0 < $1 })
            
            self.view.updateCertificates(names)
        }
    }
    
    /// Execute the `Resign` operation for a given sign identity.
    ///
    /// - Parameter identity: A `SignIdentity` object specifying the information required to
    ///                       execute the requested operation.
    func resign(withIdentity identity: SignIdentity) {
        
        self.view.showLoading(message: nil)
        identity.validate { (error) in
            
            guard error == nil else {
                
                self.wireframe.showError(error!)
                self.view.dismissLoading()
                
                return
            }
            
            Script.resign(identity: identity).run { (output) in
                
                if output?.range(of: Constants.Global.Script.success) != nil {
                    
                    self.wireframe.showSuccess(message: Constants.Global.Text.resignSuccess)
                } else {
                    
                    self.wireframe.showError(message: Constants.Global.Text.resignFailure)
                }
                self.view.dismissLoading()
            }
        }
    }
}
