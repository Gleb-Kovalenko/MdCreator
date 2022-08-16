//
//  MdFileTemplateProtocol.swift
//  
//
//  Created by Gleb Kovalenko on 13.08.2022.
//

import Foundation

// MARK: - MdFileTemplateProtocol

/// Protocol for templates, which will then be inserted into the file
///
/// All properties must be written with a space and start with ":".
/// Parameters names must be start with "$" :
///
///     case someCase = "/file :header :modify $name :repeat"
///
/// Required indicates the nesting level of the desired element
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
/// And to get the values _"hello nested world"_ and _"i'm so deep"_, the following construction is needed
///
///     case helloCase = "/firstNestedProp"
///     case deepCase = "//soDeepProp"
///
protocol MdFileTemplateProtocol: CaseIterable, RawRepresentable where Self.RawValue == String {
    
    /// Get text according to template
    /// - Parameter element: The element with which the text will be printed
    /// - Returns: Text with element
    func text(with element: Any) -> String
}

// MARK: - MdFileTemplateProtocol

extension MdFileTemplateProtocol {
    
    // MARK: - Properties
    
    /// A property that indicates that the template is a header for a file
    /// That is, if merging is required, it will be in a single copy
    var isFileHeader: Bool {
        self.rawValue.contains(":header")
    }
    
    /// A property that indicates that the template is a name for a file
    var isFileName: Bool {
        self.rawValue.contains(":filename")
    }
    
    /// A property that indicates that completely identical given patterns can occur in a file
    var mayRepeat: Bool {
        self.rawValue.contains(":repeat")
    }
    
    /// A property that indicates that a parameter will need to be modified in the element for this template
    ///
    /// For example:
    ///
    ///     case someCase = "/file :modify $name"
    ///     // May we found "${name:something}" in "/file"
    ///     let parameters = ["name": "someValue"]
    ///     // And after modify string will look like "someValue"
    ///
    var needModifyParameter: Bool {
        self.rawValue.contains(":modify")
    }
    
    /// A property, indicates the path to the file
    /// That is, only "/" at the beginning and the name of the directory remain in the name
    ///
    /// For example:
    ///
    ///     case someCase = "///file :header :repeat"
    ///     let cleanPath = someCase.cleanPath
    ///
    /// And 'cleanPath' has the form:
    ///
    ///     "///file"
    ///
    var cleanPath: String {
        var cleanPath = ""
        var rawValue = self.rawValue
        while !rawValue.isEmpty {
            let symbol = rawValue.removeFirst()
            if symbol.isLetter {
                cleanPath += String(symbol)
                while let character = rawValue.first, character != " " {
                    cleanPath += String(rawValue.removeFirst())
                }
                break
            } else {
                cleanPath += String(symbol)
            }
        }
        return cleanPath
    }
}
