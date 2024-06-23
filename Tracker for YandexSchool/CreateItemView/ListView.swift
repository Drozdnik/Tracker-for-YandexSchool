import SwiftUI

struct ImportanceListView: View {
    @ObservedObject var taskData: CreateToDoItemViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Важность")
                Spacer()
                SwitcherView(taskData: taskData)
                    .frame(width: 150)
                    .padding(.top, 10)
                    .padding(.bottom, 10)
            }
            .frame(height: 56)
            .padding(.horizontal)
            
            Divider()

            HStack {
                Text("Сделать до")
                Toggle("", isOn: $taskData.deadLineActivate)
            }
            .frame(height: 56)
            .padding(.horizontal)
            
            if taskData.deadLineActivate {
                Divider()
                DatePicker("Выберите дату", selection: $taskData.deadLine, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
//                    .padding()
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.white) 
        )
        .padding(.horizontal)
        .background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
    }
}

//#Preview {
//    ImportanceListView(taskData: CreateToDoItemViewModel())
//}
