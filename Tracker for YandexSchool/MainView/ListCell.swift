import SwiftUI

struct ListCell: View {
    var item: ToDoItem
    var body: some View {
        HStack {
            
            Circle()
                .strokeBorder(item.flag ? Color.green : Color.gray, lineWidth: 2)
                .background(Circle().foregroundColor(item.flag ? .green : .clear))
                .frame(width: 24, height: 24)
            
            Text(item.text)
                .foregroundColor(.primary)
                .strikethrough(item.flag, color: .green)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
    }
}
