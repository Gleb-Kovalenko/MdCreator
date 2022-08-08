//
//  DecoderImplementation.swift
//  
//
//  Created by Gleb Kovalenko on 31.07.2022.
//

import Foundation

// MARK: - DecoderImplementation

final class DecoderImplementation {
    
}

// MARK: - Decoder

extension DecoderImplementation: Decoder {
    
    func decode<T: Codable>(data: Data) throws -> T {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(T.self, from: data)
    }
}
