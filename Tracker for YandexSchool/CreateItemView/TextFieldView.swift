import SwiftUI


struct TextFieldView: View {
    @ObservedObject var viewModel: CreateToDoItemViewModel
    @FocusState private var taskNameIsFocused: Bool
    
    var body: some View {
        VStack {
            TextField("Что надо сделать?", text: $viewModel.taskName, axis: .vertical)
                .focused($taskNameIsFocused)

                .lineLimit(5...Int.max)
                .frame(minHeight: 120)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundStyle(.whiteDarkTheme)
                )
        }
        .background(Color.backgroundColor)
        .cornerRadius(16)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    taskNameIsFocused = false
                    UIApplication.shared.endEditing()
                }
            }
        }
    }
}

//#Preview {
//    TextFieldView(taskData: CreateToDoItemViewModel())
//}
