//
//  File.swift
//  
//
//  Created by Aaron Ge on 2024/1/31.
//

import Foundation

func readFileContents(atPath path: String) -> String? {
    do {
        let contents = try String(contentsOfFile: path, encoding: .utf8)
        return contents
    } catch {
        print("Error reading file: \(error)")
        return nil
    }
}
