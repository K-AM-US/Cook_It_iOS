//
//  RegisterViewController.swift
//  Cook_It_iOS
//
//  Created by Mauricio Casillas on 14/12/23.
//

import UIKit
import Firebase
import FirebaseAuth

class RegisterViewController: UIViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private let image: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "person.circle"))
        image.tintColor = UIColor(named: "blueCookIt")
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        
        label.text = "Estas a punto de compartir tus recetas, sólo necesitamos algunos datos."
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let name: UITextField = {
        let textField = UITextField()
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.placeholder = "Nombre"
        textField.layer.cornerRadius = 50
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private let lastname: UITextField = {
        let textField = UITextField()
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.placeholder = "Apellido"
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private let username: UITextField = {
        let textField = UITextField()
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.placeholder = "Nombre de usuario"
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private let email: UITextField = {
        let textField = UITextField()
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.placeholder = "Correo Electrónico"
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private let password: UITextField = {
        let textField = UITextField()
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.placeholder = "Contraseña"
        textField.textContentType = .password
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private let verifyPassword: UITextField = {
        let textField = UITextField()
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.placeholder = "Verificar contraseña"
        textField.textContentType = .password
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.configuration = .filled()
        button.setTitle("Registrarse", for: .normal)
        button.configuration?.baseBackgroundColor = UIColor(named: "blueCookIt")
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
    }
    
    @objc func registerButtonAction() {
        var message = ""
        if name.text == ""{
            message = "Se require un nombre"
        } else if email.text == "" {
            message = "Se requiere un correo válido"
        } else if password.text == "" {
            message = "Se requiere una contraseña"
        } else if password.text?.count ?? 0 < 6 {
            message = "La contraseña debe ser de al menos 6 caracteres "
        } else if password.text != verifyPassword.text {
            message = "Las contraseñas no coinciden"
        }
        
        if message == "" {
            Auth.auth().createUser(withEmail: email.text!, password: password.text!){ result, error in
                if result != nil {
                    let userDataManager = UserDataManager(context: self.context)
                    let tmp = UserDataEntity(context: self.context)
                    tmp.uid = Auth.auth().currentUser?.uid
                    tmp.fullname = self.name.text! + " " + self.lastname.text!
                    tmp.username = self.username.text
                    
                    DispatchQueue.main.async {
                        userDataManager.createUser(user: tmp)
                    }
                    
                    self.navigationController?.popToRootViewController(animated: true)
                } else {
                    let alert = UIAlertController(title: "Error", message: "No se pudo crear usuario", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Aceptar", style: .default)
                    alert.addAction(action)
                    self.present(alert, animated: true)
                }
            }
        } else {
            let alert = UIAlertController(title: "Error en el registro", message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "Aceptar", style: .default)
            
            alert.addAction(action)
            present(alert, animated: true)
        }
    }
    
    
    
    private func initViews() {
        view.addSubview(image)
        image.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        image.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        image.widthAnchor.constraint(equalToConstant: 160).isActive = true
        image.heightAnchor.constraint(equalToConstant: 160).isActive = true
        
        view.addSubview(label)
        label.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 25).isActive = true
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.widthAnchor.constraint(equalToConstant: 240).isActive = true
        
        view.addSubview(name)
        name.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 30).isActive = true
        name.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        name.widthAnchor.constraint(equalToConstant: 280).isActive = true
        
        view.addSubview(lastname)
        lastname.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 15).isActive = true
        lastname.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        lastname.widthAnchor.constraint(equalToConstant: 280).isActive = true
        
        view.addSubview(username)
        username.topAnchor.constraint(equalTo: lastname.bottomAnchor, constant: 15).isActive = true
        username.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        username.widthAnchor.constraint(equalToConstant: 280).isActive = true
        
        view.addSubview(email)
        email.topAnchor.constraint(equalTo: username.bottomAnchor, constant: 15).isActive = true
        email.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        email.widthAnchor.constraint(equalToConstant: 280).isActive = true
        
        view.addSubview(password)
        password.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 15).isActive = true
        password.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        password.widthAnchor.constraint(equalToConstant: 280).isActive = true
        
        view.addSubview(verifyPassword)
        verifyPassword.topAnchor.constraint(equalTo: password.bottomAnchor, constant: 15).isActive = true
        verifyPassword.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        verifyPassword.widthAnchor.constraint(equalToConstant: 280).isActive = true
        
        view.addSubview(registerButton)
        registerButton.topAnchor.constraint(equalTo: verifyPassword.bottomAnchor, constant: 30).isActive = true
        registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerButton.addTarget(self, action: #selector(registerButtonAction), for: .touchUpInside)
    }
}
