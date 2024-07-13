import SwiftUI
import FileCache

struct CustomColorPicker: View {
    @ObservedObject var viewModel: CreateToDoItemViewModel
    @State private var brightness: CGFloat = 1.0
    @State private var currentPoint = CGPoint(x: 150, y: 150)
    
    init(viewModel: CreateToDoItemViewModel) {
        self.viewModel = viewModel
        self.currentPoint = currentPoint
    }
    var body: some View {
        VStack {
            GeometryReader { geometry in
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(
                                colors: [
                                    .red,
                                    .orange,
                                    .yellow,
                                    .green,
                                    .blue,
                                    .purple
                                ]
                            ),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .mask(
                        LinearGradient(gradient: Gradient(colors: [Color.white, Color.white.opacity(0)]), startPoint: .top, endPoint: .bottom)
                    )
                    .brightness(Double(brightness - 1))
                    .gesture(
                        DragGesture().onChanged { value in
                            self.currentPoint = value.location
                            viewModel.pickedColor = getColor(at: value.location, in: geometry.size)
                        }
                    )
            }
            .frame(height: 300)
            
            Slider(value: $brightness, in: 0...1, step: 0.01)
                .padding()
                .onChange(of: brightness) {
                    viewModel.pickedColor = getColor(at: currentPoint, in: CGSize(width: 300, height: 300))
                }
        }
    }
    
    func getColor(at point: CGPoint, in size: CGSize) -> Color {
        let hue = Double(point.x / size.width)
        let saturation = Double(1 - point.y / size.height)
        return Color(hue: hue, saturation: saturation, brightness: Double(brightness))
    }
}

#Preview{
    CustomColorPicker(viewModel: CreateToDoItemViewModel(fileCache: FileCacheImpl(fileName: "file")))
}
