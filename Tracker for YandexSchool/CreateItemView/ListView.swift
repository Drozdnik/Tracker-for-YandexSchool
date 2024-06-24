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
                VStack{
                    Text("Сделать до")
                    if taskData.deadLineActivate {
                        if let deadLine = taskData.deadLine{
                            Text("\(DateFormatter.dayMonth.string(from: deadLine))")
                                .foregroundStyle(.blue)
                                .onTapGesture {
                                    taskData.datePickerIsShown.toggle()
                                }
                        }
                    }
                }
                Toggle("", isOn: Binding (
                    get: {
                        taskData.deadLineActivate
                    },
                    set: { value in
                        taskData.deadLineActivate = value
                        taskData.datePickerIsShown = value
                    }
                    ))
                
            }
            .frame(height: 56)
            .padding(.horizontal)
            
            if taskData.deadLineActivate && taskData.datePickerIsShown {
                Divider()
                if let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()) {
                    DatePicker("Выберите дату", selection: Binding (
                        get: { taskData.deadLine ?? tomorrow },
                        set: { 
                            taskData.deadLine = $0
                            taskData.datePickerIsShown = true
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
    ImportanceListView(taskData: CreateToDoItemViewModel(fileCache: FileCacheImpl(fileName: "file")))
}
