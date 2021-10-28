//
//  File.swift
//  
//
//  Created by linhey on 2021/10/27.
//

import Foundation
import Combine

class CommandViewModel: ObservableObject, Identifiable {
    
    var value: Command
    
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
    
    init(_ value: Command) {
        self.title = value.title
        self.content = value.content
        self.value = value
    }
    
    
}
