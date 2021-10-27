//
//  SwiftUIView.swift
//  
//
//  Created by linhey on 2021/10/27.
//

import SwiftUI
import Stem


struct SettingsView: View {
    
    @ObservedObject
    private var vm: MyCommands
    
    init(_ vm: MyCommands) {
        self.vm = vm
    }
    
    var body: some View {
        HStack {
            UserList(vm)
            .frame(width: 220)
            Content(vm.selectedCommend)
        }
        .frame(minWidth: 600, minHeight: 400)
    }
    
}

private extension SettingsView {
    
    struct Content: View {
        
        @ObservedObject
        private var vm: CommandViewModel

        init(_ vm: CommandViewModel) {
            self.vm = vm
        }
        
        var body: some View {
            VStack {
                TextField("Title", text: $vm.title)
                TextEditor(text:  $vm.content)
            }
        }
        
    }
    
    struct UserList: View {
        
        @ObservedObject
        private var vm: MyCommands
        
        init(_ vm: MyCommands) {
            self.vm = vm
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
                        SettingsView.Cell(command, in: vm)
                    }
                }
            }
            .padding()
            
        }
        
    }
    
    struct Cell: View {
        
        @ObservedObject
        var model: CommandViewModel
        let vm: MyCommands
        
        init(_ model: CommandViewModel, in vm: MyCommands) {
            self.model = model
            self.vm = vm
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
            .background(model.isSelected ? Color.gray.opacity(0.2) : Color.clear)
            .onTapGesture {
                vm.select(model)
            }
        }
    }
    
}

struct MyCommandView_Previews: PreviewProvider {
    
    static var previews: some View {
        let vm = MyCommands()
        let list = (0...20)
            .map({ Command(id: .init(), title: "commands\($0)", content: "commands\($0)") })
            .map({ CommandViewModel($0, isSelected: false) })

        vm.commands.append(contentsOf: list)
        
        return SettingsView(vm)
            .frame(width: 600, height: 400)
    }
    
}
