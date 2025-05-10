import Foundation

struct PhotoItem: Identifiable {
    let id = UUID()
    let imageUrl: String
    let height: CGFloat
    
    static let sampleData = [
        PhotoItem(imageUrl: "https://picsum.photos/200/300", height: 300),
        PhotoItem(imageUrl: "https://picsum.photos/200/250", height: 250),
        PhotoItem(imageUrl: "https://picsum.photos/200/400", height: 400),
        PhotoItem(imageUrl: "https://picsum.photos/200/350", height: 350),
        PhotoItem(imageUrl: "https://picsum.photos/200/280", height: 280),
        PhotoItem(imageUrl: "https://picsum.photos/200/320", height: 320),
        PhotoItem(imageUrl: "https://picsum.photos/200/270", height: 270),
        PhotoItem(imageUrl: "https://picsum.photos/200/380", height: 380),
        PhotoItem(imageUrl: "https://picsum.photos/200/290", height: 290),
        PhotoItem(imageUrl: "https://picsum.photos/200/340", height: 340)
    ]
}
