//
//  CodableParser.swift
//  
//
//  Created by Gleb Kovalenko on 01.08.2022.
//

import Foundation

// MARK: - CodableParser

protocol CodableParser {
    
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
