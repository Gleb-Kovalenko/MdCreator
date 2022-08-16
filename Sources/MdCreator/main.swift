//
//  main.swift
//
//
//  Created by Gleb Kovalenko on 31.07.2022.
//

import Foundation
import ArgumentParser

// MARK: - MdCreator

struct MdCreator: ParsableCommand {
    
    // MARK: - Properties
    
    static let configuration = CommandConfiguration(abstract: "Creating .md files from .tcbundle files", version: "0.0.1")

    @Option(name: .shortAndLong, help: "Directory of .tcbundle files")
    var inDirectory: String = FileManager.default.currentDirectoryPath
    
    @Option(name: .shortAndLong, help: "Directory where the files will save")
    var outDirectory: String = FileManager.default.currentDirectoryPath
    
    @Flag(name: .shortAndLong, help: "Merge all files in one .md file")
    var merge = false

    mutating func run() throws {
        let mdCreatorApp = MdCreatorApp(
            inDirectory: inDirectory,
            outDirectory: outDirectory,
            isNeedToMerge: merge,
            parser: ParserImplementation(),
            textTransformer: TextTransformerImplementation(),
            converter: ConverterImplementation()
        )
        try mdCreatorApp.run()
    }
}

MdCreator.main()
