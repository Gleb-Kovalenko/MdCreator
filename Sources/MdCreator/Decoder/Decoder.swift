//
//  Decoder.swift
//  
//
//  Created by Gleb Kovalenko on 31.07.2022.
//

import Foundation

// MARK: - Decoder

protocol Decoder {
    
    /// Decode data in codable struct
    /// - Parameter data: data from file to decode
    /// - Throws: decoding errors
    /// - Returns: Codable struct
    func decode<T: Codable>(data: Data) throws -> T
}
