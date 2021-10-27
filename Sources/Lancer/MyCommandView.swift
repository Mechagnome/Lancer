//
//  SwiftUIView.swift
//  
//
//  Created by linhey on 2021/10/27.
//

import SwiftUI
import Stem

struct MyCommandView: View {
    
    @ObservedObject
    private var vm: MyCommands
    @State
    var selectedCommand: Command?
    
    init(_ vm: MyCommands) {
        self.vm = vm
        self.selectedCommand = vm.commands.first
    }
    
    var body: some View {
        HStack {
            UserList(vm, selectedCommand: selectedCommand) { command in
                selectedCommand = command
            }
            .frame(width: 220)
            Content(selectedCommand)
        }
    }
    
    
    
    
}

private extension MyCommandView {
    
    struct Content: View {
        
        private var model: Command?
        @State
        private var content: String = ""
        @State
        private var title: String = ""


        init(_ model: Command?) {
            self.model = model
            self.content = model?.content ?? ""
            self.title = model?.title ?? ""
        }
        
        var body: some View {
            VStack {
                TextField("Title", text: $title)
                TextEditor(text: $content)
            }
            
        }
        
    }
    
    struct UserList: View {
        
        @ObservedObject
        private var vm: MyCommands
        let selectedEvent: (Command) -> Void
        let selectedCommand: Command?
        
        init(_ vm: MyCommands,
             selectedCommand: Command?,
             selectedEvent: @escaping (Command) -> Void) {
            self.vm = vm
            self.selectedEvent = selectedEvent
            self.selectedCommand = selectedCommand
        }
        
        var body: some View {
            
            VStack {
                HStack {
                    Text("user")
                        .font(.body)
                    Spacer()
                }
                Divider()
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(vm.commands) { command in
                        MyCommandView.Cell(command,
                                           isSelected: command == selectedCommand,
                                           selectedEvent: selectedEvent)
                    }
                }
            }
            .padding()
            
        }
        
    }
    
    struct Cell: View {
        
        let model: Command
        let selectedEvent: (Command) -> Void
        let isSelected: Bool
        
        init(_ model: Command, isSelected: Bool, selectedEvent: @escaping (Command) -> Void) {
            self.model = model
            self.isSelected = isSelected
            self.selectedEvent = selectedEvent
        }
        
        var body: some View {
            VStack {
                HStack {
                    SFSymbol2.listBulletRectangle.convert().foregroundColor(Color.white)
                    Spacer()
                        .frame(width: 8.0)
                    Text(model.title)
                    Spacer()
                }
                Spacer()
                    .frame(height: 8.0)
                Divider()
            }
            .font(.title)
            .background(isSelected ? Color.gray.opacity(0.2) : Color.clear)
            .onTapGesture {
                selectedEvent(model)
            }
        }
    }
    
}

struct MyCommandView_Previews: PreviewProvider {
    
    static var previews: some View {
        let vm = MyCommands()
        let list = (0...20).map({ Command.init(id: .init(), title: "commands\($0)", content: "commands\($0)") })
        vm.commands.append(contentsOf: list)
        return MyCommandView(vm)
            .frame(width: 600, height: 600)
    }
    
}
