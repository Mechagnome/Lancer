//
//  File.swift
//  
//
//  Created by linhey on 2021/10/27.
//

import Foundation
import Combine
import SwiftShell

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
    var folder: URL? {
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
        guard let currentdirectory = self.folder?.path else {
            return ""
        }
        context.currentdirectory = currentdirectory
        let output = context.run(bash: content)
        
        if output.succeeded {
            return output.stdout
        } else if output.stderror.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            try context.runAndPrint(bash: content)
        }
        
        return ""
    }
    
}
