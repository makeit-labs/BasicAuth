import Foundation
import Kitura

public struct UserCredentials {
    public var name: String
    public var password: String
}

public func basicAuth(_ request: RouterRequestProtocol) -> UserCredentials? {
    var authorization : String
    if let user = request.urlURL.user, let password = request.urlURL.password {
        authorization = "\(user):\(password)"
    }
    else {
        let options = Data.Base64DecodingOptions(rawValue: 0)

        guard let authorizationHeader = request.headers["Authorization"] else {
            return nil
        }
        let authorizationHeaderComponents = authorizationHeader.components(separatedBy: " ")
        guard authorizationHeaderComponents.count == 2,
            authorizationHeaderComponents[0] == "Basic",
            let decodedData = Data(base64Encoded: authorizationHeaderComponents[1], options: options),
            let userAuthorization = String(data: decodedData, encoding: .utf8) else {
                return nil
        }

        authorization = userAuthorization as String
    }

    let credentials = authorization.components(separatedBy: ":")
    guard credentials.count >= 2 else {
        return nil
    }

    return UserCredentials(name: credentials[0], password: credentials[1])
}
