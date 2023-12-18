//
//  RecipeCell.swift
//  Cook_It_iOS
//
//  Created by Mauricio Casillas on 30/10/23.
//

import UIKit

protocol RecipeCellDelegate {
    func button(button: UIButton, touchedIn cell: RecipeCell)
}

class RecipeCell: UITableViewCell {
    
    var delegate: RecipeCellDelegate?
    
    @IBOutlet var recipeImage: UIImageView!
    @IBOutlet var recipeTitle: UILabel!
    @IBOutlet var recipeFavouriteButton: UIButton!
    @IBOutlet var recipeCommentButton: UIButton!
    @IBOutlet var recipeShareButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func buttonTouch(_ button: UIButton) {
        if delegate != nil {
            delegate!.button(button: button, touchedIn: self)
        }
    }
    

}
