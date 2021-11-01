//
//  File.swift
//  
//
//  Created by linhey on 2021/10/27.
//

import Foundation

struct Command: Codable, Equatable, Identifiable {

    struct Folder: Codable, Equatable {
        
        let url: URL
        let bookmark: Data
        
        init(url: URL) throws {
            self.bookmark = try url.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
            self.url = url
        }
        
        init(bookmark: Data) throws {
            self.bookmark = bookmark
            var isStale = false
            self.url = try URL(resolvingBookmarkData: bookmark, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &isStale)
        }
        
        init(url: URL, bookmark: Data) {
            self.url = url
            self.bookmark = bookmark
        }
        
    }
    
    var id: UUID
    var title: String
    var folder: Folder?
    var content: String
    
    init(id: UUID, title: String, folder: Folder? = nil, content: String) {
        self.id = id
        self.title = title
        self.folder = folder
        self.content = content
    }
    
    var encodeData: Data {
        try! JSONEncoder().encode(self)
    }
    
}
