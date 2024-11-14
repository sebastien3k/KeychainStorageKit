import Foundation
import Testing
@testable import KeychainStorageKit

struct KeychainStorageTests {
    @Test func testString() async throws {
        let raw = "xyz"
        @KeychainStorage("string") var string: String?
        string = raw // set
        #expect(string == raw) // get
        string = nil // remove
        #expect(string == nil)
    }
    
    @Test func testBool() async throws {
        let raw = true
        @KeychainStorage("bool") var bool: Bool?
        bool = raw // set
        #expect(bool == raw) // get
        bool = nil // remove
        #expect(bool == nil)
    }
    
    @Test func testInt() async throws {
        let raw = 1
        @KeychainStorage("int") var int: Int?
        int = raw // set
        #expect(int == raw) // get
        int = nil // remove
        #expect(int == nil)
    }
    
    @Test func testDouble() async throws {
        let raw = 1.0
        @KeychainStorage("double") var double: Double?
        double = raw // set
        #expect(double == raw) // get
        double = nil // remove
        #expect(double == nil)
    }
    
    @Test func testURL() async throws {
        let raw = URL(string: "https://example.com")!
        @KeychainStorage("url") var url: URL?
        url = raw // set
        #expect(url == raw) // get
        url = nil // remove
        #expect(url == nil)
    }
    
    @Test func testData() async throws {
        let raw = Data([0x01, 0x02, 0x03])
        @KeychainStorage("data") var data: Data?
        data = raw // set
        #expect(data == raw) // get
        data = nil // remove
        #expect(data == nil)
    }
    
    @Test func testRawRepresentableInt() async throws {
        enum IntEnum: Int, Codable {
            case one = 1
        }
        let raw: IntEnum = .one
        @KeychainStorage("intEnum") var intEnum: IntEnum?
        intEnum = raw // set
        #expect(intEnum == raw) // get
        intEnum = nil // remove
        #expect(intEnum == nil)
    }
    
    @Test func testRawRepresentableString() async throws {
        enum StringEnum: String, Codable {
            case example = "example"
        }
        let raw: StringEnum = .example
        @KeychainStorage("stringEnum") var stringEnum: StringEnum?
        stringEnum = raw // set
        #expect(stringEnum == raw) // get
        stringEnum = nil // remove
        #expect(stringEnum == nil)
    }
}
