//
//  NewRecipeViewController.swift
//  Cook_It_iOS
//
//  Created by Mauricio Casillas on 29/11/23.
//

import UIKit

class NewRecipeViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
//        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let contentScrollView: UIView = {
        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let inputBox: UITextField = {
        let input = UITextField()
        input.borderStyle = UITextField.BorderStyle.line
        input.font = UIFont.preferredFont(forTextStyle: .title1)
        input.placeholder = "Título de la receta"
        input.textAlignment = .center
        input.isUserInteractionEnabled = true
        input.translatesAutoresizingMaskIntoConstraints = false
        
        return input
    }()
    
    private let recipeImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "cookitlogo")
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    private let ingredients: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let ingredientsList: UIStackView = {
        let list = UIStackView()
        
        list.axis = .vertical
        list.spacing = 2
        list.translatesAutoresizingMaskIntoConstraints = false
        
        return list
    }()
    
    private let process: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let processList: UIStackView = {
        let list = UIStackView()
        
        list.axis = .vertical
        list.spacing = 0
        list.translatesAutoresizingMaskIntoConstraints = false
        
        return list
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.configuration = .filled()
        button.configuration?.baseBackgroundColor = .systemGreen
        button.configuration?.cornerStyle = .medium
        button.setTitle("+", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()

    private let removeButton: UIButton = {
        let button = UIButton(type: .system)
        button.configuration = .filled()
        button.configuration?.baseBackgroundColor = .systemRed
        button.configuration?.cornerStyle = .medium
        button.setTitle("-", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let addButtonProcess: UIButton = {
        let button = UIButton(type: .system)
        button.configuration = .filled()
        button.configuration?.baseBackgroundColor = .systemGreen
        button.configuration?.cornerStyle = .medium
        button.setTitle("+", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()

    private let removeButtonProcess: UIButton = {
        let button = UIButton(type: .system)
        button.configuration = .filled()
        button.configuration?.baseBackgroundColor = .systemRed
        button.configuration?.cornerStyle = .medium
        button.setTitle("-", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let createRecipeButton: UIButton = {
        let button = UIButton(type: .system)
        button.configuration = .filled()
        button.configuration?.cornerStyle = .medium
        button.setTitle("Crear receta", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(scrollView)
        

        self.view.addSubview(scrollView)
        scrollView.frame = self.view.bounds
        scrollView.addSubview(contentScrollView)
        contentScrollView.frame = scrollView.bounds
        contentScrollView.addSubview(inputBox)
        
//        self.view.addSubview(scrollView)
//        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
//        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -90).isActive = true
        
//        scrollView.addSubview(contentScrollView)
//        contentScrollView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
//        contentScrollView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
//        contentScrollView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
//        contentScrollView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        
        contentScrollView.addSubview(inputBox)
        inputBox.widthAnchor.constraint(equalToConstant: 220).isActive = true
        inputBox.topAnchor.constraint(equalTo: contentScrollView.topAnchor).isActive = true
        inputBox.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        contentScrollView.addSubview(recipeImage)
        recipeImage.widthAnchor.constraint(equalToConstant: 220).isActive = true
        recipeImage.heightAnchor.constraint(equalToConstant: 220).isActive = true
        recipeImage.topAnchor.constraint(equalTo: inputBox.bottomAnchor, constant: 30).isActive = true
        recipeImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        contentScrollView.addSubview(ingredients)
        ingredients.text = "Ingredientes"
        ingredients.topAnchor.constraint(equalTo: recipeImage.bottomAnchor, constant: 35).isActive = true
        ingredients.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        
        contentScrollView.addSubview(ingredientsList)
        ingredientsList.topAnchor.constraint(equalTo: ingredients.bottomAnchor, constant: 15).isActive = true
        ingredientsList.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60).isActive = true
        ingredientsList.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60).isActive = true
        
        contentScrollView.addSubview(addButton)
        addButton.topAnchor.constraint(equalTo: ingredientsList.bottomAnchor, constant: 10).isActive = true
        addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addButton.addTarget(self, action: #selector(addIngredient), for: .touchUpInside)

        contentScrollView.addSubview(removeButton)
        removeButton.topAnchor.constraint(equalTo: ingredientsList.bottomAnchor, constant: 10).isActive = true
        removeButton.leadingAnchor.constraint(equalTo: addButton.trailingAnchor, constant: 20).isActive = true
        removeButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        removeButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        removeButton.addTarget(self, action: #selector(removeIngredient), for: .touchUpInside)
        
        
        contentScrollView.addSubview(process)
        process.text = "Preparación"
        process.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 35).isActive = true
        process.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        
        contentScrollView.addSubview(processList)
        processList.topAnchor.constraint(equalTo: process.bottomAnchor, constant: 15).isActive = true
        processList.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60).isActive = true
        processList.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        
        contentScrollView.addSubview(addButtonProcess)
        addButtonProcess.topAnchor.constraint(equalTo: processList.bottomAnchor, constant: 10).isActive = true
        addButtonProcess.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60).isActive = true
        addButtonProcess.widthAnchor.constraint(equalToConstant: 40).isActive = true
        addButtonProcess.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addButtonProcess.addTarget(self, action: #selector(addProcess), for: .touchUpInside)

        contentScrollView.addSubview(removeButtonProcess)
        removeButtonProcess.topAnchor.constraint(equalTo: processList.bottomAnchor, constant: 10).isActive = true
        removeButtonProcess.leadingAnchor.constraint(equalTo: addButtonProcess.trailingAnchor, constant: 20).isActive = true
        removeButtonProcess.widthAnchor.constraint(equalToConstant: 40).isActive = true
        removeButtonProcess.heightAnchor.constraint(equalToConstant: 40).isActive = true
        removeButtonProcess.addTarget(self, action: #selector(removeProcess), for: .touchUpInside)
        
        contentScrollView.addSubview(createRecipeButton)
        createRecipeButton.topAnchor.constraint(equalTo:  addButtonProcess.bottomAnchor, constant: 25).isActive = true
        createRecipeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        createRecipeButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        createRecipeButton.addTarget(self, action: #selector(createRecipeButtonAction), for: .touchUpInside)
    }
    
    @objc func addIngredient() {
        let ingredientField = UITextField()
        ingredientField.placeholder = "Ingrediente"
        ingredientField.translatesAutoresizingMaskIntoConstraints = false
        ingredientsList.addArrangedSubview(ingredientField)
        ingredientField.leadingAnchor.constraint(equalTo: ingredientsList.leadingAnchor).isActive = true
    }
    
    @objc func removeIngredient() {
        if ingredientsList.subviews.count > 0 {
            ingredientsList.subviews[ingredientsList.subviews.count - 1].removeFromSuperview()
        }
    }
    
    @objc func addProcess() {
        let processField = UITextField()
        processField.placeholder = "Paso"
        processField.translatesAutoresizingMaskIntoConstraints = false
        processList.addArrangedSubview(processField)
        processField.leadingAnchor.constraint(equalTo: processField.leadingAnchor).isActive = true
    }
    
    @objc func removeProcess() {
        if processList.subviews.count > 0 {
            processList.subviews[processList.subviews.count - 1].removeFromSuperview()
        }
    }
    
    @objc func createRecipeButtonAction() {
        let recipeManager = RecipeEntityManager(context: context)
        let recipeTmp = RecipeEntity(context: context)
        recipeTmp.recipe_id = Int64(666)
        recipeTmp.title = "esta es una receta de prueba"
        recipeManager.createRecipe(recipe: recipeTmp)
    }
}
