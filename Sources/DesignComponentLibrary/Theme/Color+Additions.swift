import SwiftUI

/// Extension of SwiftUI color which encapsulates all the custom colors used within the library
public extension Color {
    static var interactiveEmphasisedBgDefault: Color { Color("interactive-emphasised-bg-default", bundle: Bundle.module) }
    static var neutral1: Color { Color("neutral-1", bundle: Bundle.module) }
    static var neutral5: Color { Color("neutral-5", bundle: Bundle.module) }
    static var semanticPositive: Color { Color("semantic-positive", bundle: Bundle.module) }
    static var semanticNegative: Color { Color("sematic-negative", bundle: Bundle.module) }
    static var textAndIcon1: Color { Color("text-and-icon-1", bundle: Bundle.module) }
    static var textAndIcon2: Color { Color("text-and-icon-2", bundle: Bundle.module) }
    static var textAndIcon3: Color { Color("text-and-icon-3", bundle: Bundle.module) }
}
