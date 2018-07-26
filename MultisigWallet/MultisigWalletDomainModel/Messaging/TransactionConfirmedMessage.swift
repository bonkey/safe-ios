//
//  Copyright © 2018 Gnosis Ltd. All rights reserved.
//

import Foundation

public class TransactionConfirmedMessage: Message {

    public let hash: Data
    public let signature: EthSignature

    public init(hash: Data, signature: EthSignature) {
        self.hash = hash
        self.signature = signature
        super.init(type: "confirmTransaction")
    }

    public convenience init?(userInfo: [AnyHashable: Any]) {
        guard let data = try? JSONSerialization.data(withJSONObject: userInfo, options: []),
            let json = try? JSONDecoder().decode(JSON.self, from: data),
            json.type == "confirmTransaction" else { return nil }
        let hash = Data(ethHex: json.hash)
        guard !hash.isEmpty else { return nil }
        guard let v = Int(json.v) else { return nil }
        guard ECDSASignatureBounds.isWithinBounds(r: json.r, s: json.s, v: v) else { return nil }
        self.init(hash: hash, signature: EthSignature(r: json.r, s: json.s, v: v))
    }

    private struct JSON: Decodable {
        var type: String
        var hash: String
        var r: String
        var s: String
        var v: String
    }

}