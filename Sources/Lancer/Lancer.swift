
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
        .init(SettingsView(.init()))
    }
    
    public func run() throws {
        
    }
    
}
