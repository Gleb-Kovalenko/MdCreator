//
//  TCBundle.swift
//
//
//  Created by Gleb Kovalenko on 31.07.2022.
//

import Foundation

// MARK: - TCBundle

struct TCBundle: Codable {
    var description: String
    var supportedLanguages : [String]
    var expanders : [TCBundleExpanders]
    var isEnabled : Bool
    var name: String
}
