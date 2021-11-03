import XCTest
import Stem
@testable import Lancer

final class LancerTests: XCTestCase {
    
    let folder = try! Command.Folder(url: URL(fileURLWithPath: "/Users/linhey/Desktop/Mechagnome/Lancer/Tests/TestFolder"))
    
    func testSingleRowShell() throws {
        let output = try CommandViewModel(.init(id: .init(),
                                                title: "title",
                                                folder: folder,
                                                content: "echo $PWD")).run()
        assert(output == folder.url.path)
    }
    
    func testShell() throws {
        let output = try CommandViewModel(.init(id: .init(),
                                                title: "title",
                                                folder: folder,
                                                content: """
                               echo $PWD
                               echo 'And'
                               echo $PWD
""")).run()
        
        assert(output == "\(folder.url.path)\nAnd\n\(folder.url.path)")
    }
    
    func testShell1() throws {
        let filename = "test.txt"
        try CommandViewModel(.init(id: .init(),
                                   title: "title",
                                   folder: folder,
                                   content: "echo '# 1' >> \(filename)")).run()
        let file = FilePath.File(url: folder.url.appendingPathComponent(filename))
        assert(file.isExist)
    }
    
    func testShell2() throws {
        let out = try CommandViewModel(.init(id: .init(),
                                             title: "title",
                                             folder: folder,
                                             content: "where pod")).run()
        assert(out.isEmpty == false)
    }
}
