//
//  File.swift
//  
//
//  Created by linhey on 2021/10/27.
//

import Foundation
import Combine
import SwiftUI

class CommandViewModel: ObservableObject, Identifiable {
    
    var value: Command
    
    var isSelected: Bool {
        didSet {
            objectWillChange.send()
        }
    }
    
    @Published
    var title: String = "" {
        didSet {
            value.title = title
        }
    }
    @Published
    var content: String = "" {
        didSet {
            value.content = content
        }
    }
    
    init(_ value: Command, isSelected: Bool) {
        self.title = value.title
        self.content = value.content
        self.value = value
        self.isSelected = isSelected
    }
    
    
}
