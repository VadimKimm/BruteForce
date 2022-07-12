import UIKit

class BruteForceViewController: UIViewController {

    //MARK: - Outlets -

    @IBOutlet weak var changeViewColorButton: UIButton!
    @IBOutlet weak var guessPasswordButton: UIButton!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - Actions -

    @IBAction func changeViewColorTapped(_ sender: Any) {
        isBlack.toggle()
    }
    @IBAction func guessPasswordButtonTapped(_ sender: Any) {

        let passwordToUnlock = generatePassword()

        let bruteForceItem = DispatchWorkItem {
            self.bruteForce(passwordToUnlock: passwordToUnlock)
        }

        queue.async(execute: bruteForceItem)

        passwordLabel.text = Strings.passwordLabelText
        passwordTextField.text = passwordToUnlock
        passwordTextField.isSecureTextEntry = true
    }

    //MARK: - Properties -

    private lazy var isBlack: Bool = false {
        didSet {
            view.backgroundColor = isBlack ? .black : .white
            passwordTextField.backgroundColor = isBlack ? .black : .white
            passwordTextField.textColor = isBlack ? .white : .black
            passwordLabel.textColor = isBlack ? .white : .black
            activityIndicator.color = isBlack ? .white : .black
        }
    }

    private let queue = DispatchQueue(label: "customQueue", qos: .userInitiated)

    //MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    //MARK: - Functions -

    private func setupView() {
        passwordLabel.text = Strings.passwordLabelText
        activityIndicator.hidesWhenStopped = true
    }
}

