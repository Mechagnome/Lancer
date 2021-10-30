
import Alliances
import SwiftUI

public class Lancer: AlliancesApp {
    
    public static let appInfo: AppInfo = .init(id: "Lancer", name: "Lancer", icon: nil, summary: "Lancer")
    public var core: AlliancesUICore = .init()
    
    public let configuration: AlliancesConfiguration
    public var canRun: Bool = false
    
    public var name: String = "Lancer"
    
    public var tasks: [AlliancesApp] = []
    
    lazy var vm = MyCommands(configuration.settings["commends"] as? [Data] ?? [])
    
    required public init(_ configuration: AlliancesConfiguration) {
        self.configuration = configuration
        self.tasks = vm.commands.map { vm in
            Task(configuration, viewModel: vm)
        }
    }
    
    public var settingsView: AnyView? {
        get {
            return AnyView(SettingsView(self.vm, closeEvent: { [weak self] in
                guard let self = self else { return }
                self.configuration.settings["commends"] = self.vm.dataForCache
                self.reload()
            }))
        }
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
    
    var name: String { viewModel.title }
    
    let viewModel: CommandViewModel
    
    init(_ configuration: AlliancesConfiguration, viewModel: CommandViewModel) {
        self.configuration = configuration
        self.viewModel = viewModel
    }
    
    init(_ configuration: AlliancesConfiguration) {
        self.configuration = configuration
        self.viewModel = .init(.init(id: .init(), title: "", folder: nil, content: ""))
    }
    
    
    func run() throws {
        try viewModel.run()
    }
    
    
}
