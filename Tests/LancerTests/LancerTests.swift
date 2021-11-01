import XCTest
@testable import Lancer

final class LancerTests: XCTestCase {
    
    func testSingleRowShell() throws {
      let output = try CommandViewModel(.init(id: .init(),
                               title: "title",
                               folder: .init(fileURLWithPath: "/Users/linhey/Desktop/AxApp/books/Swift"),
                               content: "echo $PWD")).run()
        
        assert(output == "/Users/linhey/Desktop/AxApp/books/Swift")
    }
    
    func testShell() throws {
      let output = try CommandViewModel(.init(id: .init(),
                               title: "title",
                               folder: .init(fileURLWithPath: "/Users/linhey/Desktop/AxApp/books/Swift"),
                               content: """
                               echo $PWD
                               echo 'And'
                               echo $PWD
""")).run()
        
        assert(output == "/Users/linhey/Desktop/AxApp/books/Swift\nAnd\n/Users/linhey/Desktop/AxApp/books/Swift")
    }
    
}
