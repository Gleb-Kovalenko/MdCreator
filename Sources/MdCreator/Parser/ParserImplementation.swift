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

    func requiredParameters(from data: Parameters) throws -> Set<String> {
        var requiredParametersArr = Set<String>()
        _ = try data.jsonMap(
            arrayDict: {
                _ = try $0.map {
                    let elementParameters = try requiredParameters(from: $0)
                    requiredParametersArr = requiredParametersArr.union(elementParameters)
                }
                return $0
            },
            string: {
                let parametersFromElement = try requiredParameters(from: $0)
                _ = parametersFromElement.map { requiredParametersArr.insert($0) }
                return $0
            },
            bool: { $0 },
            other: { $0 }
        )
        return requiredParametersArr
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
    private func requiredParameters(from string: String) throws -> [String] {
        return try string
                .split(separator: "$")
                .filter { $0.first == "{" }
                .reduce(into: [String]()) { result, stringWithParameter in
                    let start = stringWithParameter.index(stringWithParameter.startIndex, offsetBy: 1)
                    if let end = stringWithParameter.firstIndex(where: { $0 == "." || $0 == ":" || $0 == "}" }) {
                        result.append(String(stringWithParameter[start..<end]))
                    } else {
                        throw RuntimeError.syntaxError(string: String(stringWithParameter))
                    }
                }
    }
}
