import Foundation

struct MemoryTile: Identifiable, Equatable {
    let id = UUID()
    let correctIndex: Int
    var isRevealed: Bool = false
    var isMatched: Bool = false
}

struct TwistState {
    var tiles: [MemoryTile]
    var firstSelectionIndex: Int?
    var secondSelectionIndex: Int?
}

final class TwistEngine {
    static func make(pairCount: Int) -> TwistState {
        var indices = Array(0..<pairCount) + Array(0..<pairCount)
        indices.shuffle()
        
        let tiles = indices.map { MemoryTile(correctIndex: $0) }
        return TwistState(tiles: tiles)
    }
}
