//
//  CodableParser.swift
//  
//
//  Created by Gleb Kovalenko on 01.08.2022.
//

import Foundation

// MARK: - CodableParser

protocol CodableParser {
    
    /// Gets all properties from a file data with their values
    /// - Parameter fileDate: File data to get all properties from
    /// - Returns: Dictionary with file's properties and values
    func allProperties(from fileData: Codable) -> [String: Any]
    
    /// Find the required parameters in the data
    ///
    /// The parameters are specified in the form ${parameterName} or ${parameterName.someFunction}
    /// and the parameter name must consist only of letters
    /// - Parameter data: Data from which you need to get all the necessary parameters
    /// - Returns: Dictionary with the names of the required parameters. Values are set as an empty string
    func requiredParameters(from data: [String: Any]) -> [String: String]
    
    /// Find the required parameters in the string
    ///
    /// The parameters are specified in the form ${parameterName} or ${parameterName.someFunction}
    /// and the parameter name must consist only of letters
    /// - Parameter string: String from which you need to get all the necessary parameters
    /// - Returns: Array with the names of the required parameters.
    func requiredParameters(from string: String) -> [String]
}
