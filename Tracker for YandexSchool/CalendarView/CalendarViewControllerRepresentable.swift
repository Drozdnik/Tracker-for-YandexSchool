import SwiftUI
import UIKit

struct CalendarViewControllerRepresentable: UIViewControllerRepresentable {
    var fileCache: FileCache
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
    }

    func makeUIViewController(context: Context) -> UINavigationController {
        let calendarViewController = CalendarViewController(fileCache: fileCache)
        calendarViewController.view.backgroundColor = .background
          let navigationController = UINavigationController(rootViewController: calendarViewController)
//          navigationController.navigationBar.prefersLargeTitles = true
        
          return navigationController
      }
  }
