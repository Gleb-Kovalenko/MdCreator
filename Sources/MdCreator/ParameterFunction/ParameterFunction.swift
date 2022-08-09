//
//  ParameterFunction.swift
//  
//
//  Created by Gleb Kovalenko on 05.08.2022.
//

import Foundation

// MARK: - ParameterFunction

enum ParameterFunction: String {
    
    case lowercase
    case lcfirst
    case uppercase
    case ucfirst
    
    func perform(to string: String) -> String {
        switch self {
        case .lowercase:
            return string.lowercased()
        case .lcfirst:
            return string.lcfirst()
        case .uppercase:
            return string.uppercased()
        case .ucfirst:
            return string.ucfirst()
        }
    }
}
