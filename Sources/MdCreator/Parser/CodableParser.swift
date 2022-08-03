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
    ///
    /// Example:
    ///
    ///     struct SomeStrcut: Codable {
    ///         var firstProterty: String = "hello"
    ///         var secondProperty: Character = "!"
    ///         var thirdProperty: Int = 3
    ///     }
    ///     let resultFunction: [String: Any] = allProperties(from: SomeStruct)
    ///
    /// And 'resultFunction' has the form:
    ///
    ///     [
    ///       "firstProperty": "hello",
    ///       "secondProperty": "!",
    ///       "thirdProperty": 3
    ///     ]
    ///
    /// - Parameter fileData: File data to get all properties from
    /// - Returns: Dictionary with file's properties and values
    func allProperties(from fileData: Codable) -> [String: Any]
    
    /// Find the required parameters in the data
    ///
    /// The parameters are specified in the form ${parameterName} or ${parameterName.someFunction}
    /// and the parameter name must consist only of letters
    ///
    /// Example:
    ///
    ///     let someData: [String: Any] = [
    ///           "firstProperty": "hello",
    ///           "secondProperty": [
    ///             "hello": "world",
    ///             "someText": "some text ${firstParameter} some text",
    ///             "someNumber": 5
    ///           ],
    ///           "thirdProperty": "some text ${secondParameter} some text"
    ///          ]
    ///     let parametersFromSomeData = requiredParameters(from: someData)
    ///
    /// And 'parametersFromSomeData' has the form:
    ///
    ///     [
    ///       "firstParameter": "",
    ///       "secondParameter": ""
    ///     ]
    /// 
    /// - Parameter data: Data from which you need to get all the necessary parameters
    /// - Returns: Dictionary with the names of the required parameters. Values are set as an empty string
    func requiredParameters(from data: [String: Any]) -> [String: String]
}
