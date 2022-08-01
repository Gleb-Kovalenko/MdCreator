//
//  TCBundle.swift
//
//
//  Created by Gleb Kovalenko on 31.07.2022.
//

import Foundation

// MARK: - TCBundle

struct TCBundle: Codable {
    
    // MARK: - Properties
    
    let description: String
    let supportedLanguages: [String]
    let expanders: [TCBundleExpander]
    let isEnabled: Bool
    let name: String
}
