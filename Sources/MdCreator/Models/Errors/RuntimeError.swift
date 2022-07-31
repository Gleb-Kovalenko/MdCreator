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
}

// MARK: - LocalizedError

extension RuntimeError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .filesNotFound:
            return "Runtime error: no .tcbundle files in directory"
        }
    }
}
