//
//  ParserImplementation.swift
//  
//
//  Created by Gleb Kovalenko on 01.08.2022.
//

import Foundation

// MARK: - ParserImplementation

final class ParserImplementation {
    
}

// MARK: - Parser

extension ParserImplementation: Parser {

    func requiredParameters(from data: Parameters) -> [String: String] {
        var requiredParametersDict: [String: String] = [:]
        let dataValues = data.map ( \.value )
        for dataValue in dataValues {
            if let dictArray = dataValue as? [Parameters] {
                for dictElement in dictArray {
                    let elementParameters = requiredParameters(from: dictElement)
                    requiredParametersDict.merge(elementParameters) { (current, _) in current }
                }
            } else if let anyArray = dataValue as? [Any] {
                if !anyArray.isEmpty {
                    for arrayElement in anyArray {
                        if let stringElement = arrayElement as? String {
                            let parametersFromElement = requiredParameters(from: stringElement)
                            for parameter in parametersFromElement {
                                requiredParametersDict[parameter] = ""
                            }
                        }
                    }
                }
            } else if let stringElement = dataValue as? String {
                let parametersFromElement = requiredParameters(from: stringElement)
                for parameter in parametersFromElement {
                    requiredParametersDict[parameter] = ""
                }
            }
        }
        return requiredParametersDict
    }
    
    // MARK: - Private
    
    /// Find the required parameters in the string.
    ///
    /// The parameters are specified in the form ${parameterName} or ${parameterName.someFunction}
    /// and the parameter name must consist only of letters.
    ///
    /// Example:
    ///
    ///     let someString = "some text ${firstParameter}, some text ${secondParameter} some text"
    ///     let parametersFromSomeString = requiredParameters(from: someString)
    ///
    /// And 'parametersFromSomeString' has the form:
    ///
    ///     ["firstParameter", "secondParameter"]
    ///
    /// - Parameter string: String from which you need to get all the necessary parameters.
    /// - Returns: Array with the names of the required parameters.
    private func requiredParameters(from string: String) -> [String] {
        var elementWithParameter = string
        var allParameters: [String] = []
        var parameterName = ""
        var isFindParameter = false
        while !elementWithParameter.isEmpty {
            let symbol = elementWithParameter.removeFirst()
            if symbol == "$" && elementWithParameter.first == "{" {
                isFindParameter = true
                continue
            } else if symbol.isLetter && isFindParameter {
                if let nextSymbol = elementWithParameter.first {
                    if nextSymbol.isLetter {
                        parameterName += String(symbol)
                    } else {
                        parameterName += String(symbol)
                        allParameters.append(parameterName)
                        parameterName = ""
                        isFindParameter = false
                    }
                }
            }
        }
        return allParameters
    }
}
