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
    case wrongCaseName(caseRawValue: String)
    case invalidParameterName(name: String)
    case fileNotCreated
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
        case .wrongCaseName(let caseRawValue):
            return "Runtime error: could not find element for case '\(caseRawValue)'"
        case .invalidParameterName(let name):
            return "Runtime error: could not find parameter '\(name)' in required parameters"
        case .fileNotCreated:
            return "Runtime error: file not created"
        }
    }
}
