import SwiftUI

struct ListCell: View {
    var item: ToDoItem
    
    var body: some View {
        HStack {
            if item.flag {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                    .font(.system(size: 24))
            } else {
                Circle()
                    .strokeBorder(Color.gray, lineWidth: 2)
                    .frame(width: 24, height: 24)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.text)
                    .foregroundStyle(.primary)
                    .strikethrough(item.flag, color: .gray)
                    .lineLimit(3)
                    .truncationMode(.tail)
                
                if let deadLine = item.deadLine {
                    HStack(spacing: 2){
                        Image(systemName: "calendar")
                            .foregroundStyle(.gray)
                            .font(.caption)
                        Text(DateFormatter.dayMonth.string(from: deadLine))
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundStyle(.gray)
        }
        .padding(.vertical, 8)
    }
}
