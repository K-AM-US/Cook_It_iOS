//
//  AccountSettingsViewController.swift
//  Cook_It_iOS
//
//  Created by Mauricio Casillas on 15/12/23.
//

import UIKit
import Firebase
import FirebaseAuth

class AccountSettingsViewController: UIViewController {

    
    @IBOutlet var nameBox: UITextField!
    @IBOutlet var usernameBox: UITextField!
    @IBOutlet var passwordBox: UITextField!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        nameBox.text = ""
        usernameBox.text = ""
        passwordBox.text = ""
    }
    
    @IBAction func updateData(_ sender: Any) {
        
        if Auth.auth().currentUser != nil {
            let userManager = UserDataManager(context: self.context)
            var tmpName = userManager.getUser(uid: Auth.auth().currentUser!.uid)?.fullname
            var tmpUsername = userManager.getUser(uid: Auth.auth().currentUser!.uid)?.username
            if self.nameBox.text != "" {
                tmpName = self.nameBox.text!
            }
            if self.usernameBox.text != "" {
                tmpUsername = self.usernameBox.text!
            }
            if self.passwordBox.text != "" {
                Auth.auth().currentUser?.updatePassword(to: self.passwordBox.text!){ error in
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
            userManager.updateUser(user: userManager.getUser(uid: Auth.auth().currentUser!.uid)!, name: tmpName!, username: tmpUsername!)

            let alert = UIAlertController(title: "Nuevos datos", message: "Tus datos se han actualizado", preferredStyle: .alert)
            let action = UIAlertAction(title: "Aceptar", style: .default){ _ in
                self.nameBox.text = ""
                self.usernameBox.text = ""
                self.passwordBox.text = ""
            }
            alert.addAction(action)
            present(alert, animated: true)
        }
    }
    @IBAction func signOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.navigationController?.popToRootViewController(animated: true)
        } catch let error {
            print("No se pudo cerrar sesión: ", error)
        }
        
    }
}
