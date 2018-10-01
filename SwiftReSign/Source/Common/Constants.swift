//
//  Constants.swift
//  SwiftReSign
//
//  Created by Adolfo Encinas Martín on 27/09/2018.
//  Copyright © 2018 Eleven Paths. All rights reserved.
//

struct Constants {
    
    struct Global {
        
        struct Script {
            
            static let success: String = "SUCCESS"
        }
        
        struct Files {
            
            static let certificate: String = "certificate"
            static let entitlements: String = "entitlements.plist"
            static let ipa: String = "IPA"
            static let tempFolderPath: String = "tmp"
            
            struct Types {
                
                static let ipa: [String] = ["ipa", "IPA"]
                static let plist: [String] = ["plist"]
                static let provisioning: [String] = ["mobileprovision"]
            }
        }
        
        struct Keys {
            
            static let label: String = "label"
            static let teamId: String = "com.apple.developer.team-identifier"
            static let value: String = "value"
        }
        
        struct Placeholder {
            
            static let ipa: String = "/path/to/app.ipa"
            static let provisioning: String = "/path/to/.mobileprovision"
            static let googleService: String = "/path/to/GoogleService-Info.plist"
            static let certificate: String = "Select a signing certificate"
            static let bundleId: String = "com.domainname.appname"
        }
        
        struct Storyboard {
            
            static let main: String = "Main"
        }
        
        struct Text {
            
            static let browse: String = "Browse"
            static let changeBundleId: String = "Change BundleID"
            static let changeFile: String = "Change File"
            static let close: String = "Close"
            static let resign: String = "Resign"
            static let resignFailure: String = "Failed to re-sign the app"
            static let resignSuccess: String = "Re-sign finished"
        }
    }
}
