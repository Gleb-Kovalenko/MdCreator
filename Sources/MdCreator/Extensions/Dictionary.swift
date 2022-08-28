//
//  Dictionary.swift
//  
//
//  Created by Gleb Kovalenko on 27.08.2022.
//

import Foundation

// MARK: - Dictionary

extension Dictionary where Key == String, Value: Any {
    func jsonMap(
        arrayDict transformArrDict: (_ Element: [Parameters]) throws -> [Parameters],
        string transformString: (_ Element: String) throws -> String,
        bool transformBool: (_ Element: Bool) throws -> Bool,
        other transformOther: (_ Element: Any) throws -> Any
    ) throws -> Parameters {
        var result = Parameters()
        for (dataKey, dataValue) in self {
            if let dictArray = dataValue as? [Parameters] {
                result[dataKey] = try transformArrDict(dictArray)
            } else if let anyArray = dataValue as? [Any] {
                var newAnyArray = [Any]()
                for arrayElement in anyArray {
                    if let stringElement = arrayElement as? String {
                        newAnyArray.append(try transformString(stringElement))
                    } else if let boolValue = arrayElement as? Bool {
                        newAnyArray.append(try transformBool(boolValue))
                    } else {
                        newAnyArray.append(try transformOther(dataValue))
                    }
                }
                result[dataKey] = newAnyArray
            } else if let stringElement = dataValue as? String {
                result[dataKey] = try transformString(stringElement)
            } else if let boolValue = dataValue as? Bool {
                result[dataKey] = try transformBool(boolValue)
            } else {
                result[dataKey] = try transformOther(dataValue)
            }
        }
        return result
    }
}
