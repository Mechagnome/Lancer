//
//  File.swift
//  
//
//  Created by linhey on 2021/10/27.
//

import Foundation
import Combine

class MyCommands: ObservableObject {
    
    var commands = [CommandViewModel]()
    var selectedCommend = CommandViewModel(.init(id: .init(), title: "", content: ""), isSelected: true)
    
    func select(_ command: CommandViewModel) {
        commands.forEach { model in
            if model.isSelected, model.value != command.value {
                model.isSelected = false
            }
        }
        command.isSelected = true
        selectedCommend = command
        objectWillChange.send()
    }
    
}
