//
//  Bundle+DisplayName.swift
//  SwiftReSign
//
//  Created by Adolfo Encinas Martín on 01/10/2018.
//  Copyright © 2018 Eleven Paths. All rights reserved.
//

import Foundation

extension Bundle {
    
    /// Returns a human-readable version of the app name.
    var displayName: String? {
        
        return self.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
    }
}
