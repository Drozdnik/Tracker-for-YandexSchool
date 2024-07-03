import SwiftUI
import UIKit

struct CalendarViewControllerRepresentable: UIViewControllerRepresentable {
    var fileCache: FileCache
    
    func updateUIViewController(_ uiViewController: CalendarViewController, context: Context) {
    }

    func makeUIViewController(context: Context) -> CalendarViewController {
        CalendarViewController(fileCache: fileCache)
    }
}
