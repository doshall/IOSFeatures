import Foundation
import SwiftUI

class ImageLoader: ObservableObject {
    @Published private(set) var images: [PhotoItem] = []
    @Published private(set) var isLoading = false
    
    private var currentPage = 1
    private let perPage = 10
    
    func loadMorePhotos() {
        guard !isLoading else { return }
        isLoading = true
        
        // 模拟网络请求
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            
            let newPhotos = (0..<self.perPage).map { _ in
                PhotoItem(
                    imageUrl: "https://picsum.photos/200/\(Int.random(in: 250...400))",
                    height: CGFloat.random(in: 250...400)
                )
            }
            
            DispatchQueue.main.async {
                self.images.append(contentsOf: newPhotos)
                self.currentPage += 1
                self.isLoading = false
            }
        }
    }
    
    func refreshPhotos() {
        currentPage = 1
        images = []
        loadMorePhotos()
    }
}
