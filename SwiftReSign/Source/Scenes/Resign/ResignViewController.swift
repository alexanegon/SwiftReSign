//
//  ResignViewController.swift
//  SwiftReSign
//
//  Created by Adolfo Encinas Martín on 27/09/2018.
//  Copyright © 2018 Eleven Paths. All rights reserved.
//

import Cocoa

class ResignViewController: NSViewController {
    
    @IBOutlet weak var textFieldIpaPath: NSTextField!
    @IBOutlet weak var buttonIpaPath: NSButton!
    @IBOutlet weak var textFieldProvisioningPath: NSTextField!
    @IBOutlet weak var buttonProvisioningPath: NSButton!
    @IBOutlet weak var textFieldGoogleService: NSTextField!
    @IBOutlet weak var buttonGoogleService: NSButton!
    @IBOutlet weak var checkboxGoogleService: NSButton!
    @IBOutlet weak var textFieldBundleId: NSTextField!
    @IBOutlet weak var checkboxBundleId: NSButton!
    @IBOutlet weak var comboBoxCertificates: NSComboBox!
    @IBOutlet weak var buttonResign: NSButton!
    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    
    fileprivate var certificates: [String] = []
    
    var eventHandler: ResignPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.eventHandler?.prepareView(forState: .didLoad)
    }
    
    @IBAction func tapBrowseIPA(_ button: NSButton) {
        
        self.eventHandler?.showIPABrowsing()
    }
    
    @IBAction func tapBrowseProvisioning(_ button: NSButton) {
        
        self.eventHandler?.showProvisioningBrowsing()
    }
    
    @IBAction func tapBrowseGoogleService(_ button: NSButton) {
        
        self.eventHandler?.showGoogleServiceBrowsing()
    }
    
    @IBAction func tapChangeGoogleService(_ button: NSButton) {
        
        // Enable/disable Google Service text field.
        let isServiceRequired: Bool = button.state == .on
        self.textFieldGoogleService.isEnabled = isServiceRequired
        self.eventHandler?.googleServicePath = isServiceRequired ? self.textFieldGoogleService.stringValue : nil
    }
    
    @IBAction func tapChangeBundleID(_ button: NSButton) {
        
        // Enable/disable bundleID text field.
        let isBundleIdRequired: Bool = button.state == .on
        self.textFieldBundleId.isEnabled = isBundleIdRequired
        self.eventHandler?.bundleID = isBundleIdRequired ? self.textFieldBundleId.stringValue : nil
    }
    
    @IBAction func tapResign(_ button: NSButton) {
        
        self.eventHandler?.performResign()
    }
}

// MARK: - View interface implementation methods
extension ResignViewController: ResignViewInterface {
    
    func setupView() {
        
        self.textFieldIpaPath.placeholderString = Constants.Global.Placeholder.ipa
        self.textFieldProvisioningPath.placeholderString = Constants.Global.Placeholder.provisioning
        self.textFieldGoogleService.placeholderString = Constants.Global.Placeholder.googleService
        self.textFieldGoogleService.isEnabled = false
        self.textFieldBundleId.placeholderString = Constants.Global.Placeholder.bundleId
        self.textFieldBundleId.isEnabled = false
        self.comboBoxCertificates.placeholderString = Constants.Global.Placeholder.certificate
        
        self.buttonIpaPath.title = Constants.Global.Text.browse
        self.buttonProvisioningPath.title = Constants.Global.Text.browse
        self.buttonGoogleService.title = Constants.Global.Text.browse
        
        self.checkboxGoogleService.title = Constants.Global.Text.changeFile
        self.checkboxGoogleService.state = .off
        self.checkboxBundleId.title = Constants.Global.Text.changeBundleId
        self.checkboxBundleId.state = .off
        
        self.buttonResign.title = Constants.Global.Text.resign
        
        self.progressIndicator.isDisplayedWhenStopped = false
        self.progressIndicator.stopAnimation(nil)
    }
    
    func showLoading(message: String?) {
        
        self.buttonResign.isEnabled = false
        self.progressIndicator.startAnimation(nil)
    }
    
    func dismissLoading() {
    
        self.buttonResign.isEnabled = true
        self.progressIndicator.stopAnimation(nil)
    }
    
    func updateIPAFilePath(_ path: String) {
        
        self.textFieldIpaPath.stringValue = path
    }
    
    func updateProvisioningFilePath(_ path: String) {
        
        self.textFieldProvisioningPath.stringValue = path
    }
    
    func updateGoogleServiceFilePath(_ path: String) {
        
        self.textFieldGoogleService.stringValue = path
        self.textFieldGoogleService.isEnabled = true
        self.checkboxGoogleService.state = .on
    }
    
    func updateCertificates(_ certificates: [String]) {
        
        self.certificates.removeAll()
        self.certificates.append(contentsOf: certificates)
        self.comboBoxCertificates.reloadData()
    }
}

// MARK: - NSComboBoxDataSource methods
extension ResignViewController: NSComboBoxDataSource {
    
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        
        return self.certificates.count
    }
    
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        
        return self.certificates[index]
    }
}

// MARK: - NSComboBoxDelegate methods
extension ResignViewController: NSComboBoxDelegate {
    
    func comboBoxSelectionDidChange(_ notification: Notification) {
        
        guard let comboBox = notification.object as? NSComboBox else { return }
        self.eventHandler?.certificateName = self.certificates[comboBox.indexOfSelectedItem]
    }
}

// MARK: - NSTextFieldDelegate methods
extension ResignViewController: NSTextFieldDelegate {
    
    override func controlTextDidChange(_ obj: Notification) {
        
        guard let textField = obj.object as? NSTextField else { return }
        self.eventHandler?.bundleID = textField.stringValue
    }
}
