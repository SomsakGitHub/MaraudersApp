//
//  UserCoreData.swift
//  Marauders
//
//  Created by somsak on 23/2/2564 BE.
//

import Foundation
import CoreData

class UserCoreData {
    
    let entityName = "User"
    var User: User? = nil
    
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "Marauders")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveUserData(userData: UserModel) {
        
        deleteUserData()
        let managedContext = self.persistentContainer.viewContext
        
        //2
        let entity =  NSEntityDescription.entity(forEntityName: self.entityName, in: managedContext)
        let recent = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        //3
        recent.setValue(userData.accessToken, forKey: "accessToken")
        
        //4
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
//        do {
//            UserCoreData = try managedContext.fetch(User.fetchRequest())
//            for index in UserCoreData{
//                print("UserCoreData.accessToken \(String(describing: index.accessToken))")
//                print("UserCoreData.refreshToken \(String(describing: index.refreshToken))")
//            }
//        } catch let error as NSError  {
//            print("Could not save \(error), \(error.userInfo)")
//        }
    }
    
    func getUserData() -> [User] {
        let managedContext = self.persistentContainer.viewContext
        
        //2
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        
        //3
        do{
            let results:[User] = (try managedContext.fetch(fetchRequest) as! [User])
            return results
        }catch let error as NSError{
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return []
    }
    
    func deleteUserData() {
        let managedContext = self.persistentContainer.viewContext
        
        //2
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        
        //3
        do{
            let results:[NSManagedObject] = (try managedContext.fetch(fetchRequest) as! [NSManagedObject])
            for i in results{
                managedContext.delete(i)
            }
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
        }catch let error as NSError{
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
}
