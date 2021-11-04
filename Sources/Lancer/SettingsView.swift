//
//  SwiftUIView.swift
//  
//
//  Created by linhey on 2021/10/27.
//

import SwiftUI
import Stem
import AppKit
import UniformTypeIdentifiers

extension NSTextView {
    
    open override var frame: CGRect {
        didSet {
            backgroundColor = .clear
            drawsBackground = true
        }
    }
    
}

struct SettingsView: View {
    
    @State
    private var selection: UUID? = nil
    
    @ObservedObject
    var vm: MyCommands
    let saveEvent: () -> Void
    
    enum Prompt {
        case error(String)
        case success(String)
        case message(String)
    }
    
    @State
    var prompt: Prompt?
    
    var toolbar: some View {
        HStack(alignment: .center) {
            if let selected = selection {
                ActionButton(icon: .arrowUp, name: "") {
                    vm.moveToUp(by: selected)
                    Gcd.delay(seconds: 0.001) {
                        selection = selected
                    }
                }
                
                ActionButton(icon: .arrowDown, name: "") {
                    vm.moveToDown(by: selected)
                }
                
                ActionButton(icon: .docOnDoc, name: "Copy") {
                    guard var item = vm.item(by: selected)?.value,
                          let index = vm.index(by: selected) else { return }
                    item.title = item.title + "-copy"
                    item.id = .init()
                    self.selection = item.id
                    Gcd.delay(seconds: 0.001) {
                        _ = vm.add(item, at: index)
                    }
                }
                
                ActionButton(icon: .trash, name: "Delete") {
                    if let id = vm.nextItem(by: selected)?.id {
                        selection = id
                        vm.remove(by: selected)
                    } else {
                        vm.remove(by: selected)
                        selection = vm.commands.last?.id
                    }
                }
            }
            
            Spacer()

            if let selected = selection {
                ActionButton(icon: .play, name: "Run") {
                    do {
                        guard let str = try vm.item(by: selected)?.run() else {
                            return
                        }
                        self.prompt = .success(str.isEmpty ? "success" : str)
                    } catch {
                        self.prompt = .error(error.localizedDescription)
                    }
                }
            }
            
            ActionButton(icon: .handThumbsup, name: "Save") {
                self.saveEvent()
            }
        }
    }
    
    var content: some View {
        NavigationView {
            List(vm.commands) { command in
                NavigationLink(tag: command.id, selection: $selection) {
                    STLazyView(EditCommandView(command))
                } label: {
                    CommandCell(model: command)
                }.frame(height: 50)
            }
            .onMoveCommand(perform: { direction in
                guard let id = selection else {
                    return
                }
                switch direction {
                case .down:
                    selection = vm.nextItem(by: id)?.id
                case .up:
                    selection = vm.lastItem(by: id)?.id
                case .left, .right:
                    break
                @unknown default:
                    break
                }
            })
            .frame(minWidth: 220)
            .buttonStyle(PlainButtonStyle())
        }
        
    }
    
    var navigationView: some View {
        HStack {
            ActionButton(icon: .plus, name: "") {
                let command = vm.addTemplateCommand()
                selection = nil
                Gcd.delay(seconds: 0.001) {
                    selection = command.id
                }
            }
            Spacer()
            if vm.commands.isEmpty == false {
                ActionButton(icon: .folder, name: "Set Folders") {
                    vm.setFindersForAllCommands()
                }
            }
            ActionButton(icon: .squareAndArrowDown, name: "Import") {
                vm.importFromFinder()
            }
            ActionButton(icon: .squareAndArrowUp, name: "Share") {
                vm.share()
            }
        }
    }
    
    var body: some View {
        ZStack {
            HStack {
                VStack {
                    navigationView
                    Divider()
                    content
                    Divider()
                    toolbar
                }
                .frame(minWidth: 600)
                Divider()
                SuggestionView(groups: Suggestion.groups) { command in
                   _ = vm.add(command, at: 0)
                }
            }
            .padding()
            
            if let prompt = self.prompt {
                promptView(prompt)
            }
            
        }
        .frame(minHeight: 600)
        .onAppear {
            self.selection = vm.commands.first?.id
        }
        .onDisappear {
            self.saveEvent()
        }
    }
    
}

private extension SettingsView {

    
}

private extension SettingsView {
    
    func promptView(_ prompt: SettingsView.Prompt) -> some View {
    return VStack {
        HStack {
            Group {
                switch prompt {
                case .error(let string):
                    Text(string)
                        .fontWeight(.medium)
                case .success(let string):
                    Text(string)
                        .fontWeight(.medium)
                case .message(let string):
                    Text(string)
                        .fontWeight(.medium)
                }
            }
            Spacer()
        }
        .font(.body)
        .multilineTextAlignment(.leading)
        .frame(maxWidth: .infinity)
        .padding()
        .background({ () -> Color in
            switch prompt {
            case .error:
                return Color.red.opacity(0.8)
            case .success:
                return Color.green.opacity(0.8)
            case .message:
                return Color.gray.opacity(0.8)
            }
        }())
        .cornerRadius(8)
        Spacer()
    }
    .background(Color.black.opacity(0.8))
    .onTapGesture {
        self.prompt = nil
    }
}

    
}

struct MyCommandView_Previews: PreviewProvider {
    
    static var previews: some View {
        let vm = MyCommands([])
        let list = (0...5)
            .map({ try! Command(id: .init(),
                           title: "commands\($0)",
                           folder: .init(url: FilePath.Folder(sanbox: .cache).url),
                           content: "commands\($0)") })
            .map({ CommandViewModel($0) })
        
        vm.commands.append(contentsOf: list)
        
        return SettingsView(vm: vm, saveEvent: {})
    }
    
}
