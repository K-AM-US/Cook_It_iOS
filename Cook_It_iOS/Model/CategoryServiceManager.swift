//
//  CategoryServiceManager.swift
//  Cook_It_iOS
//
//  Created by Mauricio Casillas on 12/11/23.
//

import Foundation

class CategoryServiceManager {
    private var loadedCategories: [CategoryDto] = []
    
    func countCategories() -> Int {
        return loadedCategories.count
    }
    
    func getCategory(at index: Int) -> CategoryDto {
        return loadedCategories[index]
    }
    
    func getCategories(completion: @escaping () -> Void) {
        guard let url = URL(string: Constants.categories) else {
            return
        }
        
        let category = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let data = data  {
                do {
                    let categories = try JSONDecoder().decode([CategoryDto].self, from: data)
                    categories.forEach() { categoryResponse in
                        self.loadedCategories.append(categoryResponse)
                    }
                } catch {
                    print(error)
                }
                completion()
            }
        }
        category.resume()
    }
}
