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

        guard let bruteForceWorkItem = bruteForceWorkItem else { return }

        bruteForceWorkItem.notify(queue: DispatchQueue.main) {
            self.bruteIsFinished()
        }

        queue.async(execute: bruteForceWorkItem)
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

    enum Status {
        case initial
        case running
        case finished
    }

    private var bruteStatus = Status.initial {
        didSet {
            switch self.bruteStatus {
            case .initial:
                imageView.image = UIImage.gifImageWithName("clippy-initial")
            case .running:
                imageView.image = UIImage.gifImageWithName("clippy-running")
            case .finished:
                imageView.image = UIImage.gifImageWithName("clippy-finished")
            }
        }
    }

    private var isBlack = false {
        didSet {
            view.backgroundColor = isBlack ? .black : .white
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

        passwordTextField.delegate = self
    }

    //MARK: - Functions -

    private func setupView() {
        passwordLabel.text = Strings.passwordLabelTextInitial
        activityIndicator.hidesWhenStopped = true
        passwordTextField.clearButtonMode = .whileEditing
        passwordTextField.clearsOnBeginEditing = true
        passwordTextField.isSecureTextEntry = true
        stopButton.isEnabled = false
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }

    private func bruteIsRunning() {
        passwordLabel.text = Strings.passwordLabelTextInitial
        passwordTextField.isSecureTextEntry = true
        passwordTextField.isEnabled = false
        stopButton.isEnabled = true
        guessPasswordButton.isEnabled = false
        bruteStatus = .running
    }

    private func bruteIsFinished() {
        activityIndicator.stopAnimating()
        passwordTextField.isSecureTextEntry = false
        passwordTextField.isEnabled = true
        stopButton.isEnabled = false
        guessPasswordButton.isEnabled = true
        bruteStatus = .finished
    }

    private func bruteIsInterrupted() {
        passwordLabel.text = Strings.passwordLabelTextFailed
        stopButton.isEnabled = false
        guessPasswordButton.isEnabled = true
        bruteStatus = .initial
    }
}

