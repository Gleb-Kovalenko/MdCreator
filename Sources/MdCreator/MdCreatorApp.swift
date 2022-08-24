//
//  MdCreatorApp.swift
//  
//
//  Created by Gleb Kovalenko on 08.08.2022.
//

import Foundation

// MARK: - MdCreatorApp

final class MdCreatorApp<ParserType, TextTransformerType, ConverterType>
    where
        ParserType: Parser,
        TextTransformerType: TextTransformer,
        ConverterType: Converter {
        
    // MARK: - Properties
            
    /// Parser instance
    private let parser: ParserType
    
    /// Text transformer instance
    private let textTransformer: TextTransformerType
    
    /// Converter instance
    private let converter: ConverterType
    
    /// Directory with files
    private let inDirectory: String
    
    /// Directory where the files will save
    private let outDirectory: String
        
    /// Indicates whether files should be combined into a single .md file
    private let isNeedToMerge: Bool
    
    /// Default initializer
    /// - Parameters:
    ///   - inDirectory: Directory with files
    ///   - outDirectory: Directory where the files will save
    ///   - isNeedToMerge: Indicates whether files should be combined into a single .md file
    ///   - parser: Parser instance
    ///   - textTransformer: Text tranformer instance
    ///   - converter: Converter instance
    init(
        inDirectory: String,
        outDirectory: String,
        isNeedToMerge: Bool,
        parser: ParserType,
        textTransformer: TextTransformerType,
        converter: ConverterType
    ) {
        self.inDirectory = inDirectory
        self.outDirectory = outDirectory
        self.isNeedToMerge = isNeedToMerge
        self.parser = parser
        self.textTransformer = textTransformer
        self.converter = converter
    }

    /// Main function, that takes all .tcbundle files from directory, if exists, and then decode, parse and convert data.
    /// Then create .md files with the specified structure.
    /// - Throws: Runtime errors (ex. "files not found", when there are no .tcbundle files in directory), decoder errors (ex. "can't decode file") and so on
    func run() throws {
        
        var requiredParameters: [String: String] = [:]
        var modifiedFiles: [Parameters] = []
        var parsedFiles: [Parameters] = []
        
        let bundleFiles = try bundleFiles(from: inDirectory)
        if bundleFiles.count == 0 {
            throw RuntimeError.filesNotFound
        }
        
        for bundleFile in bundleFiles {
            if let jsonData = try String(contentsOfFile: "\(inDirectory)/\(bundleFile)").data(using: .utf8) {
                guard let parsedData = try JSONSerialization.jsonObject(with: jsonData) as? Parameters else {
                    throw RuntimeError.parseError(file: bundleFile)
                }
                parsedFiles.append(parsedData)
                requiredParameters.merge(parser.requiredParameters(from: parsedData)) { (current, _) in current }
            }
        }
        
        for parameterName in requiredParameters.keys {
            print("Enter name for '\(parameterName)' parameter: ", terminator: "")
            let enteredName = readLine()
            requiredParameters[parameterName] = enteredName
        }
        
        for parsedFile in parsedFiles {
            modifiedFiles.append(try textTransformer.modifyText(in: parsedFile, with: requiredParameters))
        }

        let convertedFiles = try converter.convert(
            files: modifiedFiles,
            parameters: requiredParameters,
            isNeedToMerge: isNeedToMerge,
            template: MdFileTemplate.self
        )
        
        try createMdFiles(files: convertedFiles)
        print("Success")
        
    }
    
    // MARK: - Private
    
    /// Retrieves all .tcbundle files from a directory
    /// - Parameter directory: Directory where .tcbundle files are located
    /// - Throws: FileManager errors
    /// - Returns: Array of .tcbundle files names
    private func bundleFiles(from directory: String) throws -> [String] {
        let filesInDirectory = try FileManager.default.contentsOfDirectory(atPath: directory)
        return filesInDirectory.filter { $0.hasSuffix(".tcbundle") }
    }
    
    /// Create md files
    /// - Parameter text: Dictionary with names and parts of the text that will be in the files
    /// - Throws: File not created error
    private func createMdFiles(files: [String: String]) throws {
        let fileManager = FileManager.default
        for (mdFilename, fileContent) in files {
            let filePath = outDirectory + "/\(mdFilename).md"
            if (fileManager.createFile(atPath: filePath, contents: fileContent.data(using: .utf8))) {
                print("File created successfully.")
            } else {
                throw RuntimeError.fileNotCreated
            }
        }
    }
}
