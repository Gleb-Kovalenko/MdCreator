//
//  TextTransformerImplementation.swift
//  
//
//  Created by Gleb Kovalenko on 04.08.2022.
//

import Foundation

// MARK: - TextTransformerImplementation

final class TextTransformerImplementation {
    
}

// MARK: - TextTransformer

extension TextTransformerImplementation: TextTransformer {
    
    func modifyText(in fileData: Parameters, with parameters: [String: String]) throws -> Parameters {
        return try fileData.jsonMap(
            arrayDict: {
                try $0.reduce(into: [Parameters]()) { result, dictElement in
                    result.append(try modifyText(in: dictElement, with: parameters))
                }
            },
            string: {
                try modify(string: $0, parameters: parameters)
            },
            bool: { $0 },
            other: { $0 }
        )
    }
    
    // MARK: - Private
    
    /// Applies all modificating functions to a string (such as 'removeBackslahes', 'insertParametersValues', etc.)
    ///
    /// Example:
    ///
    ///     let "someString" = "string with some parameters ${someParameterValueWithoutFunctions} some text ${otherParameterValue.ucfirst}"
    ///     let parameters = [
    ///         "someParameterWithoutFunctions": "someParameterValueWithoutFunctions"
    ///         "otherParameter": "otherParameterValue",
    ///     ]
    ///     let modifiedString = transformated(string: someString, parameters: parameters)
    ///
    /// And 'modifiedString' has the form:
    ///
    ///     "string with some parameters someParameterValueWithoutFunctions some text OtherParameterValue"
    ///
    /// - Parameters:
    ///   - string: a string to modify
    ///   - parameters: parameters whose values will be inserted
    /// - Throws: Unknown function (the case when the parameter has an undefined function)
    /// - Returns: a modified string
    private func modify(string: String, parameters: [String: String]) throws -> String {
        var modifiedString = string
        modifiedString = modifiedString.removingBackslahes()
        modifiedString = modifiedString.insertParametersValues(parameters: parameters)
        modifiedString = try findAndApplyFunctions(in: modifiedString, with: parameters)
        return modifiedString
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
    ///     let modifiedString = findAndApplyFunctions(in: someString, with: parameters)
    ///
    /// And 'modifiedString' has the form:
    ///
    ///     "some text someParameterValueWithoutFunctions some text Otherparametervalue"
    ///
    /// - Parameters:
    ///   - string: the string where the parameter functions are looked up
    ///   - parameters: parameters with already known values for which functions are searched for and, if exist, are applied to them
    /// - Throws: Unknown function (the case when the parameter has an undefined function)
    /// - Returns: a string with the parameter values to which the specified functions were applied, if they existed
    private func findAndApplyFunctions(in string: String, with parameters: [String: String]) throws -> String {
        var updatedString = string
        _ = try parameters.map {
            let parameterValue = $0.value
            _ = try updatedString
                    .components(separatedBy: "${\(parameterValue)")
                    .filter({ $0.hasPrefix(".") })
                    .map { stringWithFunctions in
                        var updatedParameterValue = parameterValue
                        var fullStringWithParameter = "${\(parameterValue)"
                        _ = try stringWithFunctions
                                .split(separator: "}")[0]
                                .split(separator: ".")
                                .map { functionName in
                                    let functionName = functionName.replacingOccurrences(of: "}", with: "")
                                    fullStringWithParameter += ".\(functionName)"
                                    if let parameterFunction = ParameterFunction(rawValue: String(functionName)) {
                                        updatedParameterValue =  parameterFunction.perform(to: updatedParameterValue)
                                    } else {
                                        throw RuntimeError.unknownFunction(function: functionName)
                                    }
                                }
                        updatedString = updatedString.replacingOccurrences(of: "\(fullStringWithParameter)}", with: "\(updatedParameterValue)")
                    }
        }
        return updatedString
    }
}
