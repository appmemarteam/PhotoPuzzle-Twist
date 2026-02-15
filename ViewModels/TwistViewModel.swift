import Foundation
import Observation

@Observable
final class TwistViewModel {
    var state: TwistState = TwistEngine.make()
}
