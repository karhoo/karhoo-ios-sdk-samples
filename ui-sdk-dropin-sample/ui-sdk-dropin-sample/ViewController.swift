
import UIKit
import KarhooSDK
import KarhooUISDK
import CoreLocation

class ViewController: UIViewController {
    
    private var booking: Screen?

    private lazy var tokenExchangeBookingButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login with Token Exchange", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var guestBookingButton: UIButton = {
        let button = UIButton()
        button.setTitle("Continue as Guest", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var tokenExchangeBookingWithDataButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login with Token Exchange [With Data]", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var guestBookingWithDataButton: UIButton = {
        let button = UIButton()
        button.setTitle("Continue as Guest [With Data]", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        tokenExchangeBookingButton.addTarget(self, action: #selector(tokenExchangeBookingTapped), for: .touchUpInside)
        guestBookingButton.addTarget(self, action: #selector(guestBraintreeBookingTapped), for: .touchUpInside)
        tokenExchangeBookingWithDataButton.addTarget(self, action: #selector(tokenExchangeBookingWithDataTapped), for: .touchUpInside)
        guestBookingWithDataButton.addTarget(self, action: #selector(guestBraintreeBookingWithDataTapped), for: .touchUpInside)
        
    }
    
    override func loadView() {
        super.loadView()

        [tokenExchangeBookingButton, guestBookingButton, tokenExchangeBookingWithDataButton, guestBookingWithDataButton].forEach { button in
            self.view.addSubview(button)
        }
        
        tokenExchangeBookingButton.centerX(inView: view)
        tokenExchangeBookingButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 80)
        
        guestBookingButton.centerX(inView: view)
        guestBookingButton.anchor(top: tokenExchangeBookingButton.bottomAnchor, paddingTop: 30)
        
        tokenExchangeBookingWithDataButton.centerX(inView: view)
        tokenExchangeBookingWithDataButton.anchor(top: guestBookingButton.bottomAnchor, paddingTop: 80)
        
        guestBookingWithDataButton.centerX(inView: view)
        guestBookingWithDataButton.anchor(top: tokenExchangeBookingWithDataButton.bottomAnchor, paddingTop: 30)
    }
    
    @objc func tokenExchangeBookingTapped(sender: UIButton) {
        let tokenExchangeSettings = TokenExchangeSettings(clientId: Keys.tokenClientId, scope: Keys.tokenScope)
        KarhooConfig.auth = .tokenExchange(settings: tokenExchangeSettings)
        KarhooConfig.environment = Keys.braintreeTokenEnvironment
        tokenLoginAndShowKarhoo(token: Keys.authToken)
    }

    
    @objc func guestBraintreeBookingTapped(sender: UIButton) {
        let guestSettings = GuestSettings(identifier: Keys.guestIdentifier,
                                          referer: Keys.referer,
                                          organisationId: Keys.guestOrganisationId)
        KarhooConfig.auth = .guest(settings: guestSettings)
        KarhooConfig.environment = Keys.guestEnvironment
        showKarhoo()
    }
    
    @objc func tokenExchangeBookingWithDataTapped(sender: UIButton) {
        let tokenExchangeSettings = TokenExchangeSettings(clientId: Keys.tokenClientId, scope: Keys.tokenScope)
        KarhooConfig.auth = .tokenExchange(settings: tokenExchangeSettings)
        KarhooConfig.environment = Keys.braintreeTokenEnvironment
        tokenLoginAndShowKarhoo(token: Keys.authToken, withData: true)
    }
    
    @objc func guestBraintreeBookingWithDataTapped(sender: UIButton) {
        let guestSettings = GuestSettings(identifier: Keys.guestIdentifier,
                                          referer: Keys.referer,
                                          organisationId: Keys.guestOrganisationId)
        KarhooConfig.auth = .guest(settings: guestSettings)
        KarhooConfig.environment = Keys.guestEnvironment
        showKarhooWithData()
    }
    
    private func tokenLoginAndShowKarhoo(token: String, withData: Bool = false) {
        let authService = Karhoo.getAuthService()

        authService.login(token: token).execute { result in
            print("token login: \(result)")
            if result.isSuccess() {
                if(withData){
                    self.showKarhooWithData()
                } else {
                    self.showKarhoo()
                }
            }
        }
    }
    
    func showKarhoo() {
        booking = KarhooUI().screens().booking().buildBookingScreen(journeyInfo: nil,
                                                                    passengerDetails: nil,
                                                                    callback: { [weak self] result in
                                                                        switch result {
                                                                        case .completed(let result):
                                                                            switch result {
                                                                            case .tripAllocated(let trip): (self?.booking as? BookingScreen)?.openTrip(trip)
                                                                            default: break
                                                                            }
                                                                        default: break
                                                                        }
                                                                    }) as? BookingScreen

        self.present(booking!,
                     animated: true,
                     completion: nil)
    }
    
    func showKarhooWithData() {
    let originLat = CLLocationDegrees(Double(51.500869))
            let originLon = CLLocationDegrees(Double(-0.124979))
            let destLat = CLLocationDegrees(Double(51.502159))
            let destLon = CLLocationDegrees(Double(-0.142040))
            
            let journeyInfo: JourneyInfo = JourneyInfo(origin: CLLocation(latitude: originLat,
                                                             longitude: originLon),
                                                       destination: CLLocation(latitude: destLat,
                                                                               longitude: destLon))
            
            let passangerDetails: PassengerDetails = PassengerDetails(firstName: "",
                                lastName: "",
                                email: "",
                                phoneNumber: "",
                                locale: "en")
            booking = KarhooUI().screens().booking().buildBookingScreen(journeyInfo: journeyInfo,
                                             passengerDetails: passangerDetails,
                                             callback: { [weak self] result in
                                              switch result {
                                              case .completed(let bookingScreenResult):
                                                switch bookingScreenResult {
                                                case .tripAllocated(let trip): print("did book trip: ", trip)
                                                default: break
                                                }
                                              default: break
                                              }
                                             }) as? BookingScreen
            self.present(booking!, animated: true, completion: nil)
    }
    
    private func logout() {
        if Karhoo.configuration.authenticationMethod().isGuest() {
            return
        }

        Karhoo.getUserService().logout().execute(callback: { _ in})
    }

}

