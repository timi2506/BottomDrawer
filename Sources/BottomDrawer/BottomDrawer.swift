import SwiftUI

struct BottomDrawer<ScrollContent: View>: ViewModifier {
    let initialHeight: CGFloat
    let maxHeight:     CGFloat
    
    let scrollContent: () -> ScrollContent
    
    @Binding var height: CGFloat
    
    @Environment(\.colorScheme) private var colorScheme
    
    @Binding var isPresented: Bool
    
    let interactiveDismiss: Bool
    
    // MARK: Drag gesture configuration
    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { gesture in
                height = (height - gesture.translation.height) > maxHeight ?
                    maxHeight + ((height - gesture.translation.height) - maxHeight) * 0.15 :
                    max(0, height - gesture.translation.height)
            }
            .onEnded { _ in
                if height >= maxHeight {
                    withAnimation(.bouncy(duration: 0.5)) {
                        height = maxHeight
                    }
                } else if height <= 10 {
                    if interactiveDismiss {
                        withAnimation(.bouncy(duration: 0.5)) {
                            height = 0
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            isPresented = false
                            height = 0
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
    }
    
    var dragHandle: some View {
        let t = height / maxHeight
        let width = 148 + t * (50 - 148) // manual linear interpolation
        
        let fillOpacity = ((1 - t) + 0.5) * 0.5
        let fillColor = Color.primary.opacity(fillOpacity)
        
        let effectiveColorScheme: ColorScheme = colorScheme == .dark ? .light : .dark

        return RoundedRectangle(cornerRadius: 100)
            .fill(fillColor)
            .colorScheme(effectiveColorScheme)
        
            .frame(width: width, height: 6)
            .padding(8)
        
            .contentShape(.rect)
            .gesture(dragGesture)
        
            .opacity(height != 0 ? 1 : 0)
    //        .animation(.smooth, value: isPresented)
    }

    
    @State private var contentCornerRadius: CGFloat = 0
    
    // This function sets the height according to isPresented, animated if desired.
    // The non-animating version is used inside .onAppear, as we wouldn't want to animate collapsing
    // the drawer when starting out as isPresented == false.
    private func refreshPresentation(animate: Bool) {
        if isPresented { height = 0 }
        
        // Don't use .bouncy for collapsing, as it will bounce down the rounded corner mask at the top.
        withAnimation(animate ? (isPresented ? .bouncy : .smooth(duration: 0.3)) : .none) {
            height = isPresented ? initialHeight : 0
            contentCornerRadius = isPresented ? 25 : 0 // TODO: device radius would be cool here!
        }
    }
    
    func body(content: Content) -> some View {
        ZStack {
            
            // MARK: User content
            VStack(spacing: 0) {
                content
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                Spacer()
                    .frame(height: height)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.background)
            .mask(
                // MARK: Content rounded corners (bottom only)
                // FIXME: Corner radius can't animate here. I assume that's because it is a shape and gets calculated once per draw.
                BottomRoundedRectangle(cornerRadius: contentCornerRadius)
                .ignoresSafeArea()  // Mask fully covers content, top-to-bottom
                .offset(y: -height) // Mask moved such that the bottom roundness aligns with top of the drawer
            )
            .background(Color.primary)
            
            // MARK: Drawer
            VStack(spacing: 0) {
                Spacer()
                
                // MARK: Drag handle
                dragHandle
                
                // MARK: Drawer content
                ZStack {
                    Rectangle()
                        .fill(Color(UIColor.label))
                    VStack {
                        scrollContent()
                            .colorScheme(colorScheme == .dark ? .light : .dark)
                    }
                }
                .frame(height: height)
            }
            .ignoresSafeArea(.all)
            
            // Because we want to animate state changes, we can't have the state views being conditional.
            // To prevent interaction while the drawer is going away, or interaction while off-screen with VoiceOver,
            // we can disable all controls inside the drawer:
            .disabled(!isPresented)
            
            .onChange(of: isPresented) { value in
                refreshPresentation(animate: true)
            }
            .onAppear() {
                // animate: false - don't animate the drawer when appearing for the first time
                refreshPresentation(animate: false)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

extension View {
    public func bottomDrawer<ScrollContent: View>(
        isPresented: Binding<Bool>? = .constant(true),
        interactiveDismiss: Bool? = false,
        height: Binding<CGFloat>,
        initialHeight: CGFloat,
        maxHeight: CGFloat? = 250,
        @ViewBuilder content: @escaping () -> ScrollContent
    ) -> some View {
        modifier(BottomDrawer(initialHeight: initialHeight, maxHeight: maxHeight!, scrollContent: content, height: height, isPresented: isPresented!, interactiveDismiss: interactiveDismiss!))
    }
}

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
