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
    var directory: String = FileManager.default.currentDirectoryPath
    
    @Flag(name: .shortAndLong, help: "Merge all expanders in one .md file")
    var merge = false

    mutating func run() throws {
        let mdCreatorApp = MdCreatorApp(
            directory: directory,
            isNeedToMerge: merge,
            decoder: DecoderImplementation(),
            parser: ParserImplementation(),
            textTransformer: TextTransformerImplementation()
        )
        try mdCreatorApp.run()
    }
}

MdCreator.main()
