
import Alliances
import SwiftUI

public struct Lancer: AlliancesApp {
    
    public static let appInfo: AppInfo = .init(id: "Lancer", name: "Lancer", icon: nil, summary: "Lancer")
    public var core: AlliancesUICore = .init()

    public let configuration: AlliancesConfiguration
    public var canRun: Bool = false

    public var name: String = "Lancer"
    
    public var tasks: [AlliancesApp] = []
    
    public init(_ configuration: AlliancesConfiguration) {
        self.configuration = configuration
    }
    
    public var settingsView: AnyView? {
        let vm = MyCommands()
        let list = (0...20)
            .map({ Command(id: .init(), title: "commands\($0)", content: "commands\($0)") })
            .map({ CommandViewModel($0, isSelected: false) })
        vm.commands.append(contentsOf: list)
        
        return AnyView(SettingsView(vm))
    }
    
    public func run() throws {
        
    }
    
}
