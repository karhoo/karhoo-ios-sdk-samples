import KarhooSDK
import KarhooUISDK

struct Keys {
    static func staging() -> KarhooEnvironment {
        return .custom(environment: KarhooEnvironmentDetails(host: "https://rest.stg.karhoo.net",
                                                             authHost: "https://sso.stg.karhoo.net",
                                                             guestHost: "https://public-api.stg.karhoo.net"))
    }

    static let braintreeGuestIdentifier = "BQ0AAgUECgwHBQMFBAgHAABAMJCAACCw"
    static let referer = "https://mobile.karhoo.com"
    static let braintreeGuestOrganisationId = "ed5ae432-1ff7-4d69-a4a6-2d4a65c81b0c"
    static let adyenGuestOrganisationId = "7519c0bc-3327-434e-9f47-2198458e8674"
    static let adyenGuestIdentifier = "LVvOVFJWAXOrBwhViPcKQvhUzRcOZILQ"

    private static let userServiceEmailBraintree = "jeevan.thandi+staging@karhoo.com"
    private static let userServicePasswordBraintree = "12345678Aa"

    private static let userServiceEmailAdyen = "adyentestuser2@karhoo.com"
    private static let userServicePasswordAdyen = "Karhoo2020!"

    static let userLogin = UserLogin(username: userServiceEmailAdyen,
                                     password: userServicePasswordAdyen)

    static let tokenClientId = "karhoo-adyen-uat"
    static let tokenScope = "openid profile email phone address https://karhoo.com/traveller"
    static let authToken = "eyJraWQiOiI4Yjg4ZjNmYzlmYzEyYTQxMTBhYmRmMDBlZDQ0ZjU1OGVjYjhiNGFkZTNiYzk3YTYyYzRlYjk0ZDQ4NGQ1NzQ3IiwiYWxnIjoiUlMyNTYifQ.eyJqdGkiOiI1NTNiMjBiYy0zNzJiLTQ3NzMtYmYwZS0wMDY0YzJlZmFjM2EiLCJhdWQiOiJodHRwczovL3Nzby5zdGcua2FyaG9vLm5ldC9vYXV0aC92Mi90b2tlbi1leGNoYW5nZSIsImlzcyI6Imthcmhvby1hZHllbi11YXQiLCJpYXQiOjE2MDI1MDY0NjIsImV4cCI6MTYxMjUwODI2Miwic3ViIjoiNGE5NDgxOTEtNjAwMS00MWM1LWI0NmItNjRiYzAzMjFlOTlmIiwiZ2l2ZW5fbmFtZSI6IkpvaG4iLCJmYW1pbHlfbmFtZSI6IkRvZSIsImVtYWlsIjoiam9obi5kb2VAZXhhbXBsZS5jb20iLCJwaG9uZV9udW1iZXIiOiIiLCJsb2NhbGUiOiJlbiJ9.NBE2wGL5PFjmRLPbz9YadjCEZgfH2w0GLmgai9nILltmJO5SAPI6yCPA1UCpa7oJGwJQrr6KXjDYHaH3eeRQDmU7lf4Y346jxe7xQm8v3biU2xoZzk9kFWqiJyRwH05Gv5pRaPg1uxFRSG2FfCrzhD8LM33Yca5B03HypGU98XaulE9E9kEuZj3HOFKYvDS6gcHezTRdYX_rkDBpQaLGED5hW-2eXrvS6_mw328eNAcCIZyGdiBA_BovVxfQ1aPUndJkfl_dWM352N5iPnjjI1fY1r_7ndhLv0YgI4reMonxh1ZB2lXMrURvGIoJkHUF3fE2xzolUmx4bEKYH3uRZw"
}

let guestSettings = GuestSettings(identifier: Keys.adyenGuestIdentifier,
                                  referer: Keys.referer,
                                  organisationId: Keys.adyenGuestOrganisationId)

let tokenExchangeSettings = TokenExchangeSettings(clientId: Keys.tokenClientId, scope: Keys.tokenScope)

class KarhooConfig: KarhooUISDKConfiguration {

    static var auth: AuthenticationMethod = .karhooUser

    func environment() -> KarhooEnvironment {
        return .sandbox
    }

    func authenticationMethod() -> AuthenticationMethod {
        return KarhooConfig.auth
    }
}
