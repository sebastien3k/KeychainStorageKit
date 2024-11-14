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
