//
//  TCBundleExpanders.swift
//
//
//  Created by Gleb Kovalenko on 31.07.2022.
//

import Foundation

// MARK: - TCBundleExpanders

struct TCBundleExpanders: Codable {
    var outputTemplate: String
    var isEnabled: Bool
    var name: String
    var supportedLanguages: [String]
    var description: String
    var identifier: String
    var pattern: String
}
