import SwiftUI

struct ImportanceListView: View {
    @ObservedObject var viewModel: CreateToDoItemViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Важность")
                Spacer()
                SwitcherView(viewModel: viewModel)
                    .frame(width: 150)
                    .padding(.top, 10)
                    .padding(.bottom, 10)
            }
            .frame(height: 56)
            .padding(.horizontal)
            
            Divider()
            
            HStack {
                VStack(spacing: 2) {
                    Text("Выбрать цвет")
                    
                    if viewModel.colorPickerActivate {
                        if let pickedColor = viewModel.pickedColor {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(pickedColor)
                                .overlay(Text(pickedColor.toHexString()).foregroundColor(.white).bold())
                                .onTapGesture {
                                    viewModel.colorPickerIsShown.toggle()
                                }
                        }
                    }
                }
                
                Toggle("", isOn: $viewModel.colorPickerActivate.animation(.bouncy(duration: 0.7)))
                    .onChange(of: viewModel.colorPickerActivate) {
                        viewModel.colorPickerIsShown = true
                    }
            }
            .frame(height: 56)
            .padding(.horizontal)
            
            if viewModel.colorPickerActivate && viewModel.colorPickerIsShown {
                Divider()
                CustomColorPicker(viewModel: viewModel)
            }
            Divider()
            HStack {
                CategoriesView(viewModel: viewModel)
            }
            HStack {
                VStack {
                    Text("Сделать до")
                    if viewModel.deadLineActivate {
                        if let deadLine = viewModel.deadLine {
                            Text("\(DateFormatter.dayMonthYear.string(from: deadLine))")
                                .foregroundStyle(.blue)
                                .onTapGesture {
                                    withAnimation(.bouncy(duration: 0.7)) {
                                        viewModel.datePickerIsShown.toggle()
                                    }
                                }
                        }
                    }
                }
                Toggle("", isOn: $viewModel.deadLineActivate.animation(.bouncy(duration: 0.7)))
                    .onChange(of: viewModel.deadLineActivate) {
                        if viewModel.deadLineActivate {
                            viewModel.showDatePicker(viewModel.deadLineActivate)
                        }
                    }
            }
            .frame(height: 56)
            .padding(.horizontal)
            
            if viewModel.deadLineActivate && viewModel.datePickerIsShown {
                Divider()
                if let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()) {
                    DatePicker("Выберите дату", selection: Binding(
                        get: { viewModel.deadLine ?? tomorrow },
                        set: {
                            viewModel.deadLine = $0
                            viewModel.datePickerIsShown = true
                        }
                    ),
                               in: Date()...    , displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.whiteDarkTheme)
        )
        .padding(.horizontal)
        .background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
    }
}

#Preview {
    ImportanceListView(viewModel: CreateToDoItemViewModel(fileCache: FileCacheImpl(fileName: "file")))
}
