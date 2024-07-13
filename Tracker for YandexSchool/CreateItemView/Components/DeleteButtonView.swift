import SwiftUI

struct DeleteButtonView: View {
    private var action: (() -> Void)?
    @ObservedObject private var viewModel: CreateToDoItemViewModel
    
    init(action: (@escaping () -> Void), viewModel: CreateToDoItemViewModel) {
        self.action = action
        self.viewModel = viewModel
    }

    var body: some View {
        
        Button(action: {
            action?()
        }, label: {
            Text("Удалить")
                .foregroundStyle(viewModel.taskName.isEmpty ? .gray : .red)
                .frame(maxWidth: .infinity)
                .padding()
                .background(.whiteDarkTheme)
                .cornerRadius(10)
                .opacity(viewModel.taskName.isEmpty ? 0.5 : 1.0)
        })
        .disabled(viewModel.taskName.isEmpty)
    }
}
