import SwiftUI

struct BottomSheet<ScrollContent: View>: ViewModifier {
    let initialHeight: CGFloat
    let maxHeight: CGFloat
    let scrollContent: () -> ScrollContent
    @State var height: CGFloat
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
                                .background(colorScheme == .dark ? Color.white : Color.black)
                                .foregroundColor(colorScheme == .dark ? .black : .white)
                        }
                        .scrollDisabled(height <= initialHeight + 1)
                    } else {
                        ScrollView {
                            scrollContent()
                                .padding(.top)
                                .background(colorScheme == .dark ? Color.white : Color.black)
                                .foregroundColor(colorScheme == .dark ? .black : .white)
                        }
                    }
                }
                .frame(height: height)
            }
            .ignoresSafeArea(.all)
        } else {
            content
        }
    }
}

extension View {
    public func bottomSheet<ScrollContent: View>(
        isPresented: Binding<Bool>? = .constant(true),
        interactiveDismiss: Bool? = false,
        height: CGFloat,
        maxHeight: CGFloat? = 250,
        @ViewBuilder content: @escaping () -> ScrollContent
    ) -> some View {
        modifier(BottomSheet(initialHeight: height, maxHeight: maxHeight!, scrollContent: content, height: height, isPresented: isPresented!, interactiveDismiss: interactiveDismiss!))
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

struct BottomSheetShowcase: View {
    @State var showBottomSheet = true
    var body: some View {
        NavigationView {
            Form {
                NavigationLink("BottomSheet with all customizations applied") {
                    showCase1
                }
                NavigationLink("Plain BottomSheet") {
                    showCase2
                }
            }
        }
    }
    var showCase1: some View {
        Text("Tap to Toggle BottomSheet")
            .onTapGesture {
                showBottomSheet.toggle()
            }
            .bottomSheet(isPresented: $showBottomSheet, interactiveDismiss: true, height: 75, maxHeight: 250) {
                Text("Hello")
            }
    }
    var showCase2: some View {
        Text("Plain BottomSheet (only Height Parameter)")
            .bottomSheet(height: 100) {
                Text("hello")
            }
    }
}
