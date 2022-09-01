//
//  Converter.swift
//  
//
//  Created by Gleb Kovalenko on 10.08.2022.
//

import Foundation

// MARK: - Converter

protocol Converter {
    
    /// Converts data in files to array of parts of the text according to templates
    ///
    /// Example:
    ///
    ///     enum someEnum: String, MdFileTemplateProtocol {
    ///         case helloCase = "/firstNestedProp :header"
    ///         case deepCase = "//soDeepProp :modify $someParameter"
    ///     }
    ///
    ///     let someData = [
    ///     [
    ///         "firstProp": "hello world :filename",
    ///         "secondProp": [
    ///             [
    ///                 "firstNestedProp": "hello nested world",
    ///                 "secondNestedProp": [
    ///                     "soDeepProp": "i'm so deep ${someParameter:something}"
    ///                 ],
    ///             ],
    ///             [
    ///                 "firstNestedProp": "hello nested world",
    ///                 "secondNestedProp": [
    ///                     "soDeepProp": "i'm so deepх2"
    ///                 ],
    ///             ]
    ///         ]
    ///     ]
    ///
    ///     let parameters = ["someParameter": "someValue"]
    ///     let isNeedToMerge = true
    ///     let resultWithMerge = converter.convert(files: someData, parameters: parameters, isNeedToMerge: isNeedToMerge, template: someEnum.self)
    ///
    /// And 'resultWithMerge: has the form:
    ///
    ///     ["hello world" : "hello world\n\ni'm so deep someValue\n\ni'm so deepx2\n\n"]
    ///
    /// Without merge example:
    ///
    ///     let isNeedToMerge = false
    ///     let resultWithoutMerge = converter.convert(files: someData, parameters: parameters, isNeedToMerge: isNeedToMerge, template: someEnum.self)
    ///
    /// And 'resultWithoutMerge: has the form:
    ///
    ///     [
    ///         "hello world": "hello world\n\ni'm so deep someValue\n\n",
    ///         "hello world": "helloworld\n\ni'm so deepx2\n\n"
    ///     ]
    ///
    /// - Parameters:
    ///   - files: The data where the required element is searched for
    ///   - template: A template that describes the path to the element, its properties and necessary functions
    ///   - parameters: Parameters with already known values whose values may be inserted
    ///   - isNeedToMerge: Indicates whether the expanders in the file should be combined into a single .md file
    /// - Throws: Invalid parameter name error
    /// - Returns: Dictionary with names and parts of the text that will be in the files
    func convert<T: MdFileTemplateProtocol>(
        files: [Parameters],
        parameters: [String: String],
        isNeedToMerge: Bool,
        template: T.Type
    ) throws -> [String: String]
}
