import SwiftUI

struct DiscoverView: View {
    @State private var selectedTab: Int = 0
    @State private var showNewPostView: Bool = false
    @StateObject private var viewModel = PostViewModel()
    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor.systemYellow
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.systemYellow], for: .normal)
    }

    var body: some View {
        NavigationView {
            VStack {
                headerSection
                segmentedControl
                contentSection
            }
            .tabItem {
                Image(systemName: "globe")
                Text("Discover")
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .onAppear {
                viewModel.fetchPosts()
            }
        }
    }
    
    private var headerSection: some View {
        HStack {
            Text("Discover")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.white)
            Spacer()
            Button(action: {
                showNewPostView = true
            }) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.yellow)
            }
            .background(
                NavigationLink(destination: NewPostView(), isActive: $showNewPostView) {
                    EmptyView()
                }
            )
        }
        .padding(.horizontal)
        .padding(.top, 20)
    }

    private var segmentedControl: some View {
        Picker(selection: $selectedTab, label: Text("Discover Options")) {
                    Text("Journeys").tag(0)
                    Text("Transformations").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
    }

    private var contentSection: some View {
        
        ScrollView {
            if selectedTab == 0 {
                JourneyListView(posts: viewModel.posts, likePost: likePost, commentOnPost: commentOnPost)
            } else {
                TransformationListView(posts: viewModel.posts, likePost: likePost, commentOnPost: commentOnPost)
            }
        }
        .padding(.bottom, 22)
    }

    private func likePost(postId: String) {
        guard let url = URL(string: "http://localhost:4000/api/v1/post/like") else {
            print("Invalid URL")
            return
        }
        
        let accessToken = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        let jsonData: [String: Any] = ["postId": postId]

        // Serialize JSON data
        guard let data = try? JSONSerialization.data(withJSONObject: jsonData, options: []) else {
            print("Failed in Liking Post")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.httpBody = data

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error liking post: \(error)")
                return
            }

            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("Response: \(responseString)")
            }

            DispatchQueue.main.async {
                viewModel.fetchPosts()
            }
        }.resume()
    }

    private func commentOnPost(postId: String, comment: String) {
        guard let url = URL(string: "http://localhost:4000/api/v1/post/comment") else {
            print("Invalid URL")
            return
        }

        let commentData: [String: Any] = ["postId": postId, "text": comment]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: commentData, options: []) else {
            print("Failed to encode comment data")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(UserDefaults.standard.string(forKey: "accessToken") ?? "")", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error commenting on post: \(error)")
                return
            }

            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("Comment Response: \(responseString)")
            }

            DispatchQueue.main.async {
                viewModel.fetchPosts()
            }
        }.resume()
    }
}

struct JourneyListView: View {
    var posts: [PostResponseModel]
    var likePost: (String) -> Void
    var commentOnPost: (String, String) -> Void

    var body: some View {
        VStack {
            if posts.isEmpty {
                VStack {
                    Spacer()
                        Text("No posts available")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }else{
                ForEach(posts) { post in
                    JourneyCardView(post: post, likePost: likePost, commentOnPost: commentOnPost)
                }
            }
        }
    }
}

struct TransformationListView: View {
    var posts: [PostResponseModel]
    var likePost: (String) -> Void
    var commentOnPost: (String, String) -> Void

    var body: some View {
        if posts.isEmpty {
            VStack {
                Spacer()
                    Text("No posts available")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }else{
            VStack {
                ForEach(posts) { post in
                    JourneyCardView(post: post, likePost: likePost, commentOnPost: commentOnPost)
                }
            }
        }
    }
}

struct JourneyCardView: View {
    var post: PostResponseModel
    var likePost: (String) -> Void
    var commentOnPost: (String, String) -> Void

    @StateObject private var commentViewModel = CommentViewModel()
    @State private var commentText: String = ""
    @State private var isCommentModalPresented: Bool = false // State variable for modal presentation

    var body: some View {
        VStack(alignment: .leading) {
            header
            imageView
            actionButtons
        }
        .background(Color.gray.opacity(0.3))
        .cornerRadius(10)
        .padding(.horizontal)
        .onAppear {
            commentViewModel.fetchComments(for: post.id)
        }
        .sheet(isPresented: $isCommentModalPresented) {
            CommentModalView(postId: post.id, isPresented: $isCommentModalPresented)
        }
    }
    
    private var header: some View {
        HStack {
            profileImage
            postDetails
            Spacer()
            followButton
        }
        .padding()
    }

    private var profileImage: some View {
        Image(systemName: "person.crop.circle.fill")
            .resizable()
            .frame(width: 40, height: 40)
            .padding(.trailing, 10)
    }

    private var postDetails: some View {
        VStack(alignment: .leading) {
            Text(post.userId?.username ?? "Unknown User")
                .font(.headline)
                .foregroundColor(.white)
            Text(post.title)
                .font(.subheadline)
                .foregroundColor(.white)
        }
    }

    private var followButton: some View {
        Button(action: {
            
        }) {
            HStack {
                Text("Follow")
                    .foregroundColor(.black)
            }
            .padding(10)
            .background(Color.gray.opacity(0.9))
            .cornerRadius(10)
        }
        .buttonStyle(BorderlessButtonStyle())
    }

    private var imageView: some View {
        AsyncImage(url: URL(string: post.image)) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: 250)
                    .background(Color.gray.opacity(0.2))
            case .success(let loadedImage):
                loadedImage
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: 250)
                    .clipped()
            case .failure:
                Image(systemName: "photo")
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: 250)
                    .clipped()
            @unknown default:
                fatalError()
            }
        }
        .padding(.horizontal)
    }

    private var actionButtons: some View {
        HStack {
            likeButton
            Button(action: {
                isCommentModalPresented = true
            }) {
                Image(systemName: "message")
                    .foregroundColor(.yellow)
                    .padding(11)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(Color.gray.opacity(0.9))
                    .cornerRadius(20)
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 10)
    }

    private var likeButton: some View {
        Button(action: {
            likePost(post.id)
        }) {
            HStack {
                Image(systemName: "heart")
                Text("\(post.likes.count)")
            }
            .padding(11)
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(Color.gray.opacity(0.9))
            .cornerRadius(20)
        }
        .buttonStyle(BorderlessButtonStyle())
    }

    
    private var commentList: some View {
        ForEach(commentViewModel.comments) { comment in
            Text(comment.text)
                .foregroundColor(.white)
                .padding(5)
        }
    }
}



// Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
    }
}
