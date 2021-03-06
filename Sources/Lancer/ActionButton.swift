//
//  SwiftUIView.swift
//  
//
//  Created by linhey on 2021/11/1.
//

import SwiftUI
import Stem

struct ActionButton: View {
    
    let icon: SFSymbol
    let name: String
    let action: () -> Void
    
    @State
    private var tapDown: Bool = false
    
    var body: some View {
        HStack(spacing: 4.0) {
            icon.convert()
                .font(.title3)
            if name.isEmpty == false {
                Text(name)
                    .font(.title2)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 2)
        .background(Color.gray.opacity(tapDown ? 1 : 0.5))
        .cornerRadius(4)
        .gesture(tapGesture)
        
    }
    
    var tapGesture: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged({ _ in
                tapDown = true
            })
            .onEnded({ _ in
                action()
                tapDown = false
            })
    }
    
}

struct ActionButton_Previews: PreviewProvider {
    static var previews: some View {
        ActionButton(icon: .plus, name: "plus", action: { })
    }
}
