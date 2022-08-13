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
    
    case header = "name :header"
    case description = "description :header"
    case headerExpander = "/name"
    case syntaxExpander = "/pattern"
    case inputExampleExpander = "/pattern :modify $name"
    case outputExpander = "/output_template"
    
    func printText(with element: Any) -> String {
        switch self{
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
