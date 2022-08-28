//
//  MdFileTemplate.swift
//  
//
//  Created by Gleb Kovalenko on 10.08.2022.
//

import Foundation

// MARK: - MdFileTemplate

enum MdFileTemplate: String, MdFileTemplateProtocol {
    
    // MARK: - Cases
    
    case header = "name :header :filename"
    case description = "description :header"
    case headerExpander = "/name"
    case syntaxExpander = "/pattern"
    case inputExampleExpander = "/pattern :modify $name"
    case outputExpander = "/output_template"
    
    // MARK: - MdFileTemplateProtocol
    
    var isFileHeader: Bool {
        rawValue.contains(":header")
    }
    
    var isFileName: Bool {
        rawValue.contains(":filename")
    }
    
    var mayRepeat: Bool {
        rawValue.contains(":repeat")
    }
    
    var needModifyParameter: Bool {
        rawValue.contains(":modify")
    }
    
    var cleanPath: String {
        String(rawValue.split(separator: " ")[0])
    }
    
    func text(with element: Any) -> String {
        switch self {
        case .header:
            return """
            # \(element)
            """
        case .description:
            return """
            \(element)
            """
        case .headerExpander:
            return """
            ------
            
            ### \(element)
            """
        case .syntaxExpander:
            return """
            Syntax:
            ```swift
            \(element)
            ```
            """
        case .inputExampleExpander:
            return """
            Input example:
            ```swift
            \(element)
            ```
            """
        case .outputExpander:
            return """
            Output:
            ```swift
            \(element)
            ```
            """
        }
    }
}
