import SwiftUI

struct BottomSheet<ScrollContent: View>: ViewModifier {
    let initialHeight: CGFloat
    let maxHeight: CGFloat
    let scrollContent: () -> ScrollContent
    @Binding var height: CGFloat
    @Environment(\.colorScheme) private var colorScheme
    @Binding var isPresented: Bool
    let interactiveDismiss: Bool
    func body(content: Content) -> some View {
        if isPresented {
            VStack(spacing: 0) {
                ZStack {
                    Color.primary
                    VStack {
                        ZStack {
                            content
                                .padding(.top, 60)
                                .padding(.bottom, 10)
                            VStack {
                                Spacer()
                                RoundedRectangle(cornerRadius: 100)
                                    .fill(.gray.opacity(0.5))
                                    .frame(width: 50, height: 7.5)
                                    .padding(10)
                                    .gesture(
                                        DragGesture()
                                            .onChanged { gesture in
                                                if height >= maxHeight {
                                                    if gesture.translation.height >= 0 {
                                                        height += -gesture.translation.height
                                                    } else {
                                                        height += 0.5
                                                    }
                                                } else {
                                                    height += -gesture.translation.height
                                                }
                                            }
                                            .onEnded { _ in
                                                if height >= maxHeight {
                                                    withAnimation(.bouncy(duration: 0.5)) {
                                                        height = maxHeight
                                                    }
                                                } else if height <= 10 {
                                                    if interactiveDismiss {
                                                        withAnimation(.bouncy(duration: 0.5)) {
                                                            height = 0.0000000000000001 // Finite but very small number to avoid "Invalid frame dimension (negative or non-finite)" lol
                                                        }
                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                            isPresented = false
                                                            height = initialHeight
                                                        }
                                                    }
                                                } else if height <= initialHeight {
                                                    withAnimation(.bouncy(duration: 0.5)) {
                                                        height = initialHeight
                                                    }
                                                }
                                                if !interactiveDismiss {
                                                    if height <= 1 {
                                                        withAnimation(.bouncy(duration: 0.5)) {
                                                            height = initialHeight
                                                        }
                                                    }
                                                }
                                            }
                                    )
                            }
                        }

                    }
                    .frame(maxWidth: .infinity)
                    .cornerRadius(25)
                    .background(
                        BottomRoundedRectangle(cornerRadius: 25)
                            .fill(.background)
                    )
                }
                ZStack {
                    Rectangle()
                        .fill(Color(UIColor.label))
                    if #available(iOS 16.0, *) {
                        ScrollView {
                            scrollContent()
                                .padding(.top)
                        }
                        .scrollDisabled(height <= initialHeight + 1)
                        .preferredColorScheme(colorScheme == .dark ? .light : .dark)
                    } else {
                        ScrollView {
                            scrollContent()
                                .padding(.top)
                        }
                        .preferredColorScheme(colorScheme == .dark ? .light : .dark)
                    }
                }
                .frame(height: height)
            }
            .ignoresSafeArea(.all)
            .onAppear {
                withAnimation(.bouncy) {
                    height = initialHeight
                }
            }
        } else {
            content
        }
    }
}

extension View {
    public func bottomSheet<ScrollContent: View>(
        isPresented: Binding<Bool>? = .constant(true),
        interactiveDismiss: Bool? = false,
        height: Binding<CGFloat>,
        initialHeight: CGFloat,
        maxHeight: CGFloat? = 250,
        @ViewBuilder content: @escaping () -> ScrollContent
    ) -> some View {
        modifier(BottomSheet(initialHeight: initialHeight, maxHeight: maxHeight!, scrollContent: content, height: height, isPresented: isPresented!, interactiveDismiss: interactiveDismiss!))
    }
}

import SwiftUI

struct BottomRoundedRectangle: Shape {
    var cornerRadius: CGFloat = 25.0
    
    func path(in rect: CGRect) -> Path {
        var path = Path()

        // Start at top-left
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        // Top edge
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        // Right edge
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - cornerRadius))
        // Bottom-right corner
        path.addArc(center: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY - cornerRadius),
                    radius: cornerRadius,
                    startAngle: .degrees(0),
                    endAngle: .degrees(90),
                    clockwise: false)
        // Bottom-left corner
        path.addArc(center: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY - cornerRadius),
                    radius: cornerRadius,
                    startAngle: .degrees(90),
                    endAngle: .degrees(180),
                    clockwise: false)
        // Left edge
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))

        return path
    }
}
