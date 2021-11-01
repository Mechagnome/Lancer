import XCTest
import Stem
@testable import Lancer

final class LancerTests: XCTestCase {
    
    let folderPath = URL(fileURLWithPath: "/Users/linhey/Desktop/Mechagnome/Lancer/Tests/TestFolder")
    
    func testSingleRowShell() throws {
        let output = try CommandViewModel(.init(id: .init(),
                                                title: "title",
                                                folder: folderPath,
                                                content: "echo $PWD")).run()
        
        assert(output == folderPath.path)
    }
    
    func testShell() throws {
        let output = try CommandViewModel(.init(id: .init(),
                                                title: "title",
                                                folder: folderPath,
                                                content: """
                               echo $PWD
                               echo 'And'
                               echo $PWD
""")).run()
        
        assert(output == "\(folderPath.path)\nAnd\n\(folderPath.path)")
    }
    
    func testShell1() throws {
        let filename = "test.txt"
        try CommandViewModel(.init(id: .init(),
                                   title: "title",
                                   folder: folderPath,
                                   content: "echo '# 1' >> \(filename)")).run()
        let file = FilePath.File(url: folderPath.appendingPathComponent(filename))
        assert(file.isExist)
    }
}
