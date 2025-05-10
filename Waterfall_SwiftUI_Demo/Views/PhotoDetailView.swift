import SwiftUI

struct PhotoDetailView: View {
    let photo: PhotoItem
    @Environment(\.presentationMode) var presentationMode
    @GestureState private var zoom = 1.0
    
    var body: some View {
        GeometryReader { geometry in
            AsyncImage(url: URL(string: photo.imageUrl)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width)
                        .scaleEffect(zoom)
                        .gesture(
                            MagnificationGesture()
                                .updating($zoom) { currentState, gestureState, _ in
                                    gestureState = currentState
                                }
                        )
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    // 在这里添加分享功能
                    guard let url = URL(string: photo.imageUrl) else { return }
                    let activityVC = UIActivityViewController(
                        activityItems: [url],
                        applicationActivities: nil
                    )
                    
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                          let window = windowScene.windows.first,
                          let rootVC = window.rootViewController else {
                        return
                    }
                    
                    rootVC.present(activityVC, animated: true)
                }) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
    }
}
