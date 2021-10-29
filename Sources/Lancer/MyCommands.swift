//
//  File.swift
//  
//
//  Created by linhey on 2021/10/27.
//

import Foundation
import Combine

class MyCommands: ObservableObject {
    
    var commands = [CommandViewModel]()
    
    init(_ cache: [Data]) {
        commands = cache.map({ try! JSONDecoder().decode(Command.self, from: $0) }).map(CommandViewModel.init)
        
    }
        
    var dataForCache: [Data] {
        commands.map(\.value).map({ try! JSONEncoder().encode($0) })
    }
    
}
