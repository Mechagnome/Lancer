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
    
    init(id: UUID, title: String, folder: URL? = nil, content: String) {
        self.id = id
        self.title = title
        self.folder = folder
        self.content = content
    }
    
    var encodeData: Data {
        try! JSONEncoder().encode(self)
    }
    
}
