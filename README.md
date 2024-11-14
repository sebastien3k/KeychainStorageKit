<img src="Images/logo.png" height="150">

### KeychainStorageKit

Contains a single property wrapper, **`@KeychainStorage`**, for conviently and securely storing sensitive data in the iOS Keychain. 

#### Features

- Simple, declarative syntax similar to `@AppStorage`
- Minimalistic implementation—just a [single file](KeychainStorageKit/KeychainStorage.swift) (should you wish to copy-and-paste!)
- Compatible with Swift 6 and low deployment targets

#### Supported Types

- Basic Types: `String`, `Int`, `Double`, `Bool`
- Foundation Types: `URL`, `Data`
- Custom Types: Any custom type that that conforms to `Codable`

#### Installation

You can integrate `KeychainStorageKit` into your project using Swift Package Manager:

1. In Xcode, select your project in the Project Navigator
2. Go to the Package Dependencies tab
3. Click the + button to add a package dependency
4. In the search bar, enter the repository URL for: `https://github.com/maxhumber/KeychainStorageKit` 

#### Usage

The syntax of **`@KeychainStorage`** is familiar and feels like a close cousin of `@AppStorage`:

```swift
import KeychainStorageKit

func setToken(_ newToken: String) {
    @KeychainStorage("authToken") var token: String?
    token = newToken
}

func getToken() -> String? {
    @KeychainStorage("authToken") var token: String?
    return token
}

func removeToken() {
    @KeychainStorage("authToken") var token: String?
    token = nil
}
```

#### Usage within a SwiftUI App

Here's how you might use the **`@KeychainStorage`** wrapper in a SwiftUI app:

```swift
import KeychainStorageKit
import SwiftUI

// MARK: - API Client
struct FetchClient {
    var fetch: @Sendable () async throws -> String
    
    static let live = FetchClient(
        fetch: {
            @KeychainStorage("token") var token: String?
            let result = "Result from token: [\(token ?? "missing")]" // Use token
            return result
        }
    )
    
    static let preview = FetchClient(
        fetch: {
            try await Task.sleep(for: .seconds(2))
            return "Result for preview [no token]"
        }
    )
}

extension EnvironmentValues {
    @Entry var fetchClient: FetchClient = .live
}

// MARK: - View
struct ContentView: View {
    @Environment(\.fetchClient) var client: FetchClient
    @State var result: String?
    
    var body: some View {
        VStack {
            Text(result ?? "")
            Button("Fetch") {
                Task { await fetch() }
            }
        }
        .task { await tokenRefresh() }
    }
    
    private func fetch() async {
        result = try? await client.fetch()
    }
    
    private func tokenRefresh() async {
        while !Task.isCancelled {
            let newToken = String((0..<5).compactMap { _ in "ABCDEF1234567890".randomElement() })
            print("New token: [\(newToken)]")
            @KeychainStorage("token") var token: String?
            token = newToken // Set token
            try? await Task.sleep(for: .seconds(5))
        }
    }
}

// MARK: - Preview
#Preview {
    ContentView()
        .environment(\.fetchClient, .live) // .environment(\.fetchClient, .preview)
}

// MARK: - Entrypoint
@main
struct KeychainStorageExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

#### Tests

Due to Keychain access requirements, the tests for this package must run against a "TestHost" app (following [this tutorial](https://belief-driven-design.com/testing-swift-packages-with-a-test-host-56bf1/)). To run the tests:

```zsh
make test
```
