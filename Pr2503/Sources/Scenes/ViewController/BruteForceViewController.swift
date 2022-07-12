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
    }

    //MARK: - Properties -

    var isBlack: Bool = false {
        didSet {
            view.backgroundColor = isBlack ? .black : .white
        }
    }

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
        let ALLOWED_CHARACTERS:   [String] = String().printable.map { String($0) }

        var password: String = ""

        // Will strangely ends at 0000 instead of ~~~
        while password != passwordToUnlock { // Increase MAXIMUM_PASSWORD_SIZE value for more
            password = generateBruteForce(password, fromArray: ALLOWED_CHARACTERS)
//             Your stuff here
            print(password)
            // Your stuff here
        }
        
        print(password)
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

