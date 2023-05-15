import SwiftUI

@main
struct denemeApp: App {
    @StateObject private var userData = UserData.shared // Use the shared instance

    var body: some Scene {
        WindowGroup {
            NavView()
                .environmentObject(userData) // Inject UserData into the environment
        }
    }
}

