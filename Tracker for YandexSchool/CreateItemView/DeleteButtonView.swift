import SwiftUI

struct DeleteButtonView: View {
    private var action: (() -> Void)?
    
    init (action: @escaping () -> Void){
        self.action = action
    }
    
    var body: some View {
        
        Button(action: {
            action?()
                }) {
                    Text("Удалить")
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.white)
                        .cornerRadius(10)
                }
    }
}

//#Preview {
//    DeleteButtonView()
//}
