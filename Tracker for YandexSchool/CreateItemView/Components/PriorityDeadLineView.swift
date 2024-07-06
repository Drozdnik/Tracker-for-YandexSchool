import SwiftUI

struct PriorityDeadLineView: View {
    @State private var importance: String = "нет"
    @State private var isUrgent: Bool = false
    let importanceOptions = ["низкая", "средняя", "Okay"]

    var body: some View {
        List {
            Section {
                HStack {
                    Text("Важность")
                    Spacer()
                    Picker("Важность", selection: $importance) {
                        ForEach(importanceOptions, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: 200)
                }

                Toggle("Сделать до", isOn: $isUrgent)
            }
        }
        .listStyle(GroupedListStyle())
    }
}

struct PriorityDeadLineView_Previews: PreviewProvider {
    static var previews: some View {
        PriorityDeadLineView()
    }
}
