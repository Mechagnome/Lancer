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
        commands.map(\.value.encodeData)
    }
    
    
    func index(by id: UUID) -> Int? {
        commands.firstIndex(where: { vm in
            vm.id == id
        })
    }
    
    func item(by id: UUID) -> CommandViewModel? {
        commands.first { vm in
            vm.id == id
        }
    }
    
    func lastItem(by id: UUID) -> CommandViewModel? {
        guard let index = index(by: id) else {
            return nil
        }
        return commands.value(at: max(index - 1, 0))
    }
    
    func nextItem(by id: UUID) -> CommandViewModel? {
        guard let index = index(by: id) else {
            return nil
        }
        return commands.value(at: max(index + 1, 0))
    }
        
    func remove(by id: UUID) {
        commands = commands.filter({ vm in
            vm.id != id
        })
    }
    
    func add(_ command: Command, at index: Int) -> CommandViewModel {
        let new = CommandViewModel(command)
        commands.insert(new, at: index)
        return new
    }
    
    func addTemplateCommand() -> CommandViewModel {
        return add(Command(id: .init(), title: "Title", folder: nil, content: "echo '#1' >> test.txt"), at: 0)
    }
    
}
