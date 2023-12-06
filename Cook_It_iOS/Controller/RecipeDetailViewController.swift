//
//  RecipeDetailViewController.swift
//  Cook_It_iOS
//
//  Created by Mauricio Casillas on 02/11/23.
//

import UIKit

class RecipeDetailViewController: UIViewController {
    
    var id: String? = ""
    var segueName: String = ""
    
    private let recipeDetailService = RecipeServiceManager()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let contentScrollView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
    
        return view
    }()
    
    private let recipeTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
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
        list.spacing = 0
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
    
    private let recipeImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    private let buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 30
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    private let editButton: UIButton = {
        let button = UIButton()
        button.setTitle("Editar", for: .normal)
        button.backgroundColor = .clear
        button.setTitleColor(.green, for: .normal)
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.tintColor = .green
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Borrar", for: .normal)
        button.backgroundColor = .clear
        button.setTitleColor(.red, for: .normal)
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//      Add scrollView
        
        self.view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -90).isActive = true
        
        scrollView.addSubview(contentScrollView)
        contentScrollView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentScrollView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentScrollView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentScrollView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        
        if segueName == "localRecipeDetail" {
            let recipeManager = RecipeEntityManager(context: context)
            let recipe = recipeManager.getRecipe(id: String(id ?? "no hay id"))
            
//            edit and delete
            
            contentScrollView.addSubview(buttonStack)
            
            buttonStack.topAnchor.constraint(equalTo: contentScrollView.topAnchor).isActive = true
            buttonStack.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            
            buttonStack.addArrangedSubview(editButton)
            buttonStack.addArrangedSubview(deleteButton)
            
//              Title
            self.recipeTitle.text = recipe?.title
            self.contentScrollView.addSubview(self.recipeTitle)
            self.recipeTitle.topAnchor.constraint(equalTo: self.contentScrollView.topAnchor, constant: 40).isActive = true
            self.recipeTitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            
//              image
            self.recipeImage.image = UIImage(named: "cookitlogo")
            self.contentScrollView.addSubview(self.recipeImage)
            self.recipeImage.widthAnchor.constraint(equalToConstant: 280).isActive = true
            self.recipeImage.heightAnchor.constraint(equalToConstant: 130).isActive = true
            self.recipeImage.topAnchor.constraint(equalTo: self.recipeTitle.bottomAnchor, constant: 30).isActive = true
            self.recipeImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true

//              ingredientes label
            self.ingredients.text = "Ingredientes"
            self.contentScrollView.addSubview(self.ingredients)
            self.ingredients.topAnchor.constraint(equalTo: self.recipeImage.bottomAnchor, constant: 35).isActive = true
            self.ingredients.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40).isActive = true

//              ingredients list
            self.contentScrollView.addSubview(self.ingredientsList)
            recipe?.ingredients?.forEach() { ingredient in
                let ingredientLabel = UILabel()
                ingredientLabel.translatesAutoresizingMaskIntoConstraints = false
                ingredientLabel.font = UIFont(name: ingredientLabel.font.fontName, size: 15)
                ingredientLabel.numberOfLines = 0
                ingredientLabel.text = ingredient
                self.ingredientsList.addArrangedSubview(ingredientLabel)
                ingredientLabel.leadingAnchor.constraint(equalTo: self.ingredientsList.leadingAnchor).isActive = true
            }
            self.ingredientsList.topAnchor.constraint(equalTo: self.ingredients.bottomAnchor, constant: 15).isActive = true
            self.ingredientsList.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 60).isActive = true
            self.ingredientsList.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30).isActive = true

//              Process label
            self.process.text = "Preparación"
            self.contentScrollView.addSubview(self.process)
            self.process.topAnchor.constraint(equalTo: self.ingredientsList.bottomAnchor, constant: 25).isActive = true
            self.process.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40).isActive = true
                            
//              Process List
            self.contentScrollView.addSubview(self.processList)
            recipe?.process?.forEach() { process in
                let processLabel = UILabel()
                processLabel.translatesAutoresizingMaskIntoConstraints = false
                processLabel.font = UIFont(name: processLabel.font.fontName, size: 15)
                processLabel.numberOfLines = 0
                processLabel.text = process
                self.processList.addArrangedSubview(processLabel)
                processLabel.leadingAnchor.constraint(equalTo: self.processList.leadingAnchor).isActive = true
            }
            self.processList.topAnchor.constraint(equalTo: self.process.bottomAnchor, constant: 15).isActive = true
            self.processList.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 60).isActive = true
            self.processList.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30).isActive = true
            self.processList.bottomAnchor.constraint(equalTo: self.contentScrollView.bottomAnchor).isActive = true
            
        } else {
            recipeDetailService.getRecipeDetail(id: id ?? "") { recipe in
                DispatchQueue.main.async {
    //              Title
                    self.recipeTitle.text = recipe.title
                    self.contentScrollView.addSubview(self.recipeTitle)
                    self.recipeTitle.topAnchor.constraint(equalTo: self.contentScrollView.topAnchor).isActive = true
                    self.recipeTitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
                    
    //              image
                    self.recipeImage.sd_setImage(with: URL(string: recipe.image))
                    self.contentScrollView.addSubview(self.recipeImage)
                    self.recipeImage.widthAnchor.constraint(equalToConstant: 280).isActive = true
                    self.recipeImage.heightAnchor.constraint(equalToConstant: 130).isActive = true
                    self.recipeImage.topAnchor.constraint(equalTo: self.recipeTitle.bottomAnchor, constant: 30).isActive = true
                    self.recipeImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
                    
    //              ingredientes label
                    self.ingredients.text = "Ingredientes"
                    self.contentScrollView.addSubview(self.ingredients)
                    self.ingredients.topAnchor.constraint(equalTo: self.recipeImage.bottomAnchor, constant: 35).isActive = true
                    self.ingredients.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40).isActive = true
                    
    //              ingredients list
                    self.contentScrollView.addSubview(self.ingredientsList)
                    recipe.ingredients.forEach() { ingredient in
                        let ingredientLabel = UILabel()
                        ingredientLabel.translatesAutoresizingMaskIntoConstraints = false
                        ingredientLabel.font = UIFont(name: ingredientLabel.font.fontName, size: 15)
                        ingredientLabel.numberOfLines = 0
                        ingredientLabel.text = ingredient
                        self.ingredientsList.addArrangedSubview(ingredientLabel)
                        ingredientLabel.leadingAnchor.constraint(equalTo: self.ingredientsList.leadingAnchor).isActive = true
                    }
                    self.ingredientsList.topAnchor.constraint(equalTo: self.ingredients.bottomAnchor, constant: 15).isActive = true
                    self.ingredientsList.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 60).isActive = true
                    self.ingredientsList.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30).isActive = true
                    
    //              Process label
                    self.process.text = "Preparación"
                    self.contentScrollView.addSubview(self.process)
                    self.process.topAnchor.constraint(equalTo: self.ingredientsList.bottomAnchor, constant: 25).isActive = true
                    self.process.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40).isActive = true
                    
    //              Process List
                    self.contentScrollView.addSubview(self.processList)
                    recipe.process.forEach() { process in
                        let processLabel = UILabel()
                        processLabel.translatesAutoresizingMaskIntoConstraints = false
                        processLabel.font = UIFont(name: processLabel.font.fontName, size: 15)
                        processLabel.numberOfLines = 0
                        processLabel.text = process
                        self.processList.addArrangedSubview(processLabel)
                        processLabel.leadingAnchor.constraint(equalTo: self.processList.leadingAnchor).isActive = true
                    }
                    self.processList.topAnchor.constraint(equalTo: self.process.bottomAnchor, constant: 15).isActive = true
                    self.processList.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 60).isActive = true
                    self.processList.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30).isActive = true
                    self.processList.bottomAnchor.constraint(equalTo: self.contentScrollView.bottomAnchor).isActive = true
                }
            }
        }
    }
}
