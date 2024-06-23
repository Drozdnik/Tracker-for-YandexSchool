import SwiftUI

struct CreateToDoItem: View {
    @ObservedObject private var viewModel: CreateToDoItemViewModel
    @Environment(\.presentationMode) var createToDoItemPresented
    
    init(viewModel: CreateToDoItemViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(spacing: 16) {
                    TextFieldView(taskData: viewModel)
                        .padding(.horizontal)
                        .background(Color.backgroundColor)
                    
                    ImportanceListView(taskData: viewModel)
                    
                    DeleteButtonView(action: viewModel.deleteButtonTapped)
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                    Spacer()
                }
                .background(Color.backgroundColor)
            }
            .background(Color.backgroundColor)
            .navigationTitle("Дело")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Отменить", action: {
                        createToDoItemPresented.wrappedValue.dismiss()
                    })
                }
                
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Сохранить", action: {
                        viewModel.addItem()
                        createToDoItemPresented.wrappedValue.dismiss()
                    })
                }
            }
        }
    }
}

//#Preview {
//    CreateToDoItem(viewModel: CreateToDoItemViewModel(fileCache: FileCacheImpl(fileName: "ded")))
//}