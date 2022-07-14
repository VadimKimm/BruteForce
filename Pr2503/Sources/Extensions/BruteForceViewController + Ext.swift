//
//  BruteForceViewController + Ext.swift
//  Pr2503
//
//  Created by Vadim Kim on 12.07.2022.
//

import UIKit

extension BruteForceViewController {
    enum Strings {
        static let passwordLabelTextInitial = "Let me guess your password..."
        static let passwordLabelTextFailed = "Password not cracked"
        static let passwordLabelTextSucceded = "I believe your password is"
    }
}

//MARK: - UITextFieldDelegate -

extension BruteForceViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.isEditing {
            textField.isSecureTextEntry = true
        }
    }
}

//MARK: - Brute Forcing functions -

extension BruteForceViewController {

    func generatePassword() -> String {
        let allowedCharacters = String().printable.map { String($0) }
        var password = String()

        for _ in 0...2 {
            password += allowedCharacters.randomElement() ?? ""
        }

        return password
    }

    func bruteForce(passwordToUnlock: String) {
        let allowedCharacters = String().printable.map { String($0) }
        var password = ""

        // Will strangely ends at 0000 instead of ~~~
        while password != passwordToUnlock {

            guard let item = self.bruteForceWorkItem, !item.isCancelled else { break }

            password = generateBruteForce(password, fromArray: allowedCharacters)

            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
                self.passwordLabel.text = password
            }

            print(password)
        }

        guard password == passwordToUnlock else { return }

        DispatchQueue.main.async {
            self.passwordLabel.text = "\(Strings.passwordLabelTextSucceded) \(password)"
        }

        print("Password to unlock: \(passwordToUnlock)")
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
