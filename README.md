# BasicAuth

Generic basic auth Authorization header field parser for Kitura (Swift 3).

Inspired by the [Node.js](https://nodejs.org/en/) library [basic-auth](https://github.com/jshttp/basic-auth)

## Installation

This is a Swift Package manager module. Install it by including it in your
`Package.swift` file.

```swift
    dependencies: [
        .Package(url: "https://github.com/makeit-labs/BasicAuth.git", majorVersion: 1, minor: 0)
    ]
```

## Usage

```swift
import BasicAuth

router.get("/") { request, response, next in
    let user = basicAuth(request)!
    response.send("Hello, \(user.name)! Your password is \(user.password)!!")
    next()
}
```

### `UserCredentials`

Just a plain old Swift struct that holds the credentials.

```swift
public struct UserCredentials {
    var name: String
    var password: String
}
```

### `basicAuth(_ request: RouterRequestProtocol) -> UserCredentials?`

Get the basic auth credentials from the given request. If there is a basic auth
component in the URL, the username and password are returned. Else, the
`Authorization` header is parsed and if the header is invalid, `nil` is
returned, otherwise a `UserCredentials` object with `name` and `password`,
properties.

## Attributions

Most of the code contained in BasicAuth is from [Kitura-CredentialsHTTP](https://github.com/IBM-Swift/Kitura-CredentialsHTTP).

## License

This library is licensed under Apache 2.0. Full license text is available in
[LICENSE](LICENSE).
