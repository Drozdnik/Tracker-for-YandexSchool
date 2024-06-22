import SwiftUI

struct ImportanceListView: View {
    @ObservedObject var taskData: ObservabToDoItem
    
    var body: some View {
        
        List {
            HStack{
                Text ("Важность")
                Spacer()
                SwitcherView(taskData: taskData)
                    .frame(width: 150)
                    .padding(.top, 10)
                    .padding(.bottom, 10)
            }
                        .frame(height: 56)
                    
            
            HStack{
                Text("Сделать до")
                Toggle("", isOn: $taskData.deadLineActivate)
            }
                        .frame(height: 56)
                        
            if taskData.deadLineActivate {
                DatePicker("Выберите дату", selection: $taskData.dueDate, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
        }
        .listStyle(InsetGroupedListStyle())
        .padding(-20)
        .background(Color.backgroundColor)
        
    }
}

#Preview {
    ImportanceListView(taskData: ObservabToDoItem())
}

