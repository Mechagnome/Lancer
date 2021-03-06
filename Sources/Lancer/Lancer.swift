
import Alliances
import SwiftUI

public class Lancer: AlliancesApp {
    
    public static let appInfo: AppInfo = .init(id: "Lancer", name: "Lancer", icon: nil, summary: "Lancer")
    public var core: AlliancesUICore = .init()
    
    public let configuration: AlliancesConfiguration
    public var canRun: Bool = false
    
    public var name: String = "Lancer"
    
    public var tasks: [AlliancesApp] = []
    public var remark: String?
    
    lazy var vm = MyCommands(configuration.settings["commends"] as? [Data] ?? [])
    
    required public init(_ configuration: AlliancesConfiguration) {
        self.configuration = configuration
        reloadUI()
    }
    
    var isInOneFolder: Bool {
        return Set(vm.commands.compactMap(\.folder?.title)).count == 1
    }
    
    public var settingsView: AnyView? {
        get {
            return AnyView(SettingsView(vm: self.vm, saveEvent: { [weak self] in
                self?.saveAndReload()
            }))
        }
    }
    
    func saveAndReload() {
        self.configuration.settings["commends"] = self.vm.dataForCache
        self.reloadUI()
    }
    
    func reloadUI() {
        self.tasks = vm.commands.map { vm in
            Task(configuration, viewModel: vm, isShowFolder: !isInOneFolder)
        }
        
        if isInOneFolder, let folder = vm.commands.first?.folder {
            self.remark = "at: \(folder.title)"
        } else {
            self.remark = nil
        }
        
        self.reload()
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
    
    var remark: String?
    let viewModel: CommandViewModel
    
    init(_ configuration: AlliancesConfiguration, viewModel: CommandViewModel, isShowFolder: Bool) {
        self.configuration = configuration
        self.viewModel = viewModel
        if isShowFolder, let folder = viewModel.folder {
            self.remark = "at: \(folder.title)"
        }
    }
    
    init(_ configuration: AlliancesConfiguration) {
        self.configuration = configuration
        self.viewModel = .init(.init(id: .init(), title: "", folder: nil, content: ""))
    }
    
    
    func run() throws {
        try viewModel.run()
    }
    
    
}
