import SwiftUI

@main
struct Tracker_for_YandexSchoolApp: App {
    @Environment(\.containerDI) var container
    
    var body: some Scene {
        WindowGroup {
            MainView(viewModel: MainViewModel(fileCache: container.fileCache))
        }
    }
}
