import Foundation
import Observation
import Photos

@Observable
final class TwistViewModel {
    var state: TwistState = TwistEngine.make(pairCount: 6)
    var moves: Int = 0
    var matches: Int = 0
    var isSolved: Bool = false
    var selectedAssets: [PHAsset] = []
    
    func select(index: Int) {
        guard !state.tiles[index].isRevealed, !state.tiles[index].isMatched else { return }
        
        if SettingsStore.shared.hapticsEnabled {
            HapticManager.shared.impact(style: .medium)
        }

        if let first = state.firstSelectionIndex, let _ = state.secondSelectionIndex {
            hideUnmatched()
            state.firstSelectionIndex = index
            state.tiles[index].isRevealed = true
        } else if let first = state.firstSelectionIndex {
            state.secondSelectionIndex = index
            state.tiles[index].isRevealed = true
            moves += 1
            checkMatch(first: first, second: index)
        } else {
            state.firstSelectionIndex = index
            state.tiles[index].isRevealed = true
        }
    }
    
    private func checkMatch(first: Int, second: Int) {
        if state.tiles[first].correctIndex == state.tiles[second].correctIndex {
            state.tiles[first].isMatched = true
            state.tiles[second].isMatched = true
            matches += 1
            state.firstSelectionIndex = nil
            state.secondSelectionIndex = nil
            
            if SettingsStore.shared.hapticsEnabled {
                HapticManager.shared.notification(type: .success)
            }

            if matches == state.tiles.count / 2 {
                isSolved = true
            }
        } else {
            if SettingsStore.shared.hapticsEnabled {
                HapticManager.shared.notification(type: .error)
            }
        }
    }
    
    private func hideUnmatched() {
        for i in 0..<state.tiles.count {
            if !state.tiles[i].isMatched {
                state.tiles[i].isRevealed = false
            }
        }
        state.firstSelectionIndex = nil
        state.secondSelectionIndex = nil
    }
    
    func reset() {
        state = TwistEngine.make(pairCount: 6)
        moves = 0
        matches = 0
        isSolved = false
    }
}
