import Foundation

struct TwistState {
    var steps: [String]
    var currentIndex: Int
}

final class TwistEngine {
    static func make() -> TwistState {
        TwistState(steps: ["Find the tile", "Rotate", "Reveal"], currentIndex: 0)
    }
}
