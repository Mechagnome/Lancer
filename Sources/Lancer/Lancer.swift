
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
        let vm = MyCommands(configuration.settings["commends"] as? [Data] ?? [])
        return AnyView(SettingsView(vm).onDisappear(perform: {
            configuration.settings["commends"] = vm.dataForCache
        }))
    }
    
    public func run() throws {
        
    }
    
}

struct Task: AlliancesApp {
    
    public static let appInfo: AppInfo = .init(id: "lancer.task", name: "lancer.task")
    var core: AlliancesUICore = .init()
    var configuration: AlliancesConfiguration
    var tasks: [AlliancesApp] = []
    var canOpenSettings: Bool = false
    
    var name: String
    
    init(_ configuration: AlliancesConfiguration, name: String) {
        self.configuration = configuration
        self.name = name
    }
    
    init(_ configuration: AlliancesConfiguration) {
        self.configuration = configuration
        self.name = ""
    }
    
    
    func run() throws {

        
    }
    
    
}
