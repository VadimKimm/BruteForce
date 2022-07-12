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

    private func generatePassword() -> String {
        let allowedCharacters: [String] = String().printable.map { String($0) }
        var password = String()

        for _ in 0...2 {
            password += allowedCharacters.randomElement() ?? ""
        }

        return password
    }
    
    private func bruteForce(passwordToUnlock: String) {
        let allowedCharacters = String().printable.map { String($0) }

        var password = ""

        // Will strangely ends at 0000 instead of ~~~
        while password != passwordToUnlock { // Increase MAXIMUM_PASSWORD_SIZE value for more
            password = generateBruteForce(password, fromArray: allowedCharacters)

            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
            }

            print(password)
        }

        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.passwordLabel.text = "Я думаю, что это: \(password)"
            self.passwordTextField.isSecureTextEntry = false
        }
        
        print("Загаданный пароль: \(password)")
    }

    private func indexOf(character: Character, _ array: [String]) -> Int {
        return array.firstIndex(of: String(character))!
    }

    private func characterAt(index: Int, _ array: [String]) -> Character {
        return index < array.count ? Character(array[index]) : Character("")
    }

    private func generateBruteForce(_ string: String, fromArray array: [String]) -> String {
        var str = string

        if str.count <= 0 {
            str.append(characterAt(index: 0, array))
        }
        else {
            str.replace(at: str.count - 1,
                        with: characterAt(index: (indexOf(character: str.last!, array) + 1) % array.count, array))

            if indexOf(character: str.last!, array) == 0 {
                str = String(generateBruteForce(String(str.dropLast()), fromArray: array)) + String(str.last!)
            }
        }

        return str
    }
}

