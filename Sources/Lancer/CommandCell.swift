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

struct CommandCell_Previews: PreviewProvider {
    
    static var previews: some View {
        let command = Command(id: .init(),
                              title: "commands",
                              folder: "/user",
                              content: "commands")
        CommandCell(model:  .init(command))
    }
    
}
