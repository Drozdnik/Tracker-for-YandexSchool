import SwiftUI

struct MainView:View {
    @State private var isBottomSheetPresented: Bool = false
    @State private var showCalendarView: Bool = false
    @ObservedObject var viewModel: MainViewModel
    @Environment(\.containerDI) var container
    @Environment(\.horizontalSizeClass) var sizeClass
    @State private var itemToEdit: ToDoItem?
    @State private var isEdditing: Bool?
    
    var body: some View {
        NavigationStack{
            ZStack {
                VStack {
                    HStack{
                        Text("Выполнено - \(viewModel.finishedTasks)")
                        Spacer()
                        FilterMenu(viewModel: viewModel)
                    }
                    .padding(.horizontal, 20)
                    List {
                        ForEach(viewModel.items, id: \.id) { item in
                            ListCell(item: item)
                                .swipeActions(edge: .leading, allowsFullSwipe: true){
                                    Button (action: {
                                        viewModel.toogleFlag(for: item.id)
                                    }){
                                        Label("Выполнено", systemImage: "checkmark.circle.fill")
                                    }
                                    .tint(.green)
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive, action: {
                                    }) {
                                        Label("Удалить", systemImage: "trash")
                                    }
                                    Button(action: {
                                        itemToEdit = item
                                        isEdditing = true
                                        isBottomSheetPresented = true
                                    })
                                    {
                                        Label("Редактировать", systemImage: "pencil")
                                    }
                                    .tint(.blue)
                                }
                        }
                        .onDelete(perform: { indexSet in
                            if let index = indexSet.first{
                                viewModel.deleteItem(for: index)
                            }
                        })
                    }
                    .scrollContentBackground(.hidden)
                    .listRowBackground(Color.backgroundColor)
                    .refreshable {
                        viewModel.getItems()
                    }
                }
                .sheet(isPresented: $isBottomSheetPresented, onDismiss: {
                    
                    viewModel.getItems()
                    itemToEdit = nil
                    isEdditing = false
                }){
                    CreateToDoItem(viewModel: CreateToDoItemViewModel(fileCache: container.fileCache, item: itemToEdit))
                }
                VStack{
                    Spacer()
                    PlusView(action: {
                        isBottomSheetPresented = true
                    })
                    .padding(.bottom, 10)
                }
            }
            .navigationTitle("Мои дела")
            .background(Color.backgroundColor)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showCalendarView = true
                    }) {
                        Image(systemName: "calendar")
                    }
                    .padding(.horizontal, 15)
                }
            }
            .fullScreenCover(isPresented: $showCalendarView) {
                NavigationView {
                    CalendarViewControllerRepresentable(fileCache: container.fileCache)
                        .toolbarBackground(Color(UIColor.background), for: .navigationBar)
                        .toolbarBackground(.visible, for: .navigationBar)
                        .ignoresSafeArea()
                }
                .edgesIgnoringSafeArea(.all)
            }
            .onAppear(){
                viewModel.getItems()
            }
        }
    }
}


#Preview {
    MainView(viewModel: MainViewModel(fileCache: FileCacheImpl(fileName: "file")))
}
