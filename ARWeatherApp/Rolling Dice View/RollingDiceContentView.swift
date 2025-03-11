
// From this tutorial - https://www.ralfebert.com/ios/realitykit-dice-tutorial/

import SwiftUI

struct RollingDiceContentView: View {
    var body: some View {
        RollingDiceRealityKitView()
            .ignoresSafeArea()
    }
}

#Preview {
    RollingDiceContentView()
}
