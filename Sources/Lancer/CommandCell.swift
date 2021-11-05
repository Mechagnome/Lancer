//
//  SwiftUIView.swift
//  
//
//  Created by linhey on 2021/11/1.
//

import SwiftUI
import Stem

struct CommandCell: View {
    
    @ObservedObject
    var model: CommandViewModel
    
    var body: some View {
        ZStack {
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
                        if let folder = model.folder {
                            Text(model.folderNeedsReselected ? "重新选择文件夹" : "at: \(folder.title)")
                                .lineLimit(1)
                                .multilineTextAlignment(.leading)
                                .font(Font.system(size: 12, weight: .light))
                                .background(model.folderNeedsReselected ? Color.red : Color.clear)
                        }
                        
                    }
                    Spacer()
                }
                Spacer()
                    .frame(height: 8.0)
            }
            .font(.title)
            
            VStack {
                Spacer()
                Divider()
                    .frame(height: 0.5)
            }
        }
    }
    
}

struct CommandCell_Previews: PreviewProvider {
    
    static var previews: some View {
        let command = try! Command(id: .init(),
                                   title: "commands",
                                   folder: .init(url: FilePath.Folder(sanbox: .cache).url),
                                   content: "commands")
        CommandCell(model:  .init(command))
    }
    
}
