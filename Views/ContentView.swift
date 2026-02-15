import SwiftUI

struct ContentView: View {
    @State private var viewModel = TwistViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                HStack {
                    Text("Memory Twist")
                        .font(.largeTitle.bold())
                    Spacer()
                    Text("Matches: \(viewModel.matches)")
                        .font(.headline)
                }
                .padding(.horizontal)
                
                let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
                
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(0..<viewModel.state.tiles.count, id: \.self) { index in
                        let tile = viewModel.state.tiles[index]
                        
                        ZStack {
                            if tile.isRevealed || tile.isMatched {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.blue)
                                Text("\(tile.correctIndex)")
                                    .font(.title.bold())
                                    .foregroundStyle(.white)
                            } else {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.gray.opacity(0.3))
                                Image(systemName: "questionmark")
                                    .font(.title.bold())
                                    .foregroundStyle(.gray)
                            }
                        }
                        .aspectRatio(1, contentMode: .fit)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                viewModel.select(index: index)
                            }
                        }
                    }
                }
                .padding()
                
                Text("Moves: \(viewModel.moves)")
                    .font(.subheadline)
                
                Button("Restart Game") {
                    withAnimation {
                        viewModel.reset()
                    }
                }
                .buttonStyle(.bordered)
                
                if viewModel.isSolved {
                    Text("Well Done! 🎉")
                        .font(.headline)
                        .foregroundStyle(.green)
                }
            }
            .navigationTitle("Game")
        }
    }
}
