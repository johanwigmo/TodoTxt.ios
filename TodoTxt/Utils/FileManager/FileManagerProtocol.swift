//
//  FileManagerProtocol.swift
//  TodoTxt
//
//  Created by Johan Wigmo on 2025-10-13.
//

import Foundation

protocol FileManagerProtocol {
    func load(from url: URL) throws -> [FileLine]
    func save(lines: [FileLine]) throws
}

enum FileManagerError: Error, Equatable {
    case fileNotFound
    case invalidEncoding
    case noFileLoaded
    case writeFailed
}

