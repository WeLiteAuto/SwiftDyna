//
//  File.swift
//  
//
//  Created by Aaron Ge on 2024/2/4.
//

import Collections

public protocol MaterialParser{
    func parser(_ lines: [String], curves: OrderedDictionary<Int, Curve2D>,
                tables: OrderedDictionary<Int, CurveTable>)->DYNAMaterial?
    func splitDataEvery10Characters(_ data: String) -> [String]
}

public extension MaterialParser{
    func splitDataEvery10Characters(_ data: String) -> [String] {
        let strideLength = 10 // Define the length of each chunk
        let chunks = stride(from: 0, to: data.count, by: strideLength).map {
            // Calculate the start index for each chunk
            let startIndex = data.index(data.startIndex, offsetBy: $0)
            // Calculate the end index for each chunk
            let endIndex = data.index(startIndex, offsetBy: strideLength, limitedBy: data.endIndex) ?? data.endIndex
            // Return the substring for each chunk
            return String(data[startIndex..<endIndex])
        }
        return chunks
    }
    
    /// Splits the given string into substrings separated by any whitespace characters,
    /// omitting empty subsequences.
    /// - Parameter string: The string to be split.
    /// - Returns: An array of strings, each representing a substring split by whitespace.
    func splitByWhitespace(_ string: String) -> [String] {
        return string.split(whereSeparator: \.isWhitespace).map(String.init)
    }
}

