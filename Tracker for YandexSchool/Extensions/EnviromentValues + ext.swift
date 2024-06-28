
import SwiftUI

private struct ContainerEnvKey: EnvironmentKey {
    static let defaultValue = DiContainer()
}

extension EnvironmentValues {
    var containerDI: DiContainer {
        get { self[ContainerEnvKey.self] }
        set {  }
    }
    
}
