//
//  SwiftUIView.swift
//  
//
//  Created by linhey on 2021/10/27.
//

import SwiftUI
import Stem
import AppKit

extension NSTextView {
    
    open override var frame: CGRect {
        didSet {
            backgroundColor = .clear
            drawsBackground = true
        }
    }
    
}

struct SettingsView: View {
    
    @ObservedObject
    private var vm: MyCommands

    @State
    private var selection: UUID? = nil

    let closeEvent: () -> Void
    
    init(_ vm: MyCommands, closeEvent: @escaping () -> Void) {
        self.vm = vm
        self.closeEvent = closeEvent
    }
    
    var body: some View {
        VStack {
            NavigationView {
                List(vm.commands) { command in
                    NavigationLink(tag: command.value.id, selection: $selection) {
                        STLazyView(Content(command))
                    } label: {
                        SettingsView.Cell(command)

                    }.frame(height: 50)
                    Divider()
                        .frame(height: 0.5)
                }
                .onDeleteCommand(perform: {
                    guard let id = selection else {
                        return
                    }
                    vm.remove(by: id)
                })
                .onMoveCommand(perform: { direction in
                    guard let id = selection else {
                        return
                    }
                    switch direction {
                    case .down:
                        selection = vm.nextItem(by: id)?.value.id
                    case .up:
                        selection = vm.lastItem(by: id)?.value.id
                    case .left, .right:
                        break
                    @unknown default:
                        break
                    }
                })
                .frame(minWidth: 220)
                .buttonStyle(PlainButtonStyle())
            }
            
            Divider()
            
            HStack(alignment: .center) {
                
                HStack(spacing: 4.0) {
                    SFSymbol.plus.convert()
                        .font(.title3)
                    Text("add")
                        .font(.title2)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
                .background(Color.gray.opacity(0.5))
                .cornerRadius(4)
                .onTapGesture {
                    let command = vm.addCommand()
                    selection = command.value.id
                }
                
                if let selected = selection {
                    HStack(spacing: 4.0) {
                        SFSymbol.trash.convert()
                            .font(.title3)
                        Text("delete")
                            .font(.title2)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Color.gray.opacity(0.5))
                    .cornerRadius(4)
                    .onTapGesture {
                        selection = vm.lastItem(by: selected)?.value.id
                        vm.remove(by: selected)
                    }
                }
                
                Spacer()
            }
            .padding()
            
            
        }
        .frame(minWidth: 600, minHeight: 400)
        .onAppear {
            self.selection = vm.commands.first?.value.id
        }
        .onDisappear {
            
        }
    }
    
}

private extension SettingsView {
    
    struct Content: View {
        
        private var vm: CommandViewModel
        
        @State
        var title: String
        @State
        var content: String
        @State
        var folder: String
        
        init(_ vm: CommandViewModel) {
            self.vm = vm
            self._title = .init(initialValue: vm.title)
            self._content = .init(initialValue: vm.content)
            self._folder = .init(initialValue: vm.folder?.lastPathComponent ?? "")
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 12.0) {
                Group {
                    Text("Title")
                        .font(.title)
                        .fontWeight(.semibold)
                    TextField("Title", text: $title)
                        .onChange(of: title, perform: { value in
                            vm.title = value
                        })
                        .font(.title3)
                    
                    Divider()
                }
                
                Group {
                    Text("At Folder")
                        .font(.title)
                        .fontWeight(.semibold)
                    
                    HStack(alignment: .center, spacing: 12.0) {
                        Button("Select") {
                            let panel = NSOpenPanel()
                            panel.canChooseFiles = false
                            panel.canChooseDirectories = true
                            panel.allowsMultipleSelection = false
                            panel.directoryURL = vm.folder
                            
                            if panel.runModal() == .OK {
                                folder = panel.url?.lastPathComponent ?? ""
                                vm.folder = panel.url
                            }
                        }
                        
                        if folder.isEmpty == false {
                            Text(folder)
                        }
                        Spacer()
                    }
                    .frame(height: 30.0)
                    .font(.body)
                    
                    Divider()
                }
                
                
                Group {
                    Text("Code")
                        .font(.title)
                        .fontWeight(.semibold)
                    
                    Group {
                        TextEditor(text: $content)
                            .background(Color.gray)
                            .onChange(of: content, perform: { value in
                                vm.content = value
                            })
                            .font(.title3)
                    }
                    .padding(8)
                    .background(Color.gray)
                    .cornerRadius(8)
                }
            }
            .padding()
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
                    SFSymbol.listBulletRectangle
                        .convert()
                        .foregroundColor(Color.white)
                        .font(Font.system(size: 32))
                        .fixedSize()
                    Spacer()
                        .frame(width: 8.0)
                    VStack(alignment: .leading) {
                        Text(model.title)
                            .lineLimit(1)
                            .font(Font.system(size: 18, weight: .medium))
                        Text("at: " + (model.folder?.path ?? ""))
                            .lineLimit(1)
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
        let vm = MyCommands([])
        let list = (0...5)
            .map({ Command(id: .init(),
                           title: "commands\($0)",
                           folder: "/user",
                           content: "commands\($0)") })
            .map({ CommandViewModel($0) })
        
        vm.commands.append(contentsOf: list)
        
        return SettingsView(vm, closeEvent: {})
    }
    
}
