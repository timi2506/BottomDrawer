import SwiftUI
import BottomSheet

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
