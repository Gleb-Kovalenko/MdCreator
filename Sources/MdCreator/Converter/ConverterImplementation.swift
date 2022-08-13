//
//  ConverterImplementation.swift
//  
//
//  Created by Gleb Kovalenko on 10.08.2022.
//

import Foundation

// MARK: - ConverterImplementation

final class ConverterImplementation {
    
}

// MARK: - Converter

extension ConverterImplementation: Converter {

    func convert<T: MdFileTemplateProtocol>(
        files: [Parameters],
        parameters: [String: String],
        isNeedToMerge: Bool,
        template: T.Type
    ) throws -> [String] {
        
        var convertedText = ""
        var partOfText = ""
        var partsOfConvertedText: [String] = []
        var isContinueToSearch = true
        
        while isContinueToSearch {
            for partTemplate in T.allCases {
                let result = try findText(in: files, match: partTemplate, to: convertedText, with: parameters, isNeedToMerge: isNeedToMerge)
                if result != "notFoundMatch" {
                    partOfText += result + "\n\n"
                } else {
                    if !partTemplate.isFileHeader {
                        partOfText = ""
                        isContinueToSearch = false
                        break
                    }
                }
            }
            
            if partOfText != "" {
                if !isNeedToMerge {
                    partsOfConvertedText.append(partOfText)
                }
                convertedText += partOfText
                partOfText = ""
            }
        }
        
        if isNeedToMerge {
            partsOfConvertedText.append(convertedText)
        }
        
        return partsOfConvertedText
    }
    
    // MARK: - Private
    
    /// Finds the element that is described in the raw template value,
    /// applies transformation functions if required, and returns the template text with this element
    ///
    /// Example:
    ///
    ///     enum someEnum: String, MdFileTemplateProtocol {
    ///         case helloCase = "/firstNestedProp"
    ///         case deepCase = "//soDeepProp"
    ///         case NonExistentFile = "/file"
    ///     }
    ///
    ///     let someData = [
    ///         "firstProp": "hello world",
    ///         "secondProp": [
    ///             "firstNestedProp": "hello nested world",
    ///             "secondNestedProp": [
    ///                 "soDeepProp": "i'm so deep"
    ///             ]
    ///         ]
    ///     ]
    ///
    ///     let parameters = ["name": "someValue"]
    ///     let isNeedToMerge = true
    ///     var someString = ""
    ///     someString += findText(in: someData, match: someEnum.helloCase, to: someString, with: parameters, isNeedToMerge: isNeedToMerge) + "\n"
    ///     // "someString" = "hello nested world"
    ///     someString += findText(in: someData, match: someEnum.deepCase, to: someString, with: parameters, isNeedToMerge: isNeedToMerge) + "\n"
    ///     // "someString" = "hello nested world\ni'm so deep"
    ///     someString += findText(in: someData, match: someEnum.NonExistentFile, to: someString, with: parameters, isNeedToMerge: isNeedToMerge) + "\n"
    ///     // "someString" = "hello nested world\ni'm so deep\nnotFoundMatch\n"
    ///
    /// - Parameters:
    ///   - section: The data where the required element is searched for
    ///   - template: A template that describes the path to the element, its properties and necessary functions
    ///   - text: The resulting text of the file or files
    ///   - parameters: parameters with already known values whose values may be inserted
    ///   - isNeedToMerge: Indicates whether the expanders in the file should be combined into a single .md file
    ///   - nestingLevel: Indicates the current level of nesting
    /// - Throws: Invalid parameter name error
    /// - Returns: The template text with this element, if exists, otherwise "notFoundMatch" string
    private func findText<T: MdFileTemplateProtocol>(
        in section: [Parameters],
        match template: T,
        to text: String,
        with parameters: [String: String],
        isNeedToMerge: Bool,
        nestingLevel: Int = 0
    ) throws -> String {
        var result = ""
        for file in section {
            for (elementKey, elementValue) in file {
                if template.cleanPath == "\("/" * nestingLevel + elementKey)" {
                    var elementValue = elementValue
                    if let stringElement = elementValue as? String, template.needModifyParameter {
                        elementValue = try modifyParameters(stringWithParameters: template.rawValue, stringToModify: stringElement, parameters: parameters)
                    }
                    result = template.printText(with: elementValue)
                    if !text.contains(result) || template.mayRepeat || (!isNeedToMerge && template.isFileHeader) {
                        return result
                    }
                }
            }
            for (elementKey, _) in file {
                if let newSection = file[elementKey] as? [Parameters] {
                    return try findText(in: newSection, match: template, to: text, with: parameters, isNeedToMerge: isNeedToMerge, nestingLevel: nestingLevel + 1)
                }
            }
        }
        return "notFoundMatch"
    }
    
    /// Modify string, containing parameter
    ///
    /// Example:
    ///
    ///     let stringToModify = "some text ${someParameter: something} some text"
    ///     let stringWithParameterName = "/file :modify $someParameter"
    ///     let parameters = ["someParameter": "someValue"]
    ///
    ///     let modifiedString = modifyParameters(stringWithParameters: stringWithParameterName, stringToModify: stringToModify, parameters: parameters)
    ///
    /// And 'modifiedString' has the form:
    ///
    ///     "some text someValue some text"
    ///
    /// - Parameters:
    ///   - stringWithParameters: A string containing the names of the required parameters
    ///   - stringToModify: String to modfiy
    ///   - parameters: Parameters with already known values whose values may be inserted
    /// - Throws: Invalid parameter name error
    /// - Returns: Modified string or, if there was nothing to modify, the original string
    private func modifyParameters(stringWithParameters: String, stringToModify: String, parameters: [String: String]) throws -> String {
        var stringToFind = stringWithParameters
        var resultString = ""
        var nameOfParameter = ""
        while !stringToFind.isEmpty {
            let symbol = stringToFind.removeFirst()
            if symbol == "$" {
                while let character = stringToFind.first, character.isLetter {
                    nameOfParameter += String(stringToFind.removeFirst())
                }
                var fullStringWithParameter = "${\(nameOfParameter)"
                let splitedString = stringToModify.components(separatedBy: "${\(nameOfParameter)")
                if splitedString.count == 1 && splitedString.contains("${") {
                    throw RuntimeError.invalidParameterName(name: nameOfParameter)
                }
                for splitedElement in splitedString {
                    if splitedElement.hasPrefix(":") {
                        var splitedElement = splitedElement
                        while let character = splitedElement.first, character != "}" {
                            fullStringWithParameter += String(splitedElement.removeFirst())
                        }
                        fullStringWithParameter += "}"
                        if let parameterValue = parameters[nameOfParameter] {
                            resultString = stringToModify.replacingOccurrences(of: fullStringWithParameter, with: parameterValue)
                        }
                    }
                }
            }
        }
        return resultString == "" ? stringToModify : resultString
    }
}
