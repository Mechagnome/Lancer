//
//  SwiftUIView.swift
//  
//
//  Created by linhey on 2021/11/1.
//

import SwiftUI
import Stem

struct EditCommandView: View {
    
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
        self._folder = .init(initialValue: vm.folder?.url.lastPathComponent ?? "")
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
                        vm.selectInFinder()
                    }
                    
                    if let folder = vm.folder {
                        Text(folder.title)
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

struct EditCommandView_Previews: PreviewProvider {
    
    static var previews: some View {
        let command = try! Command(id: .init(),
                                   title: "commands",
                                   folder: .init(url: FilePath.Folder(sanbox: .cache).url),
                                   content: "commands")
        return EditCommandView(.init(command))
    }
}
