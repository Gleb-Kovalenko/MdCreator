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
    func removeBackslahes() -> String {
        self.replacingOccurrences(of: "\\/", with: "/")
    }
    
    
    /// Inserts parameter values into a string
    ///
    /// Example:
    ///
    ///     let someString = "sometext ${someParameter}some text"
    ///     let dictWithParameter = ["someParameter": "someValueParameter"]
    ///     let transformatedString = someString.insertParametersNames(parameters: dictWithParameter)
    ///
    /// And 'transformatedString' has the form:
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
        return newString
    }
    
    
    /// Makes the first letter in a string lowercase
    /// - Returns: A string whose first letter is lowercase
    func lcfirst() -> String {
        return self.prefix(1).lowercased() + self.dropFirst()
    }
}
