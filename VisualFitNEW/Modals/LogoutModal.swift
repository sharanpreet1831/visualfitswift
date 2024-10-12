import SwiftUI

struct LogoutModal: View {
    @Binding var isPresented: Bool
    var onLogout: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Are you sure you want to logout?")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding()

            HStack {
                Button("Cancel") {
                    isPresented = false
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)

                Button("Logout") {
                    onLogout()
                }
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding()
        .frame(maxWidth: 300)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 20)
        .padding()
    }
}
