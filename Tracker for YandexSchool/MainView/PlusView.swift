import SwiftUI

struct PlusView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                .frame(width: 22, height: 3.67)
                .foregroundColor(.white)
            RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                .frame(width: 3.67, height: 22)
                .foregroundColor(.white)
        }
    }
}


#Preview {
    PlusView()
}
