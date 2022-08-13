//
//  String.swift
//  
//
//  Created by Gleb Kovalenko on 07.08.2022.
//

import Foundation

// MARK: - String

extension String {
    
    /// Replace "\/" combination with "/"
    /// - Returns: new string with replacing
    func removingBackslahes() -> String {
        self.replacingOccurrences(of: "\\/", with: "/")
    }
    
    /// Inserts parameter values into a string
    ///
    /// Example:
    ///
    ///     let someString = "sometext ${someParameter}some text"
    ///     let dictWithParameter = ["someParameter": "someValueParameter"]
    ///     let modifiedString = someString.insertParametersNames(parameters: dictWithParameter)
    ///
    /// And 'modifiedString' has the form:
    ///
    ///     "sometext ${someValueParameter}some text"
    ///
    /// - Parameter parameters: Names and values of parameters to be inserted
    /// - Returns: New string with inserted parameters
    func insertParametersValues(parameters: [String: String]) -> String {
        var newString = self
        for (parameterName, parameterValue) in parameters {
            newString = newString.replacingOccurrences(of: "${\(parameterName)", with: "${\(parameterValue)")
        }
        for (parameterName, parameterValue) in parameters {
            newString = newString.replacingOccurrences(of: "${\(parameterValue):", with: "${\(parameterName):")
        }
        return newString
    }
    
    /// Makes the first letter in a string lowercase
    /// - Returns: A string whose first letter is lowercase
    func lcfirst() -> String {
        prefix(1).lowercased() + dropFirst()
    }
    
    /// Makes the first letter in a string uppercase
    /// - Returns: A string whose first letter is uppercase
    func ucfirst() -> String {
        prefix(1).uppercased() + dropFirst()
    }
    
    /// Repeat string some number of times
    /// - Parameters:
    ///    - lhs: String to repeat
    ///    - rhs: Repeat count
    /// - Returns: Repeated string
    static func * (lhs: String, rhs: Int) -> String {
        return String(repeating: lhs, count: rhs)
    }
}
