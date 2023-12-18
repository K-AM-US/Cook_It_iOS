//
//  LogInViewController.swift
//  Cook_It_iOS
//
//  Created by Mauricio Casillas on 14/12/23.
//

import UIKit
import Firebase
import FirebaseAuth

class LogInViewController: UIViewController {
    
    
    @IBOutlet var userEmail: UITextField!
    @IBOutlet var userPassword: UITextField!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func recoverPasswordAction(_ sender: Any) {
        let window = UIAlertController(title: "Recuperar contraseña", message: "Ingresa tu correo electrónico para enviar el link de recuperación", preferredStyle: .alert)
        window.addTextField()
        let action = UIAlertAction(title: "Enviar", style: .default) { result in
            if let email = window.textFields?[0].text {
                Auth.auth().sendPasswordReset(withEmail: email) { error in
                    if error == nil {
                        let alert = UIAlertController(title: "Correo Enviado", message: "Se ha enviado el correo para restablecer la contraseña", preferredStyle: .alert)
                        let action = UIAlertAction(title: "Aceptar", style: .default)
                        alert.addAction(action)
                        self.present(alert, animated: true)
                    } else {
                        let alert = UIAlertController(title: "Error", message: "No se pudo enviar el correo", preferredStyle: .alert)
                        let action = UIAlertAction(title: "Aceptar", style: .default)
                        alert.addAction(action)
                        self.present(alert, animated: true)
                    }
                }
            }
        }
        window.addAction(action)
        present(window, animated: true)
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        if let email = userEmail.text, let password = userPassword.text {
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if result != nil {
                    
                    let userDataManager = UserDataManager(context: self.context)
                    let tmp = UserDataEntity(context: self.context)
                    tmp.uid = Auth.auth().currentUser?.uid
                    tmp.fullname = ""
                    tmp.username = String((Auth.auth().currentUser?.email?.split(separator: "@" , omittingEmptySubsequences: true)[0])!)
                    
                    DispatchQueue.main.async {
                        userDataManager.createUser(user: tmp)
                    }
                    
                    self.navigationController?.popToRootViewController(animated: true)
                } else {
                    let alert = UIAlertController(title: "Error en las credenciales", message: "No se pudo autenticar al usuario", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Aceptar", style: .default)
                    alert.addAction(action)
                    self.present(alert, animated: true)
                }
            }
        }
    }
}
