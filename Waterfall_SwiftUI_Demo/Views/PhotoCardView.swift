import SwiftUI

struct PhotoCardView: View {
    let item: PhotoItem
    
    var body: some View {
        AsyncImage(url: URL(string: item.imageUrl)) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(width: 200, height: item.height)
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: item.height)
                    .clipped()
                    .cornerRadius(10)
            case .failure:
                Image(systemName: "photo")
                    .frame(width: 200, height: item.height)
            @unknown default:
                EmptyView()
            }
        }
        .shadow(radius: 3)
    }
}
