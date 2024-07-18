import SwiftUI
import CocoaLumberjackSwift

@main
struct TrackerForYandexSchoolApp: App {
    @Environment(\.containerDI) var container
    private let networkManager = NetworkManager()
    
    init() {
        setupLogging()
        DDLogInfo("Приложение запущено")
    }
    
    var body: some Scene {
        WindowGroup {
            if UIDevice.current.userInterfaceIdiom == .pad {
                MainViewForIpad(viewModel: MainViewModel(fileCache: container.fileCache))
                    .onAppear {
                        DDLogInfo("Загрузка интерфейса для iPad")
                    }
            } else {
                MainView(viewModel: MainViewModel(fileCache: container.fileCache))
                    .onAppear {
                        DDLogInfo("Загрузка интерфейса для iPhone")
                        Task {
                            await loadToDoList()
                        }
                    }
            }
        }
    }
    
    private func setupLogging() {
        DDLog.add(DDOSLogger.sharedInstance)
        
        let fileLogger: DDFileLogger = DDFileLogger()
        fileLogger.rollingFrequency = TimeInterval(60*60*24 * 7)
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger)
        
        dynamicLogLevel = DDLogLevel.verbose
    }
    private func loadToDoList() async {
        await networkManager.getToDoList { items, error in
            if let error = error {
                DDLogError("Failed to fetch ToDo list: \(error)")
            } else if let items = items {
                DDLogInfo("Fetched ToDo list: \(items)")
            }
        }
    }
}
