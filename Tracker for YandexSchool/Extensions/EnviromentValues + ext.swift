import SwiftUI

private struct ContainerEnvKey: EnvironmentKey {
    static let defaultValue = DiContainer()
}

extension EnvironmentValues {
    var containerDI: DiContainer {
        self[ContainerEnvKey.self]
    }
}

