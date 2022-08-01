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

    /// Main function, that takes all .tcbundle files from directory, if exists, and then decode, parse and convert data
    /// Then create .md files with the specified structure
    /// - Throws: Runtime errors (ex. "files not found", when there are no .tcbundle files in directory), decoder errors (ex. "can't decode file") and so on
    mutating func run() throws {
        let bundleFiles = try filesFrom(directory: directory)
        if bundleFiles.count == 0 {
            throw RuntimeError.filesNotFound
        }
        let decoder = BundleDecoderImplementation()
        for file in bundleFiles {
            if let jsonData = try String(contentsOfFile: "\(directory)/\(file)").data(using: .utf8){
                let decodedData: TCBundle = try decoder.decode(data: jsonData)
                print(decodedData)
                print("\n\n\n\n\n")
            }
        }
    }
    
    // MARK: - Private
    
    /// Retrieves all .tcbundle files from a directory
    /// - Parameter directory: Directory where .tcbundle files are located
    /// - Throws: FileManager errors
    /// - Returns: Array of .tcbundle files names
    private func filesFrom(directory: String) throws -> [String] {
        let filesInDirectory = try FileManager.default.contentsOfDirectory(atPath: directory)
        return filesInDirectory.filter { $0.hasSuffix(".tcbundle") }
    }
}

MdCreator.main()
