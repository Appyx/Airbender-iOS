//
//  ViewController.swift
//  Airbender
//
//  Created by Robert Gstöttner, Christopher Ebner, Manuel Mühlschuster on 14.11.18.
//  Copyright © 2018 Appyx. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    let commManager = CommunicationManager.shared

    @IBOutlet weak var participantIdTextField: UITextField!
    @IBOutlet weak var recordingsNoTextField: UITextField!
    @IBOutlet weak var randomizedGesturesSwitch: UISwitch!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }

    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func startRecording(_ sender: Any?) {
        guard commManager.session!.isReachable else {
            presentAlert(title: "Error!", msg: "Open the app on your Apple Watch")
            return
        }
        guard let name = participantIdTextField.text, !name.isEmpty else {
            presentAlert(title: "Error!", msg: "Enter your name")
            return
        }
        guard let text = recordingsNoTextField.text, let number = Int(text) else {
            presentAlert(title: "Error!", msg: "Enter the number of recordings")
            return
        }
        let presenter = GesturePresenter(participant: name, numberOfRecordings: number)
        performSegue(withIdentifier: "GestureControllerSegue", sender: presenter)
    }

    private func presentAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
        }))
        present(alert, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! GestureViewController
        vc.presenter = sender as? GesturePresenter
    }

}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


