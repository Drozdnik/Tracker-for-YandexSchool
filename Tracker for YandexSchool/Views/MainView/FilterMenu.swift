import SwiftUI
import FileCache

struct FilterMenu: View {
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        Menu {
            Button(viewModel.showFinished ? "Скрыть завершенные" : "Показать завершенные", action: {
                viewModel.toggleShowFinished()
            })
            
            Button(viewModel.sortByPriority ? "Сортировать по добавлению" : "Сортировать по приоритету", action: {
                viewModel.toggleSortPreference()
            })
        } label: {
            Label("", systemImage: "slider.horizontal.3")
                .font(.title2) 
        }
    }
}
