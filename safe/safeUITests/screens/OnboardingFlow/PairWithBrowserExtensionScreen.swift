//
//  Copyright © 2018 Gnosis Ltd. All rights reserved.
//

import Foundation
import XCTest
import CommonTestSupport

class PairWithBrowserExtensionScreen {

    var qrCodeInput = XCUIApplication().textFields.element
    var qrCodeButton = XCUIApplication().buttons["QRCodeButton"]
    var finishButton = XCUIApplication().buttons[LocalizedString("new_safe.extension.finish")]

}