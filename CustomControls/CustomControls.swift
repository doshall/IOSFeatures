import SwiftUI

// MARK: - 1. 自定义加载动画
struct LoadingIndicator: View {
    @State private var isAnimating = false
    
    var body: some View {
        Circle()
            .trim(from: 0, to: 0.8)
            .stroke(LinearGradient(
                gradient: Gradient(colors: [.blue, .purple]),
                startPoint: .leading,
                endPoint: .trailing
            ), style: StrokeStyle(lineWidth: 4, lineCap: .round))
            .frame(width: 40, height: 40)
            .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
            .animation(
                Animation.linear(duration: 1)
                    .repeatForever(autoreverses: false),
                value: isAnimating
            )
            .onAppear {
                isAnimating = true
            }
    }
}

// MARK: - 2. 自定义按钮
struct AnimatedButton: View {
    let title: String
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                    isPressed = false
                }
                action()
            }
        }) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.blue)
                        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                )
                .scaleEffect(isPressed ? 0.95 : 1)
        }
    }
}

// MARK: - 3. 卡片视图
struct CardView<Content: View>: View {
    let content: Content
    @State private var offset = CGSize.zero
    @State private var scale: CGFloat = 1
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.1), radius: 10)
            .offset(offset)
            .scaleEffect(scale)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        offset = gesture.translation
                        let progress = abs(gesture.translation.width / UIScreen.main.bounds.width)
                        scale = 1 - (progress * 0.1)
                    }
                    .onEnded { _ in
                        withAnimation(.spring()) {
                            offset = .zero
                            scale = 1
                        }
                    }
            )
    }
}

// MARK: - 4. 渐变进度条
struct GradientProgressBar: View {
    let progress: Double
    @State private var isAnimating = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [.blue, .purple]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: isAnimating ? geometry.size.width * CGFloat(progress) : 0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: isAnimating)
            }
            .cornerRadius(8)
            .onAppear {
                isAnimating = true
            }
        }
    }
}

// MARK: - 5. 展示视图
struct CustomControlsDemo: View {
    @State private var progress = 0.0
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // 加载指示器
                LoadingIndicator()
                
                // 自定义按钮
                AnimatedButton(title: "点击我") {
                    withAnimation {
                        progress = Double.random(in: 0...1)
                    }
                }
                
                // 进度条
                GradientProgressBar(progress: progress)
                    .frame(height: 8)
                    .padding(.horizontal)
                
                // 卡片视图
                CardView {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("交互式卡片")
                            .font(.title2)
                            .bold()
                        
                        Text("左右拖动这个卡片来查看动画效果。松开后，卡片会弹回原位。")
                            .font(.body)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical, 30)
        }
        .navigationTitle("自定义控件")
    }
}
