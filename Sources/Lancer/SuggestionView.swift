//
//  SwiftUIView.swift
//  
//
//  Created by linhey on 2021/11/4.
//

import SwiftUI

struct SuggestionView: View {
    
    let groups: [Suggestion]
    let selectEvent: (Command) -> Void
    
    @State
    var playNotificationSounds = false
    
    var body: some View {
        VStack {
            HStack {
                Text("Suggestion")
                    .fontWeight(.semibold)
                Spacer()
            }
            .font(.title)
            .padding()
            List(groups) { suggestion in
                Section(header: Text(suggestion.id)) {
                    ForEach(suggestion.commands) { command in
                        CommandCell(model: .init(command))
                            .onTapGesture {
                                var command = command
                                command.id = .init()
                                selectEvent(command)
                            }
                    }
                }
            }
        }
        .frame(width: 220)
    }
    
}

struct SuggestionView_Previews: PreviewProvider {
    static var previews: some View {
        SuggestionView(groups: Suggestion.groups, selectEvent: { item in
            
        })
    }
}
