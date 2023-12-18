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
        let button = UIButton(type: .system)
        button.setTitle("Editar", for: .normal)
        button.setTitleColor(.green, for: .normal)
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.tintColor = .systemGreen
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Borrar", for: .normal)
        button.backgroundColor = .clear
        button.setTitleColor(.red, for: .normal)
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = .systemRed
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let buttonReload: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Recargar", for: .normal)
        button.tintColor = UIColor(named: "blueCookIt")
        button.configuration = .filled()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let networkMessage: UILabel = {
        let label = UILabel()
        label.text = "Ocurrió un error,\n intenta otra vez"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let progressBar: UIActivityIndicatorView = {
        let progress = UIActivityIndicatorView()
        progress.style = .large
        progress.color = UIColor(named: "blueCookIt")
        progress.translatesAutoresizingMaskIntoConstraints = false
        
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(progressBar)
        progressBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        progressBar.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        progressBar.startAnimating()
        progressBar.isHidden = false

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        //      Add scrollView
        self.view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -90).isActive = true
                
        scrollView.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        scrollView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
                
        scrollView.addSubview(contentScrollView)
        contentScrollView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentScrollView.bottomAnchor.constraint(equalTo:scrollView.bottomAnchor).isActive = true
        contentScrollView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentScrollView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
                
        contentScrollView.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        contentScrollView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
                
        if segueName == "localRecipeDetail" {
            progressBar.isHidden = true
            let recipeManager = RecipeEntityManager(context: context)
            let recipe = recipeManager.getRecipe(id: String(id ?? "no hay id"))
                    
//            edit and delete
            contentScrollView.addSubview(buttonStack)
            buttonStack.topAnchor.constraint(equalTo: contentScrollView.topAnchor).isActive = true
            buttonStack.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
                    
            buttonStack.addArrangedSubview(editButton)
            buttonStack.addArrangedSubview(deleteButton)
                    
            editButton.addTarget(self, action: #selector(editButtonAction), for: .touchUpInside)
            deleteButton.addTarget(self, action: #selector(deleteButtonAction), for: .touchUpInside)
                    
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
                    
        } else if segueName == "favouriteRecipeDetail" {
            progressBar.isHidden = true
            if id!.count <= 4 {
//            edit and delete
                contentScrollView.addSubview(buttonStack)
                                    
                buttonStack.topAnchor.constraint(equalTo: contentScrollView.topAnchor).isActive = true
                buttonStack.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
                                    
                buttonStack.addArrangedSubview(editButton)
                buttonStack.addArrangedSubview(deleteButton)
                                    
                editButton.addTarget(self, action: #selector(editButtonAction), for: .touchUpInside)
                deleteButton.addTarget(self, action: #selector(deleteButtonAction), for: .touchUpInside)
            }
                    
            let favouriteManager = FavouriteEntityManager(context: context)
            let recipe = favouriteManager.getFavourite(id: String(id ?? "no hay id"))
                    
//              Title
            self.recipeTitle.text = recipe?.favouriteRecipeTitle
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
            recipe?.favouriteRecipeIngredients?.forEach() { ingredient in
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
            recipe?.favouriteRecipeProcess?.forEach() { process in
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
                    
        }else {
            if InternetMonitor.shared.internetStatus {
                buttonReload.isHidden = true
                networkMessage.isHidden = true
                recipeDetailService.getRecipeDetail(id: id ?? "") { recipe in
                    DispatchQueue.main.async {
                        self.progressBar.isHidden = true
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
                    }
                }
            } else {
                buttonReload.isHidden = false
                progressBar.isHidden = true
                        
                view.addSubview(networkMessage)
                networkMessage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                networkMessage.topAnchor.constraint(equalTo: view.topAnchor, constant: 300).isActive = true
                        
                        
                view.addSubview(buttonReload)
                buttonReload.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                buttonReload.topAnchor.constraint(equalTo: networkMessage.bottomAnchor, constant: 130).isActive = true
                buttonReload.addTarget(self, action: #selector(reload), for: .touchUpInside)
            }
        }
    }
    
    @objc func reload() {
        viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editRecipe" {
            let destination = segue.destination as! NewRecipeViewController
            destination.isEditingRecipe = true
            destination.editingId = id!
        }
    }
    
    @objc func editButtonAction() {
        performSegue(withIdentifier: "editRecipe", sender: self)
    }
    
    @objc func deleteButtonAction() {
        let recipeManager = RecipeEntityManager(context: context)
        let tmp = recipeManager.getRecipe(id: id ?? "")
        if tmp != nil {
            recipeManager.deleteRecipe(recipe: tmp!)
        }
        performSegue(withIdentifier: "deletedRecipe", sender: self)
    }
}
