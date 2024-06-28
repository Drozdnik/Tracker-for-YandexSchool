import SwiftUI
import Combine

struct CreateToDoItem: View {
    @ObservedObject private var viewModel: CreateToDoItemViewModel
    @Environment(\.presentationMode) var createToDoItemPresented
    @State private var orientation: UIDeviceOrientation = UIDevice.current.orientation
    @State private var orientationChangePublisher: AnyCancellable?    
    init(viewModel: CreateToDoItemViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    if orientation.isPortrait {
                        verticalLayout()
                    } else {
                        horizontalLayout(geometry: geometry)
                    }
                }
            }
            .background(Color.backgroundColor)
            .navigationTitle("Дело")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
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
                    .disabled(viewModel.taskName.isEmpty)
                    .opacity(viewModel.taskName.isEmpty ? 0.5 : 1.0)
                }
            }
            .onAppear {
                orientationChangePublisher = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
                    .compactMap { _ in UIDevice.current.orientation }
                    .sink { newOrientation in
                        orientation = newOrientation
                    }
            }
            .onDisappear {
                orientationChangePublisher?.cancel()
            }
        }
    }
    
    private func verticalLayout() -> some View {
        VStack(spacing: 16) {
            TextFieldView(viewModel: viewModel)
                .padding(.horizontal)
                .background(Color.backgroundColor)
            
            ImportanceListView(viewModel: viewModel)
            
            DeleteButtonView(action: viewModel.deleteButtonTapped, viewModel: viewModel)
                .padding(.horizontal)
                .padding(.bottom, 20)
            Spacer()
        }
    }
    
    private func horizontalLayout(geometry: GeometryProxy) -> some View {
        HStack {
            TextFieldView(viewModel: viewModel)
                .padding(.horizontal)
                .background(Color.backgroundColor)
            
            VStack {
                ImportanceListView(viewModel: viewModel)
                DeleteButtonView(action: viewModel.deleteButtonTapped, viewModel: viewModel)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                Spacer()
            }
         
        }
    }
}

// Preview
struct CreateToDoItem_Previews: PreviewProvider {
    static var previews: some View {
        CreateToDoItem(viewModel: CreateToDoItemViewModel(fileCache: FileCacheImpl(fileName: "file")))
    }
}
