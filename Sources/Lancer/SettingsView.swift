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
            ActionButton(icon: .plus, name: "add") {
                let command = vm.addTemplateCommand()
                selection = nil
                Gcd.delay(seconds: 0.1) {
                    selection = command.id
                }
            }
            
            if let selected = selection {
                ActionButton(icon: .docOnDoc, name: "copy") {
                    guard var item = vm.item(by: selected)?.value,
                          let index = vm.index(by: selected) else { return }
                    item.title = item.title + "-copy"
                    item.id = .init()
                    self.selection = item.id
                    Gcd.delay(seconds: 0.1) {
                        _ = vm.add(item, at: index)
                    }
                }
                
                ActionButton(icon: .trash, name: "delete") {
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
                ActionButton(icon: .play, name: "run") {
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
            
            ActionButton(icon: .handThumbsup, name: "save") {
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
                    ZStack {
                        CommandCell(model: command)
                        VStack {
                            Spacer()
                            Divider()
                                .frame(height: 0.5)
                        }
                    }
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
    
    
    var body: some View {
        ZStack {
            VStack {
                content
                Divider()
                toolbar
            }
            .padding()
            
            if let prompt = self.prompt {
                promptView(prompt)
            }
            
        }

        .frame(minWidth: 600, minHeight: 400)
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
        .font(.title)
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
            .map({ Command(id: .init(),
                           title: "commands\($0)",
                           folder: "/user",
                           content: "commands\($0)") })
            .map({ CommandViewModel($0) })
        
        vm.commands.append(contentsOf: list)
        
        return SettingsView(vm: vm, saveEvent: {})
    }
    
}
