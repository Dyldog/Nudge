import Foundation

extension Int {
    
    func times (iterator: (Int) -> Void) {
        for i in 0..<self {
            iterator(i)
        }
    }
}
