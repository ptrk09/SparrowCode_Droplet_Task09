import SwiftUI

struct ContentView: View {
    @State private var offset: CGSize = .zero

    var body: some View {
        GradientFill()
            .mask { Metaballs() }
            .overlay {
                Image(systemName: "cloud.sun.rain.fill")
                    .resizable()
                    .foregroundColor(.white)
                    .frame(width: 70, height: 70)
                    .offset(offset)
            }
            .gesture(gesture)
            .background(.black)
            .ignoresSafeArea()
    }
}

extension ContentView {
    @ViewBuilder
    private func GradientFill() -> some View {
        Rectangle()
            .fill(
                RadialGradient(
                    gradient: Gradient(colors: [.yellow, .red]),
                    center: .center,
                    startRadius: 80,
                    endRadius: 110
                )
            )
    }
}

extension ContentView {
    @ViewBuilder
    private func Metaballs() -> some View {
        Canvas { context, size in
            context.addFilter(.alphaThreshold(min: 0.5, color: .yellow))
            context.addFilter(.blur(radius: 30))

            context.drawLayer { context in
                drawCircle(id: 1, context: context, size: size)
                drawCircle(id: 2, context: context, size: size)
            }

        } symbols: {
            Circle()
                .frame(width: 130)
                .tag(1)

            Circle()
                .frame(width: 130)
                .offset(offset)
                .tag(2)
        }
    }

    private func drawCircle(id: Int, context: GraphicsContext, size: CGSize) {
        guard let circle = context.resolveSymbol(id: id) else {
            return
        }

        let x = size.width / 2
        let y = size.height / 2

        context.draw(circle, at: CGPoint(x: x, y: y))
    }
}

extension ContentView {
    private var gesture: some Gesture {
        DragGesture()
            .onChanged { value in
                offset = value.translation
            }
            .onEnded { _ in
                withAnimation(
                    .interpolatingSpring(stiffness: 180, damping: 16)
                ) {
                    offset = .zero
                }
            }
    }
}

#Preview {
    ContentView()
}
