import SwiftUI

struct PlusView: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) { 
            ZStack {
                RoundedRectangle(cornerRadius: 25.0)
                    .frame(width: 22, height: 3.67)
                    .foregroundStyle(.white)
                RoundedRectangle(cornerRadius: 25.0)
                    .frame(width: 3.67, height: 22)
                    .foregroundStyle(.white)
            }
            .frame(width: 44, height: 44)
            .background(Color.blue)
            .clipShape(Circle())
            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 5)
        }
    }
}


#Preview {
    PlusView(action: {})
}
