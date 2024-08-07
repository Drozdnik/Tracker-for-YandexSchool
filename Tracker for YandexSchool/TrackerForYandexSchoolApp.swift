import SwiftUI
import CocoaLumberjackSwift
import FileCache
@main
struct TrackerForYandexSchoolApp: App {
    @Environment(\.containerDI) var container
    
    init() {
        setupLogging()
        DDLogInfo("Приложение запущено")
    }
    
    var body: some Scene {
        WindowGroup {
            if UIDevice.current.userInterfaceIdiom == .pad {
                MainViewForIpad(viewModel: MainViewModel(fileCache: container.fileCache, networkManager: container.networkManager))
                    .onAppear {
                        DDLogInfo("Загрузка интерфейса для iPad")
                    }
            } else {
                MainView(viewModel: MainViewModel(fileCache: container.fileCache, networkManager: container.networkManager))
                    .onAppear {
                        DDLogInfo("Загрузка интерфейса для iPhone")
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
}
