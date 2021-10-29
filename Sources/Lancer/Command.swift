//
//  File.swift
//  
//
//  Created by linhey on 2021/10/27.
//

import Foundation

struct Command: Codable, Equatable, Identifiable {
        
    var id: UUID
    var title: String
    var folder: URL?
    var content: String
    
}
