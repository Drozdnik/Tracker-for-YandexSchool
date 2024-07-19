import SwiftUI
import FileCache

struct MainViewForIpad: View {
    var viewModel: MainViewModel
    @State private var itemToEdit: ToDoItem?
    @Environment(\.containerDI) private var container
    var body: some View {
        HStack {
            MainView(viewModel: MainViewModel(fileCache: container.fileCache))
            CreateToDoItem(viewModel: CreateToDoItemViewModel(fileCache: container.fileCache, item: itemToEdit, networkManager: container.networkManager))
        }
    }
}
