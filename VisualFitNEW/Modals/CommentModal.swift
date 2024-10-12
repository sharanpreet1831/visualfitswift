import SwiftUI

struct CommentModalView: View {
    var postId: String
    @Binding var isPresented: Bool
    @StateObject private var viewModel = CommentViewModel()
    @State private var newCommentText: String = ""

    var body: some View {
        NavigationView {
            VStack {
                // Comments List
                List {
                    ForEach(viewModel.comments) { comment in
                        CommentCell(comment: comment)
                            .listRowInsets(EdgeInsets()) // Remove default list row insets
                    }
                }
                .onAppear {
                    viewModel.fetchComments(for: postId)
                }
                .listStyle(PlainListStyle()) // Clean list style
                
                // Input field for new comments
                HStack {
                    TextField("Add a comment...", text: $newCommentText)
                        .padding(12)
                        .background(Color(.systemGray6))
                        .cornerRadius(20) // More rounded corners
                        .padding(.horizontal)

                    Button(action: {
                        if !newCommentText.isEmpty {
                            viewModel.addComment(to: postId, comment: newCommentText)
                            newCommentText = ""
                        }
                    }) {
                        Text("Post")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Color.blue)
                            .cornerRadius(20) // More rounded corners
                    }
                    .padding(.trailing)
                }
                .padding()
                .background(Color.white) // Set a clean white background for the input area
                .cornerRadius(12) // Rounded corners for input area
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2) // Subtle shadow
            }
            .navigationBarTitle("Comments", displayMode: .inline)
            .navigationBarItems(leading: Button("Close") {
                isPresented = false
            })
            .background(Color(.systemGray5)) // Light gray background for the entire modal
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct CommentCell: View {
    let comment: FetchComment

    var body: some View {
        HStack(alignment: .top) {
            // Display user avatar
            AsyncImage(url: URL(string: comment.userId.avatar)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .shadow(radius: 1) // Light shadow for the avatar
            } placeholder: {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 40, height: 40)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(comment.userId.username)
                    .font(.subheadline) // Subheadline for username
                    .fontWeight(.semibold) // Semibold for emphasis
                    .foregroundColor(.black) // Dark color for better readability

                Text(comment.text)
                    .font(.body) // Standard body font for comment text
                    .foregroundColor(.gray) // Lighter gray for comment text
                    .lineLimit(3) // Allow up to 3 lines for comment text
                    .padding(.top, 2) // Space between username and comment text
            }
            .padding(8) // Padding around the text
            .background(Color.white) // White background for comment card
            .cornerRadius(12) // Rounded corners for comment card
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2) // Subtle shadow effect
        }
        .padding(.vertical, 6) // Vertical padding for each comment cell
        .background(Color.clear) // Transparent background for full-width
    }
}
