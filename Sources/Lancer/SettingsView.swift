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
        NavigationView {
            List(vm.commands) { command in
                NavigationLink(destination: {
                    Content(command)
                }, label: {
                    SettingsView.Cell(command)
                })
                .frame(height: 50)
                Divider()
                    .frame(height: 0.5)
            }
            .frame(width: 220)
            .buttonStyle(PlainButtonStyle())
        }
        .frame(minWidth: 600, minHeight: 400)
    }
    
}

private extension SettingsView {
    
    struct Content: View {
        
        private var vm: CommandViewModel
        
        @State
        var title: String
        @State
        var content: String
        
        init(_ vm: CommandViewModel) {
            self.vm = vm
            self._title = .init(initialValue: vm.title)
            self._content = .init(initialValue: vm.content)
        }
        
        var body: some View {
            VStack {
                TextField("Title", text: $title)
                    .onChange(of: title, perform: { value in
                        vm.title = value
                    })

                TextEditor(text: $content)
                    .onChange(of: content, perform: { value in
                        vm.content = value
                    })
            }
        }
        
    }
    
    struct Cell: View {
        
        @ObservedObject
        var model: CommandViewModel
        
        init(_ model: CommandViewModel) {
            self.model = model
        }
        
        var body: some View {
            VStack {
                HStack {
                    SFSymbol2.listBulletRectangle
                        .convert()
                        .foregroundColor(Color.white)
                        .font(Font.system(size: 32))
                        .fixedSize()
                    Spacer()
                        .frame(width: 8.0)
                    VStack(alignment: .leading) {
                        Text(model.title)
                            .font(Font.system(size: 18, weight: .medium))
                        Text(model.content)
                            .font(Font.system(size: 12, weight: .light))
                    }
                    Spacer()
                }
                Spacer()
                    .frame(height: 8.0)
            }
            .font(.title)
        }
    }
    
}

struct MyCommandView_Previews: PreviewProvider {
    
    static var previews: some View {
        let vm = MyCommands()
        let list = (0...5)
            .map({ Command(id: .init(), title: "commands\($0)", content: "commands\($0)") })
            .map({ CommandViewModel($0) })

        vm.commands.append(contentsOf: list)
        
        return SettingsView(vm)
            .frame(width: 600, height: 400)
    }
    
}
