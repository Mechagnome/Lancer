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
import Stem

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
    
}

extension CommandViewModel {
    
    static func selectInFinder(at url: URL?) -> Command.Folder? {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.directoryURL = url
        
        if panel.runModal() == .OK, let url = panel.url {
            return try! .init(url: url)
        }
        
        return nil
    }
    
    func selectInFinder() {
        _ = Self.selectInFinder(at: folder?.url)
    }
    
}

extension CommandViewModel {
    
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
        } else {
            try runTerminal()
            return "success"
        }
    }
    
    func runTerminal() throws {
        
        var commends = [String]()
        
        if let folder = folder {
            commends.append("do script \"cd  \(folder.url.path)\" in front window")
        }
        
        content.split(separator: "\n").forEach { str in
            commends.append("do script \"\(str)\" in front window")
        }
        
        let script = NSAppleScript(source: """
       tell application "Terminal"
       if not (exists window 1) then reopen
       activate
       \(commends.joined(separator: "\n"))
       quit
       end tell
       """)
        
        var error: NSDictionary?
        script?.executeAndReturnError(&error)
        if let message = error?["NSAppleScriptErrorBriefMessage"] as? String,
           let code = error?["NSAppleScriptErrorNumber"] as? Int {
            throw StemError(code: code, message: message)
        }
        
        let quitScript = NSAppleScript(source: """
       tell application "Terminal"
       quit
       end tell
       """)
        
        quitScript?.executeAndReturnError(&error)
    }
    
}
