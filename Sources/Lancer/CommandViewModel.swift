//
//  File.swift
//  
//
//  Created by linhey on 2021/10/27.
//

import Foundation
import Combine
import SwiftShell
import AppKit

class CommandViewModel: ObservableObject, Identifiable {
    
    var value: Command
    
    var id: UUID { value.id }
    
    @Published
    var title: String {
        didSet {
            value.title = title
        }
    }
    
    @Published
    var content: String {
        didSet {
            value.content = content
        }
    }
    
    @Published
    var folder: Command.Folder? {
        didSet {
            value.folder = folder
        }
    }
    
    init(_ value: Command) {
        self.title = value.title
        self.content = value.content
        self.folder = value.folder
        self.value = value
    }
    
    
    @discardableResult
    func run() throws -> String {
        var context = CustomContext(main)
        
        let customPath = "/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Library/Apple/usr/bin"
        if var paths = context.env["PATH"]?.split(separator: ":") {
            paths = customPath.split(separator: ":") + paths
            context.env["PATH"] = Set(paths).joined(separator: ":")
        } else {
            context.env["PATH"] = customPath
        }
        
        if let folder = folder {
            if let url = try? Command.Folder(bookmark: folder.bookmark).url,
               url.startAccessingSecurityScopedResource() {
                context.currentdirectory = url.path
            }
        }

        let output = context.run("/bin/zsh", "-c", content, combineOutput: false)
        
        if output.succeeded {
            return output.stdout.trimmingCharacters(in: .whitespacesAndNewlines)
        } else if let error = output.error {
            throw error
        } else {
            return ""
        }
    }
    
}
