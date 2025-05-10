import SwiftUI

struct ContentView: View {
    @StateObject private var imageLoader = ImageLoader()
    @State private var columns = 2
    @State private var selectedPhoto: PhotoItem?
    
    var body: some View {
        NavigationView {
            ScrollView {
                RefreshableScrollView(onRefresh: { done in
                    imageLoader.refreshPhotos()
                    done()
                }) {
                    WaterfallGrid(items: imageLoader.images, columns: columns) { item in
                        NavigationLink(destination: PhotoDetailView(photo: item)) {
                            PhotoCardView(item: item)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    if !imageLoader.images.isEmpty {
                        ProgressView()
                            .padding()
                            .onAppear {
                                imageLoader.loadMorePhotos()
                            }
                    }
            }
            .navigationTitle("瀑布流相册")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Picker("列数", selection: $columns) {
                        Text("2列").tag(2)
                        Text("3列").tag(3)
                    }
                }
            }
        }
    }
}
