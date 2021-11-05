//
//  File.swift
//  
//
//  Created by linhey on 2021/10/27.
//

import Foundation
import Combine
import AppKit
import Stem

class MyCommands: ObservableObject {
    
    @Published
    var commands = [CommandViewModel]()
    
    init(_ cache: [Data]) {
        commands = try! cache.map(Command.init(data:)).map(CommandViewModel.init)
    }
    
    var dataForCache: [Data] {
        commands.map(\.value.encodeData)
    }
    
}

extension MyCommands {
    
    func share() {
        guard let file = try? FilePath.Folder(sanbox: .document).file(name: Date().st.stringWith(dateFormat: "yyyy-MM-dd HH-mm-ss") + ".lancer") else {
            return
        }
        try? NSArray(array: commands.map(\.value.encodeData)).write(to: file.url)
        NSWorkspace.shared.activateFileViewerSelecting([file.url])
    }
    
    func importFromFinder() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false
        
        guard panel.runModal() == .OK,
              let url = panel.url,
              let datas = NSArray(contentsOf: url) as? [Data],
              let list = try? datas.compactMap(Command.init(data:)) else {
                  return
              }
        
        self.commands.append(contentsOf: list.map({ item in
            var item = item
            item.id = .init()
            return .init(item)
        }))
    }
    
}


extension MyCommands {
    
    func setFindersForAllCommands() {
        guard let folder = try? CommandViewModel.selectInFinder(at: nil) else {
            return
        }
        commands = commands.map({ vm in
            vm.folder = folder
            return vm
        })
    }
    
}

extension MyCommands {
    
    func index(by id: UUID) -> Int? {
        commands.firstIndex(where: { vm in
            vm.id == id
        })
    }
    
    func moveToUp(by id: UUID?) {
        guard let id = id, let index = index(by: id) else {
            return
        }
        
        commands.swapAt(index, max(index - 1, 0))
    }
    
    func moveToDown(by id: UUID?) {
        guard let id = id, let index = index(by: id) else {
            return
        }
        
        commands.swapAt(index, min(index + 1, commands.count-1))
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
