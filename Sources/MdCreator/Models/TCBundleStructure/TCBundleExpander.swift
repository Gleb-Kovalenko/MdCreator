//
//  TCBundleExpander.swift
//
//
//  Created by Gleb Kovalenko on 31.07.2022.
//

import Foundation

// MARK: - TCBundleExpander

struct TCBundleExpander: Codable {
    
    // MARK: - Properties
    
    let outputTemplate: String
    let isEnabled: Bool
    let name: String
    let supportedLanguages: [String]
    let description: String
    let identifier: String
    let pattern: String
}
