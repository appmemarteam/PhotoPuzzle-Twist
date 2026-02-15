import SwiftUI

struct ContentView: View {
    @State private var viewModel = TwistViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Photo Puzzle Twist")
                    .font(.largeTitle.bold())

                Text("Twist mechanic coming next")
                    .foregroundStyle(.secondary)

                Button("Next") {
                    viewModel.state.currentIndex = (viewModel.state.currentIndex + 1) % viewModel.state.steps.count
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .navigationTitle("Twist")
        }
    }
}

#Preview {
    ContentView()
}
