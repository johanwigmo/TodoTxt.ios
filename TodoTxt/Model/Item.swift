//
//  Item.swift
//  TodoTxt
//
//  Created by Johan Wigmo on 2025-09-29.
//

import Foundation

protocol Item: Identifiable {
    var id: UUID { get }
    var title: String { get }
}
