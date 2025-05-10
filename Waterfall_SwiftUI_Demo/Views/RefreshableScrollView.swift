import SwiftUI

struct RefreshableScrollView<Content: View>: View {
    let onRefresh: (@escaping () -> Void) -> Void
    let content: Content
    
    init(
        onRefresh: @escaping (@escaping () -> Void) -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.onRefresh = onRefresh
        self.content = content()
    }
    
    var body: some View {
        if #available(iOS 15.0, *) {
            List {
                content
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets())
            }
            .listStyle(.plain)
            .refreshable {
                await withCheckedContinuation { continuation in
                    onRefresh {
                        continuation.resume()
                    }
                }
            }
        } else {
            ScrollView {
                content
            }
        }
    }
}
