import SwiftUI

struct MainView:View {
    @State private var isBottomSheetPresented: Bool = false
    @ObservedObject var viewModel: MainViewModel
    @Environment(\.containerDI) var container
    
    var body: some View {
        NavigationStack{
            ZStack {
                VStack {
                    List {
                        ForEach(viewModel.items, id: \.id) { item in
                            Text("\(item.text)")
                                .foregroundColor(item.flag ? .green : .gray)
                        }
                        .onDelete(perform: { indexSet in
                            print("Я удаляюсь")
                        })
                    }
                }
                .sheet(isPresented: $isBottomSheetPresented, onDismiss: viewModel.getItems, content: {
                    
                    CreateToDoItem(viewModel: CreateToDoItemViewModel(fileCache: container.fileCache))
                })
                
                VStack{
                    Spacer()
                    Button(action: {
                        isBottomSheetPresented = true
                    }) {
                        PlusView()
                            .frame(width: 44, height: 44)
                            .background(Color.blue)
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 5)
                    }
                    
                    .padding(.bottom, 10)
                }
            }
    }
    }
}

#Preview {
    MainView(viewModel: MainViewModel(fileCache: FileCacheImpl(fileName: "file")))
}
