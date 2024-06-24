import SwiftUI
enum SwitchcerViewElementEnum: Hashable{
    case text(String)
    case image(String)
   
}
struct SwitcherView: View {
    @ObservedObject var viewModel: CreateToDoItemViewModel

    
    private let icons: [SwitchcerViewElementEnum] = [
        .image("arrow.down"),
        .text("нет"),
        .text("‼️")
    ]
    
    var body: some View {
        VStack {
            Picker("Выберите опцию", selection: $viewModel.selectedIcon) {
                ForEach(icons, id: \.self) { icon in
                    switch icon {
                    case .text(let text):
                        Text(text)
                            .font(.system(size: 15, weight: .regular, design: .default))
                            .multilineTextAlignment(.center)
                            .tag(icon)
                    case .image(let imageName):
                        Image(systemName: imageName)
                            .tag(icon)
                    }
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
        
    }
}

#Preview {
    SwitcherView(viewModel: CreateToDoItemViewModel(fileCache: FileCacheImpl(fileName: "file")))
}
