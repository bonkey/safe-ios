//
//  Copyright © 2018 Gnosis Ltd. All rights reserved.
//

import XCTest
@testable import EthereumApplication
import EthereumImplementations
import EthereumDomainModel
import Common

class EthereumApplicationTestCase: XCTestCase {

    let ethereumApplicationService = MockEthereumApplicationService()
    let encryptionService = MockEncryptionService()
    let eoaRepository = InMemoryExternallyOwnedAccountRepository()
    let relayService = MockTransactionRelayService(averageDelay: 0, maxDeviation: 0)

    override func setUp() {
        super.setUp()
        ApplicationServiceRegistry.put(service: ethereumApplicationService, for: EthereumApplicationService.self)
        DomainRegistry.put(service: encryptionService, for: EncryptionDomainService.self)
        DomainRegistry.put(service: eoaRepository, for: ExternallyOwnedAccountRepository.self)
        DomainRegistry.put(service: relayService, for: TransactionRelayDomainService.self)
        ApplicationServiceRegistry.put(service: MockLogger(), for: Logger.self)
    }

}
