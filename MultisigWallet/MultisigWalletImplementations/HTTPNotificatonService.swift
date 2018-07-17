//
//  Copyright © 2018 Gnosis Ltd. All rights reserved.
//

import Foundation
import MultisigWalletDomainModel
import Common

final public class HTTPNotificationService: NotificationDomainService {

    private let httpClient = JSONHTTPClient(url: Keys.notificationServiceURL,
                                            logger: MockLogger())

    public init() {}

    public func pair(pairingRequest: PairingRequest) throws {
        let response = try httpClient.execute(request: pairingRequest)
        let browserExtensionAddress = pairingRequest.temporaryAuthorization.extensionAddress!
        let deviceOwnerAddress = pairingRequest.deviceOwnerAddress!
        guard response.devicePair.contains(browserExtensionAddress) &&
            response.devicePair.contains(deviceOwnerAddress) else {
                throw NotificationDomainServiceError.validationFailed
        }
    }

    public func auth(request: AuthRequest) throws {
        let response = try httpClient.execute(request: request)
        guard response.pushToken == request.pushToken &&
            response.owner == request.deviceOwnerAddress else {
                throw NotificationDomainServiceError.validationFailed
        }
    }

    public func send(notificationRequest: SendNotificationRequest) throws {
        try httpClient.execute(request: notificationRequest)
    }

    public func safeCreatedMessage(at address: String) -> String {
        struct Message: Encodable {
            var type = "safeCreation"
            var safe: String
            init(_ safe: String) { self.safe = safe }
        }
        return String(data: try! JSONEncoder().encode(Message(address)), encoding: .utf8)!
    }

}

extension PairingRequest: JSONRequest {

    public var httpMethod: String { return "POST" }
    public var urlPath: String { return "/api/v1/pairing/" }
    public typealias ResponseType = DevicePair

    public struct DevicePair: Decodable {
        let devicePair: [String]
    }

}

extension SendNotificationRequest: JSONRequest {

    public var httpMethod: String { return "POST" }
    public var urlPath: String { return "/api/v1/notifications/" }
    public typealias ResponseType = EmptyResponse

}

extension AuthRequest: JSONRequest {

    public var httpMethod: String { return "POST" }
    public var urlPath: String { return "/api/v1/auth/" }
    public typealias ResponseType = AuthResponse

    public struct AuthResponse: Decodable {
        let pushToken: String
        let owner: String
    }

}