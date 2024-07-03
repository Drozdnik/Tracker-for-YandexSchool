import SwiftUI

@main
struct Tracker_for_YandexSchoolApp: App {
    @Environment(\.containerDI) var container
    
    var body: some Scene {
        WindowGroup {
//            if UIDevice.current.userInterfaceIdiom == .pad {
//                MainViewForIpad(viewModel: MainViewModel(fileCache: container.fileCache))
//            } else {
//                MainView(viewModel: MainViewModel(fileCache: container.fileCache))
//            }
            
            CalendarViewControllerRepresentable(fileCache: container.fileCache)
        }
    }
}
