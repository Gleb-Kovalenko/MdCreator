//
//  MdCreatorProtocol.swift
//  
//
//  Created by Gleb Kovalenko on 08.08.2022.
//

import Foundation

// MARK: - MdCreatorProtocol

protocol MdCreatorProtocol {
    
    /// Main function, that takes all .tcbundle files from directory, if exists, and then decode, parse and convert data.
    /// Then create .md files with the specified structure.
    /// - Throws: Runtime errors (ex. "files not found", when there are no .tcbundle files in directory), decoder errors (ex. "can't decode file") and so on
    func run() throws
}
