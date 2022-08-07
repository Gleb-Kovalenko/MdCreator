//
//  TextTransformatorImplementation.swift
//  
//
//  Created by Gleb Kovalenko on 04.08.2022.
//

import Foundation

// MARK: - TextTransformatorImplementation

final class TextTransformatorImplementation {
    
}

// MARK: - TextTransformmator

extension TextTransformatorImplementation: TextTransformator {
    
    func transformText(in fileData: [String: Any], with parameters: [String: String]) throws -> [String: Any] {
        var transformatedFileData: [String: Any] = [:]
        for (dataKey,dataValue) in fileData {
            if let dictArray = dataValue as? [[String: Any]] {
                var newDictArray: [[String: Any]] = []
                for dictElement in dictArray {
                    newDictArray.append(try transformText(in: dictElement, with: parameters))
                }
                transformatedFileData[dataKey] = newDictArray
            } else if let anyArray = dataValue as? [Any] {
                if !anyArray.isEmpty {
                    var newAnyArray: [Any] = []
                    for arrayElement in anyArray {
                        if let stringElement = arrayElement as? String {
                            newAnyArray.append(try trasformated(string: stringElement, parameters: parameters))
                        } else {
                            newAnyArray.append(arrayElement)
                        }
                    }
                    transformatedFileData[dataKey] = newAnyArray
                }
            } else if let stringElement = dataValue as? String {
                transformatedFileData[dataKey] = try trasformated(string: stringElement, parameters: parameters)
            }
        }
        return transformatedFileData
    }
    
    // MARK: - Private
    
    /// Applies all transformation functions to a string (such as 'removeBackslahes', 'insertParametersValues', etc.)
    ///
    /// Example:
    ///
    ///     let "someString" = "string with some parameters ${someParameterValueWithoutFunctions} some text ${otherParameterValue.ucfirst}"
    ///     let parameters = [
    ///         "someParameterWithoutFunctions": "someParameterValueWithoutFunctions"
    ///         "otherParameter": "otherParameterValue",
    ///     ]
    ///     let transformatedString = transformated(string: someString, parameters: parameters)
    ///
    /// And 'transformatedString' has the form:
    ///
    ///     "string with some parameters someParameterValueWithoutFunctions some text OtherParameterValue"
    ///
    /// - Parameters:
    ///   - string: a string to transform
    ///   - parameters: parameters whose values will be inserted
    /// - Throws: Unknown function (the case when the parameter has an undefined function)
    /// - Returns: a transformated string
    private func trasformated(string: String, parameters: [String: String]) throws -> String {
        var transformString = string
        transformString = transformString.removeBackslahes()
        transformString = transformString.insertParametersValues(parameters: parameters)
        transformString = try findAndApplyFunctions(in: transformString, with: parameters)
        return transformString
    }
    
    
    /// Tries to find and, if found, applies functions to the parameters with already known values in the string
    ///
    /// Example:
    ///
    ///     let someString = "some text ${someParameterValueWithoutFunctions} some text ${otherParameterValue.lowercase.ucfirst}"
    ///     let parameters = [
    ///         "someParameterWithoutFunctions": "someParameterValueWithoutFunctions",
    ///         "otherParameter": "otherParameterValue"
    ///     ]
    ///     let transformatedString = findAndApplyFunctions(in: someString, with: parameters)
    ///
    /// And 'transformatedString' has the form:
    ///
    ///     "some text someParameterValueWithoutFunctions some text Otherparametervalue"
    ///
    /// - Parameters:
    ///   - string: the string where the parameter functions are looked up
    ///   - parameters: parameters with already known values for which functions are searched for and, if exist, are applied to them
    /// - Throws: Unknown function (the case when the parameter has an undefined function)
    /// - Returns: a string with the parameter values to which the specified functions were applied, if they existed
    private func findAndApplyFunctions(in string: String, with parameters: [String: String]) throws -> String {
        var string = string
        for (_, parameterValue) in parameters {
            let splitedString = string.components(separatedBy: "${\(parameterValue)")
            for splitedElement in splitedString {
                if splitedElement.hasPrefix(".") {
                    var splitedElement = splitedElement
                    var fullStringWithParameter = "${\(parameterValue)"
                    var functionName = ""
                    var updatedParameterValue = parameterValue
                    var isFindFunction = false
                    while !splitedElement.isEmpty {
                        let symbol = splitedElement.removeFirst()
                        if symbol == "}" {
                            fullStringWithParameter += String(symbol)
                            break
                        } else if symbol == "." {
                            fullStringWithParameter += String(symbol)
                            isFindFunction = true
                        } else if symbol.isLetter && isFindFunction {
                            functionName += String(symbol)
                            if let nextSymbol = splitedElement.first {
                                if !nextSymbol.isLetter {
                                    fullStringWithParameter += functionName
                                    if let parameterFunction = ParameterFunction(rawValue: functionName) {
                                        updatedParameterValue =  parameterFunction.perform(to: updatedParameterValue)
                                    } else {
                                        throw RuntimeError.unknownFunction(function: functionName)
                                    }
                                    functionName = ""
                                    isFindFunction = false
                                }
                            }
                        }
                    }
                    string = string.replacingOccurrences(of: fullStringWithParameter, with: updatedParameterValue)
                } else {
                    string = string.replacingOccurrences(of: "${\(parameterValue)}", with: parameterValue)
                }
            }
        }
        return string
    }
}
