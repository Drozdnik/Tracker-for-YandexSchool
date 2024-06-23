import SwiftUI

struct ListCell: View {
    var item: ToDoItem
    
    var body: some View {
        HStack {
            if item.flag {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .font(.system(size: 24))
            } else {
                Circle()
                    .strokeBorder(Color.gray, lineWidth: 2)
                    .frame(width: 24, height: 24)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.text)
                    .foregroundColor(.primary)
                    .strikethrough(item.flag, color: .gray)
                    .lineLimit(3)
                    .truncationMode(.tail)
                
                if let deadLine = item.deadLine {
                    HStack(spacing: 2){
                        Image(systemName: "calendar")
                            .foregroundColor(.gray)
                            .font(.caption)
                        Text(DateFormatter.dayMonth.string(from: deadLine))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
    }
}
