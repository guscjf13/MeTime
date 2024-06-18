//
//  CoreData.swift
//  MeTime
//
//  Created by hyunchul on 2024/01/01.
//

import Foundation
import CoreData
import UIKit

class CoreData {
    
    static let shared = CoreData()
    
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    private lazy var container: NSPersistentContainer? = {
        return appDelegate?.persistentContainer
    }()
    
    func saveFavorite(beverage: Beverage) {
        guard let container else { return }

        guard let entity = NSEntityDescription.entity(forEntityName: "Favorite", in: container.viewContext) else { return }

        let model = NSManagedObject(entity: entity, insertInto: container.viewContext)
        model.setValue(beverage.id ?? 0, forKey: "id")
        model.setValue(beverage.name, forKey: "name")
        model.setValue(beverage.thumbnailImageUrl, forKey: "thumbnailImageUrl")
        model.setValue(beverage.category?.name, forKey: "category")
        model.setValue(beverage.keywords, forKey: "keywords")

        do {
            try container.viewContext.save()
        } catch {
            print("saveTestModel error \(error)")
        }
    }

    func printAllBeverages() {
        do {
            guard let contact = try container?.viewContext.fetch(Favorite.fetchRequest()) as? [Favorite] else { return }
            contact.forEach { model in
                print("bhcbhcbhc \(model.id) \(model.name)")
            }
        } catch {
            print("printAllModel error \(error)")
        }
    }
}

