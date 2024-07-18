import SwiftUI
import FileCache

struct CategoriesView: View {
    @ObservedObject var viewModel: CreateToDoItemViewModel
    @State private var showColorPicker: Bool = false
    @State private var newCategoryName: String = ""
    private var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 1)
    
    init(viewModel: CreateToDoItemViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Категории")
                    .font(.headline)
                    .padding(.leading, 15)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHGrid(rows: columns, spacing: 10) {
                        ForEach(viewModel.categories, id: \.name) { category in
                            CategoryCell(category: category, isSelected: viewModel.selectedCategory?.name == category.name)
                                .onTapGesture {
                                    if category.name == "Другое" {
                                        showColorPicker.toggle()
                                    } else {
                                        viewModel.selectedCategory = category
                                    }
                                }
                        }
                    }
                    .padding(.horizontal, 15)
                }
            }
            .frame(height: 56)
            
            if showColorPicker {
                HStack {
                    TextField("Введите название категории", text: $newCategoryName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button(action: {
                        let newColor = viewModel.pickedColor ?? .clear
                        let newCategory = Categories(name: newCategoryName, color: newColor)
                        viewModel.addCategory(category: newCategory)
                        newCategoryName = ""
                        showColorPicker = false
                    }, label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(viewModel.pickedColor ?? .gray)
                            .padding(.trailing, 10)
                    })
                    
                    CustomColorPicker(viewModel: viewModel)
                }
            }
        }
    }
    
    struct CategoryCell: View {
        let category: Categories
        var isSelected: Bool
        
        var body: some View {
            Text(category.name)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(isSelected ? category.color.opacity(0.5) : category.color)
                .cornerRadius(10)
                .foregroundColor(.black)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isSelected ? Color.black : Color.clear, lineWidth: 2)
                )
        }
    }
    
    #Preview() {
        CategoriesView(viewModel: CreateToDoItemViewModel(fileCache: FileCacheImpl(fileName: "file")))
    }
}
