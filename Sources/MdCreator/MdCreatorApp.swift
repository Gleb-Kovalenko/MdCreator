//
//  MdCreatorApp.swift
//  
//
//  Created by Gleb Kovalenko on 08.08.2022.
//

import Foundation

// MARK: - MdCreatorApp

final class MdCreatorApp<DecoderType, ParserType, TextTransformerType>
    where
        DecoderType: Decoder,
        ParserType: Parser,
        TextTransformerType: TextTransformer {
        
    // MARK: - Properties
        
    /// Decoder instance
    private let decoder: DecoderType
    
    /// Parser instance
    private let parser: ParserType
    
    /// Test transformer instance
    private let textTransformer: TextTransformerType
    
    /// Directory with files
    private let directory: String
        
    /// Indicates whether the expanders in the file should be combined into a single .md file
    private let isNeedToMerge: Bool
    
    /// Default initializer
    /// - Parameters:
    ///   - directory: Directory with files
    ///   - isNeedToMerge: Indicates whether the expanders in the file should be combined into a single .md file
    ///   - decoder: Decoder instance
    ///   - parser: Parser instance
    ///   - textTransformer: Text tranformer instance
    init(
        directory: String,
        isNeedToMerge: Bool,
        decoder: DecoderType,
        parser: ParserType,
        textTransformer: TextTransformerType
    ) {
        self.directory = directory
        self.isNeedToMerge = isNeedToMerge
        self.decoder = decoder
        self.parser = parser
        self.textTransformer = textTransformer
    }

    /// Main function, that takes all .tcbundle files from directory, if exists, and then decode, parse and convert data.
    /// Then create .md files with the specified structure.
    /// - Throws: Runtime errors (ex. "files not found", when there are no .tcbundle files in directory), decoder errors (ex. "can't decode file") and so on
    func run() throws {
        
        var requiredParameters: [String: String] = [:]
        var modifiedFiles: [Parameters] = []
        var parsedFiles: [Parameters] = []
        
        let bundleFiles = try bundleFiles(from: directory)
        if bundleFiles.count == 0 {
            throw RuntimeError.filesNotFound
        }
        for bundleFile in bundleFiles {
            if let jsonData = try String(contentsOfFile: "\(directory)/\(bundleFile)").data(using: .utf8) {
                guard let parsedData = try JSONSerialization.jsonObject(with: jsonData) as? Parameters else {
                    throw RuntimeError.parseError(file: bundleFile)
                }
                let decodedData: TCBundle = try decoder.decode(data: jsonData)
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
        print(modifiedFiles)
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
}
