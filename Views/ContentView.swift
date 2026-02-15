import SwiftUI
import Photos

struct ContentView: View {
    @State private var viewModel = TwistViewModel()
    @State private var showingSettings = false
    @State private var showingWinSheet = false
    @State private var images: [Int: UIImage] = [:]

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()
                
                VStack(spacing: 24) {
                    // Header
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Moves")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text("\(viewModel.moves)")
                                .font(.title2.bold())
                                .monospacedDigit()
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text("Matches")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text("\(viewModel.matches)/\(viewModel.state.tiles.count / 2)")
                                .font(.title2.bold())
                        }
                    }
                    .padding(.horizontal)

                    // Grid
                    let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]
                    
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(0..<viewModel.state.tiles.count, id: \.self) { index in
                            let tile = viewModel.state.tiles[index]
                            
                            TwistTileView(tile: tile, image: images[tile.correctIndex])
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                        viewModel.select(index: index)
                                    }
                                }
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .shadow(color: .black.opacity(0.05), radius: 10)
                    .padding(.horizontal)

                    Spacer()

                    Button {
                        withAnimation {
                            viewModel.reset()
                        }
                    } label: {
                        Label("Restart Game", systemImage: "arrow.counterclockwise")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            }
            .navigationTitle("Memory Twist")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
            .sheet(isPresented: $showingWinSheet) {
                TwistWinView(moves: viewModel.moves) {
                    viewModel.reset()
                }
            }
            .onChange(of: viewModel.isSolved) { _, newValue in
                if newValue {
                    showingWinSheet = true
                }
            }
        }
    }
}

struct TwistTileView: View {
    let tile: MemoryTile
    let image: UIImage?
    
    var body: some View {
        ZStack {
            // Back (Question mark)
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.accentColor.gradient)
                .overlay {
                    Image(systemName: "questionmark")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.white.opacity(0.8))
                }
                .opacity(tile.isRevealed || tile.isMatched ? 0 : 1)
                .rotation3DEffect(.degrees(tile.isRevealed || tile.isMatched ? 90 : 0), axis: (x: 0, y: 1, z: 0))

            // Front (Value/Image)
            RoundedRectangle(cornerRadius: 12)
                .fill(tile.isMatched ? Color.green.gradient : Color(.tertiarySystemGroupedBackground).gradient)
                .overlay {
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    } else {
                        Text("\(tile.correctIndex + 1)")
                            .font(.largeTitle.bold())
                    }
                }
                .opacity(tile.isRevealed || tile.isMatched ? 1 : 0)
                .rotation3DEffect(.degrees(tile.isRevealed || tile.isMatched ? 0 : -90), axis: (x: 0, y: 1, z: 0))
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

struct TwistWinView: View {
    let moves: Int
    let onPlayAgain: () -> Void
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 24) {
            Text("🎉 Fantastic!")
                .font(.system(size: 48, weight: .black))
            
            VStack(spacing: 8) {
                Text("Cleared in \(moves) moves")
                    .font(.title2.bold())
            }
            
            Button {
                onPlayAgain()
                dismiss()
            } label: {
                Text("Play Again")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(.top)
        }
        .padding(40)
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}
