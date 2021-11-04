//
//  File.swift
//  
//
//  Created by linhey on 2021/11/4.
//

import Foundation


struct Suggestion: Identifiable {
    
    var id: String
    let commands: [Command]
    
    static var groups: [Suggestion] {
        [
            .init(id: "Folder", commands: [
                .init(id: .init(), title: "Open In Finder", folder: nil, content: "open ./"),
            ]),
            .init(id: "iOS", commands: [
                .init(id: .init(), title: "Pod Install", folder: nil, content: "pod install"),
                .init(id: .init(), title: "Pod Update", folder: nil, content: "pod update"),
            ])
        ]
    }
    
}
