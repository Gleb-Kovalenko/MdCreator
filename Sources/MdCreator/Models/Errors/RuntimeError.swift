//
//  RuntimeError.swift
//  
//
//  Created by Gleb Kovalenko on 31.07.2022.
//

import Foundation

// MARK: - RuntimeError

enum RuntimeError: Error {
    case filesNotFound
    case parseError(file: String)
    case unknownFunction(function: String)
    case invalidParameterName(name: String)
    case fileNotCreated
    case syntaxError(string: String)
}

// MARK: - LocalizedError

extension RuntimeError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .filesNotFound:
            return "Runtime error: no .tcbundle files in directory"
        case .parseError(let file):
            return "Runtime error: File \(file) cannot be parsed"
        case .unknownFunction(let function):
            return "Runtime error: function '\(function)' is not defined"
        case .invalidParameterName(let name):
            return "Runtime error: could not find parameter '\(name)' in required parameters"
        case .fileNotCreated:
            return "Runtime error: file not created"
        case .syntaxError(let string):
            return "Runtime error: Wrong syntax in '\(string)'"
        }
    }
}
