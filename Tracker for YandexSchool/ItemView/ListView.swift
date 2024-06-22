import SwiftUI

struct ImportanceListView: View {
    @State private var dueDate = Date()
    @State private var deadLineActivate: Bool = false

    var body: some View {
        List {
            HStack{
                Text ("Важность")
                Spacer()
                SwitcherView()
                    .frame(width: 150)
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                //Скорее всего лучше без скейла
                    .scaledToFit()
                    .scaleEffect(CGSize(width: 1.0, height: 1.5))

            }
            .frame(height: 56)
            HStack{
                Text("Сделать до")
                Toggle("", isOn: $deadLineActivate)
            }
            .frame(height: 56)
            
        }
        .listStyle(InsetGroupedListStyle())
    }
}

struct ImportanceListView_Previews: PreviewProvider {
    static var previews: some View {
        ImportanceListView()
    }
}
