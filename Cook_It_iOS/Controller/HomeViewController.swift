//
//  HomeViewController.swift
//  Cook_It_iOS
//
//  Created by Mauricio Casillas on 23/10/23.
//

import UIKit
import SDWebImage
import Firebase
import FirebaseAuth

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, RecipeCellDelegate {
    
    @IBOutlet var recipesTable: UITableView!
    @IBOutlet var recipesCarousel: UICollectionView!
    @IBOutlet var loginButton: UIButton!
    
    private var carouselIndex = 0
    private let recipeService = RecipeServiceManager()
    private var recipeList: [RecipeDto] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
    
        recipesTable.dataSource = self
        recipesTable.delegate = self
        
        recipesCarousel.dataSource = self
        recipesCarousel.delegate = self
        
        progressBar.isHidden = false
        view.addSubview(progressBar)
        progressBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        progressBar.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        progressBar.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if InternetMonitor.shared.internetStatus{
            recipesTable.isHidden = false
            recipesCarousel.isHidden = false
            loginButton.isHidden = false
            networkMessage.isHidden = true
            buttonReload.isHidden = true
            if Auth.auth().currentUser?.uid != nil {
                loginButton.isHidden = true
            } else {
                loginButton.isHidden = false
            }
            
            recipeService.getRecipes(){ recipes in
                self.recipeList = recipes
                DispatchQueue.main.async {
                    self.recipesTable.reloadData()
                    self.recipesCarousel.reloadData()
                    self.progressBar.isHidden = true
                }
            }
        } else {
            progressBar.isHidden = true
            buttonReload.isHidden = false
            networkMessage.isHidden = false
            recipesTable.isHidden = true
            recipesCarousel.isHidden = true
            loginButton.isHidden = true
            
            view.addSubview(networkMessage)
            networkMessage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            networkMessage.topAnchor.constraint(equalTo: view.topAnchor, constant: 300).isActive = true
            
            view.addSubview(buttonReload)
            buttonReload.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            buttonReload.topAnchor.constraint(equalTo: networkMessage.bottomAnchor, constant: 130).isActive = true
            buttonReload.addTarget(self, action: #selector(reload), for: .touchUpInside)
        }
    }
    
    @objc func reload() {
        viewDidAppear(true)
    }
    
    
    @objc func imageTapped(sender: UITapGestureRecognizer){
        if sender.state == .ended{
            performSegue(withIdentifier: "recipeDetail", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row > recipeList.count {
            return UITableViewCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as! RecipeCell
            
            cell.recipeImage.sd_setImage(with: URL(string: recipeList[indexPath.row].img ?? ""))
            cell.recipeTitle.text = recipeList[indexPath.row].title
            cell.layer.cornerRadius = 30.0
            cell.delegate = self
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "recipeDetail", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "recipeDetail" {
            let destination = segue.destination as! RecipeDetailViewController
            let indexPath = recipesTable.indexPathForSelectedRow
            let row = indexPath?.row
            destination.id = recipeList[row!].recipe_id
            
        } else if segue.identifier == "signIn" {
            
        } else {
            let destination = segue.destination as! RecipeDetailViewController
            destination.id = recipeService.getRecipe(at:carouselIndex)?.recipe_id
        }
    }
    
    func button(button: UIButton, touchedIn cell: RecipeCell) {
        if Auth.auth().currentUser?.uid != nil {
            if let indexPath = recipesTable.indexPath(for: cell) {
                if button.tag == 0 {
                    let favouriteManager = FavouriteEntityManager(context: context)
                    if favouriteManager.getFavourite(id: recipeList[indexPath.row].recipe_id) == nil {
                        recipeService.getRecipeDetail(id: recipeList[indexPath.row].recipe_id) { detail in
                            let favourite = FavouriteRecipe(context: self.context)
                            favourite.favouriteRecipeID = self.recipeList[indexPath.row].recipe_id
                            favourite.userId = Auth.auth().currentUser?.uid ?? ""
                            favourite.favouriteRecipeTitle = detail.title
                            favourite.favouriteRecipeIngredients = detail.ingredients
                            favourite.favouriteRecipeProcess = detail.process
                            
                            favouriteManager.createFavoutite(recipe: favourite)
                        }
                        let alert = UIAlertController(title: "Receta favorita", message: "Agregaste esta receta!", preferredStyle: .alert)
                        let action = UIAlertAction(title: "Aceptar", style: .default)
                        alert.addAction(action)
                        present(alert, animated: true)
                    } else {
                        if let deleteFavourite = favouriteManager.getFavourite(id: recipeList[indexPath.row].recipe_id) {
                            favouriteManager.deleteFavourite(favourite: deleteFavourite)
                            let alert = UIAlertController(title: "Receta favorita eliminada", message: "Eliminaste esta receta de tus favoritas", preferredStyle: .alert)
                            let action = UIAlertAction(title: "Aceptar", style: .default)
                            alert.addAction(action)
                            present(alert, animated: true)
                        } else {
                            print("no se pudo eliminar de favoritos")
                        }
                    }
                }
                if button.tag == 1 {
                    let window = UIAlertController(title: "Comentario", message: "Deja un comentario para esta receta", preferredStyle: .alert)
                    window.addTextField()
                    let action = UIAlertAction(title: "Comentar", style: .default) { result in
                        // se recupera el comentario y se manda al servidor
                    }
                    let cancel = UIAlertAction(title: "Cancelar", style: .cancel)
                    window.addAction(action)
                    window.addAction(cancel)
                    present(window, animated: true)
                }
                if button.tag == 2 {
                    UIPasteboard.general.string = Constants.baseUrl + "recipe/" + recipeList[indexPath.row].recipe_id
                    let alert = UIAlertController(title: "Link", message: "Link a la receta copiado", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Aceptar", style: .default)
                    alert.addAction(action)
                    present(alert, animated: true)
                }
            }
        } else {
            let alert = UIAlertController(title: "Se requiere iniciar sesión", message: "Para hacer uso de esta característica se debe iniciar sesión", preferredStyle: .alert)
            let action = UIAlertAction(title: "Aceptar", style: .default)
            alert.addAction(action)
            present(alert, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipeService.countRecipes()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(indexPath.row > recipeService.countRecipes()){
            return UICollectionViewCell()
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "carouselCell", for: indexPath) as! RecipeCarouselCell
            
            cell.recipeImage.sd_setImage(with: URL(string: recipeService.getRecipe(at: indexPath.row)?.img ?? ""))
            cell.layer.cornerRadius = 40.0
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        carouselIndex = indexPath.item
        performSegue(withIdentifier: "carouselSegue", sender: self)
    }
}

