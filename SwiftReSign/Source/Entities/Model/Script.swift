//
//  Script.swift
//  SwiftReSign
//
//  Created by Adolfo Encinas Martín on 28/09/2018.
//  Copyright © 2018 Eleven Paths. All rights reserved.
//

import Foundation

/// An enum type to identify all the different scripts that may be executed within the app.
///
/// - certificates: A script to retrieve a list certificates installed on the current device.
/// - entitlements: A script to identify the entitlements included in the provisioning profile
///                 attached to a sign identity.
/// - resign: A script to resign an IPA file with a sign identity.
enum Script {
    
    case certificates
    case entitlements(identity: SignIdentity)
    case resign(identity: SignIdentity)

    // MARK: Executing a Script
    
    /// Executes the receiver.
    ///
    /// - Parameters:
    ///   - queue: The queue in which the receivier is executed.
    ///   - completionHandler: The completion block returning a `String` object containing the
    ///                        receiver's output. This will be executed from the main thread.
    func run(queue: DispatchQueue = .global(), completionHandler: @escaping ((String?) -> Void)) {
        
        queue.async {
         
            let task: Process = Process()
            let pipe: Pipe = Pipe()
            
            task.launchPath = self.launchPath
            task.arguments = self.arguments
            task.standardOutput = pipe
            task.standardError = pipe
            
            let handle = pipe.fileHandleForReading
            task.launch()
            
            let data = handle.readDataToEndOfFile()
            let buffer = String(data: data, encoding: String.Encoding.utf8)
            
            DispatchQueue.main.async {
                
                completionHandler(buffer)
            }
        }
    }
}

// MARK: - Private methods
private extension Script {
    
    /// Returns the command arguments that should be used to launch the receiver.
    var arguments: [String] {
        
        switch self {
            
        case .certificates:
            
            return ["find-identity", "-v", "-p", "codesigning"]
        case .entitlements(let identity):
            
            return [Bundle.main.path(forResource: self.filename, ofType: "sh")!,
                    identity.provisioning ?? "",
                    identity.tempDir.path]
        case .resign(let identity):
            
            return [Bundle.main.path(forResource: self.filename, ofType: "sh")!,
                    "-s",
                    identity.ipa,
                    "-c",
                    identity.certificate,
                    "-p",
                    identity.provisioning ?? "",
                    "-g",
                    identity.googleService ?? "",
                    "-b",
                    identity.bundleId ?? ""]
        }
    }
    
    /// Returns the name of the file embedded in the main bundle, and which contains the entire
    /// code of the receiver.
    var filename: String? {
        
        switch self {
            
        case .entitlements:
            
            return "entitlements"
        case .resign:
            
            return "resign"
        default:
            
            return nil
        }
    }
    
    /// Returns the receiver’s executable.
    var launchPath: String {
        
        switch self {
            
        case .certificates:
            
            return "/usr/bin/security"
        default:
            
            return "/bin/sh"
        }
    }
}
