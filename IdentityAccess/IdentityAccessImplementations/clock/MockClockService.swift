//
//  Copyright © 2018 Gnosis Ltd. All rights reserved.
//

import Foundation
import IdentityAccessApplication

/// Mock Clock implementation for testing purposes.
open class MockClockService: Clock {

    open var currentTime = Date()
    open var countdownTickBlock: ((TimeInterval) -> Void)?

    public init() {}

    open func countdown(from period: TimeInterval, tick: @escaping (TimeInterval) -> Void) {
        countdownTickBlock = tick
    }

}
