//
//  TextTransformator.swift
//  
//
//  Created by Gleb Kovalenko on 04.08.2022.
//

import Foundation

// MARK: - TextTransformator

protocol TextTransformator {
    
    
    /// Transforms file data (remove backslashes, insert parameter values and apply functions to them, etc.)
    ///
    /// Example:
    ///
    ///     let fileData = [
    ///         "firstProperty": "\/\/\/ hello world \/\/\//n",
    ///         "secondProperty": "string with parameter ${someParameter.uppercase.lcfirst}",
    ///         "thirdProperty": [
    ///             "firstPropertyInNestedDict": "string with other parameter ${otherParameter.lowercase.ucfirst} some text ${otherParameter.ucfirst}",
    ///             "secondPropertyInNestedDict": "\/\/\/ hello nested dictionary \/\/\//n"
    ///         ]
    ///         ...
    ///     ]
    ///     let parameters = [
    ///         "someParameter": "someParameterValue",
    ///         "otherParameter": "otherParameterValue"
    ///     ]
    ///     let transformedFileData = transformText(in: fileData, with: parameters)
    ///
    /// And 'transformedFileData' has the form:
    ///         
    ///     [
    ///         "firstProperty": "/// hello world ////n",
    ///         "secondProperty": "string with parameter sOMEPARAMETERVALUE",
    ///         "thirdProperty": [
    ///             "firstPropertyInNestedDict": "string with other parameter Otherparametervalue some text OtherParameterValue",
    ///             "secondPropertyInNestedDict": "/// hello nested dictionary ////n"
    ///         ]
    ///         ...
    ///     ]
    ///
    /// - Parameters:
    ///   - fileData: file data to transform
    ///   - parameters: parameters with already known values whose values will be inserted
    /// - Throws: Unknown function (the case when the parameter has an undefined function)
    /// - Returns: transformated file data
    func transformText(in fileData: [String : Any], with parameters: [String: String]) throws -> [String: Any]
}
