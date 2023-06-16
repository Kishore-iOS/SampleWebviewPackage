import SwiftUI

extension View {
    public func centreHorizontally() -> some View {
        return HStack {
            Spacer()
            self
            Spacer()
        }
    }
}

