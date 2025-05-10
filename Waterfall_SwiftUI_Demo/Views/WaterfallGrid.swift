import SwiftUI

struct WaterfallGrid<Content: View, T: Identifiable>: View {
    let items: [T]
    let columns: Int
    let content: (T) -> Content
    
    init(items: [T], columns: Int, @ViewBuilder content: @escaping (T) -> Content) {
        self.items = items
        self.columns = columns
        self.content = content
    }
    
    private var columnHeights: [[T]] {
        var result: [[T]] = Array(repeating: [], count: columns)
        var heights = Array(repeating: CGFloat(0), count: columns)
        
        for item in items {
            if let minHeight = heights.min(),
               let columnIndex = heights.firstIndex(of: minHeight) {
                result[columnIndex].append(item)
                if let photoItem = item as? PhotoItem {
                    heights[columnIndex] += photoItem.height
                }
            }
        }
        
        return result
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            ForEach(0..<columns, id: \.self) { column in
                LazyVStack(spacing: 10) {
                    ForEach(columnHeights[column]) { item in
                        content(item)
                    }
                }
            }
        }
        .padding(.horizontal, 10)
    }
}
