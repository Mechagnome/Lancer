//
//  File.swift
//  
//
//  Created by linhey on 2021/10/27.
//

import Foundation
import Combine

class MyCommands: ObservableObject {
    
    @Published
    var commands = [CommandViewModel]()
    
    init(_ cache: [Data]) {
        commands = cache.map({ try! JSONDecoder().decode(Command.self, from: $0) }).map(CommandViewModel.init)
    }
        
    var dataForCache: [Data] {
        commands.map(\.value).map({ try! JSONEncoder().encode($0) })
    }
    
    
    func index(by id: UUID) -> Int? {
        commands.firstIndex(where: { vm in
            vm.value.id == id
        })
    }
    
    func lastItem(by id: UUID) -> CommandViewModel? {
        guard let index = index(by: id) else {
            return nil
        }
        if index == 0 {
            return commands.value(at: 1)
        } else {
            return commands.value(at: max(index - 1, 0))
        }
    }
        
    func remove(by id: UUID) {
        commands = commands.filter({ vm in
            vm.value.id != id
        })
    }
    
    func addCommand() -> CommandViewModel {
        let new = CommandViewModel(.init(id: .init(), title: "Title", folder: nil, content: "Shell"))
        commands = [new] + commands
        return new
    }
    
}
