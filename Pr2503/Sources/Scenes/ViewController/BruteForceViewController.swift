import UIKit

class BruteForceViewController: UIViewController {

    //MARK: - Outlets -

    @IBOutlet weak var changeViewColorButton: UIButton!
    @IBOutlet weak var guessPasswordButton: UIButton!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!

    //MARK: - Actions -

    @IBAction func changeViewColorButtonTapped(_ sender: Any) {
        isBlack.toggle()
    }

    @IBAction func guessPasswordButtonTapped(_ sender: Any) {

        var passwordToUnlock: String
        let textFieldPassword = passwordTextField.text ?? ""

        if textFieldPassword == "" || textFieldPassword == previousPassword {
            passwordToUnlock = generatePassword()
        } else {
            passwordToUnlock = textFieldPassword
        }

        bruteIsRunning()
        passwordTextField.text = passwordToUnlock
        previousPassword = passwordToUnlock

        bruteForceWorkItem = DispatchWorkItem {
            self.bruteForce(passwordToUnlock: passwordToUnlock)
        }

        bruteForceWorkItem?.notify(queue: DispatchQueue.main) {
            self.bruteIsFinished()
        }

        queue.async(execute: bruteForceWorkItem!)
    }

    @IBAction func stopButtonTapped(_ sender: Any) {
        queue.async {
            self.bruteForceWorkItem?.cancel()
            print("Performing interrupted")
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.bruteIsInterrupted()
        }
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

    private var previousPassword = ""
    private let queue = DispatchQueue(label: "customQueue", qos: .userInitiated, attributes: .concurrent)
    var bruteForceWorkItem: DispatchWorkItem?

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

