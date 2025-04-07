import SwiftUI
import BottomDrawer

struct BottomSheetShowcase: View {
    @State var showBottomSheet = true
    @State var height: CGFloat = 75
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
            .bottomDrawer(isPresented: $showBottomSheet, interactiveDismiss: true, dragHandleVisibility: .visible, height: $height, initialHeight: 75, maxHeight: 250) {
                Text("Hello")
            }
    }
    var showCase2: some View {
        Text("Plain BottomSheet (only Height Parameter)")
            .bottomDrawer(height: $height, initialHeight: 100) {
                Text("hello")
            }
    }
}

#Preview {
    BottomSheetShowcase()
}
