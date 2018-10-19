//
//  AppDelegate.swift
//  RelationsWithFaults
//
//  Created by Piyush Sharma on 19/10/18.
//  Copyright © 2018 Piyush Sharma. All rights reserved.
//

import UIKit
import CoreData


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigationController : UINavigationController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let homeVC : HomeVC = HomeVC()
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        navigationController = UINavigationController(rootViewController: homeVC)
        
        self.window!.rootViewController = navigationController
                
        self.window!.makeKeyAndVisible()
        
        //createOneToOneRelation()
        
        //createOneToManyRelation()
        return true
    }

    // MARK: - CRUD Operations
    
    func createOneToOneRelation()
    {
        let context = persistentContainer.viewContext
        
        let person = Person(context: context)
        person.name = "Piyush"
        person.age = 23
        
        let car = Car(context: context)
        car.brand = "Tata"
        car.model = "Nexon"
        car.year = 2017
        
        person.car = car
        
        saveContext()
    }
    
    func createOneToManyRelation()
    {
        let context = persistentContainer.viewContext
        
        //fetch request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Person")
        fetchRequest.predicate = NSPredicate.init(format: "age = 23")
        
        do {
            let persons = try context.fetch(fetchRequest)
            
            let fetchedPerson : Person = persons.last as! Person
            
            let friend1 = Friends(context: context)
            friend1.name = "Varun"
            friend1.knownSince = 1996
            
            fetchedPerson.addToFriends(friend1)
            
            let friend2 = Friends(context: context)
            friend2.name = "Heena"
            friend2.knownSince = 1999
            
            fetchedPerson.addToFriends(friend2)
            
            do{
                try context.save()
            }
            catch let error as NSError{
                print("Unable to update data due to \(error.userInfo)")
            }
            
        } catch let error as NSError{
            print("Unable to fetch data due to \(error.userInfo)")
        }
        
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "RelationsWithFaults")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

