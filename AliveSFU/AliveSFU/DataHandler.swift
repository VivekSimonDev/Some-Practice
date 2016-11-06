//
//  DataHandler.swift
//  AliveSFU
//
//  Created by Gur Kohli on 2016-11-01.
//  Developers: Vivek Sharma
//  Copyright © 2016 SimonDevs. All rights reserved.
//

import Foundation
import CoreData

class DataHandler {
    
    class func getExerciseArrayCount() -> Int{
        let moc = AppDataController().managedObjectContext
        let entityFetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Exercise")
        do {
            let fetchedResults = try moc.fetch(entityFetchReq)
            return fetchedResults.count
        } catch {
            fatalError("Failed to fetch person: \(error)")
        }
    }
    
    class func getExerciseArray() -> [Exercise] {
        var exerciseArr = [Exercise]()
        
        let moc = AppDataController().managedObjectContext
        let entityFetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Exercise")
        do {
            let fetchedResults = try moc.fetch(entityFetchReq) as! [NSManagedObject]
            for result in fetchedResults {
                let name = result.value(forKey: "exerciseName") as! String
                let category = result.value(forKey: "category") as! String
                var elem = Exercise()
                if (category == elem.CATEGORY_STRENGTH) {
                    let sets = result.value(forKey: "sets") as! String
                    let reps = result.value(forKey: "reps") as! String
                    elem = Exercise(name: name, sets: sets, reps: reps)
                } else {
                    let time = result.value(forKey: "time") as! String
                    let resistance = result.value(forKey: "resistance") as! String
                    let speed = result.value(forKey: "speed") as! String
                    elem = Exercise(name: name, time: time, resistance: resistance, speed: speed)
                }
                exerciseArr.append(elem)
            }
            return exerciseArr
        } catch {
            fatalError("Failed to fetch array! Error: \(error)")
        }
        
    }
    
    class func deleteElementFromExerciseArray() -> Int {
        return 0;
    }
    class func deleteExerciseArray() -> Int {
        let moc = AppDataController().managedObjectContext
        let entityFetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Exercise")
        do {
            let fetchedResults = try moc.fetch(entityFetchReq) as! [NSManagedObject]
            for result in fetchedResults {
                moc.delete(result)
            }
            try moc.save()
            
            return 0;
        } catch {
            fatalError("Failed to delete array! Error: \(error)")
        }
    }
    class func saveElementToExerciseArray(elem: Exercise) -> Int {
        
        let moc = AppDataController().managedObjectContext
        //let entity = NSEntityDescription.entity(forEntityName: "Exercise", in: moc)
        let exercise = NSEntityDescription.insertNewObject(forEntityName: "Exercise", into: moc)
        
        exercise.setValue(elem.exerciseName, forKey: "exerciseName")
        exercise.setValue(elem.category, forKey: "category")
        if (elem.category == elem.CATEGORY_STRENGTH) {
            exercise.setValue(elem.sets, forKey: "sets")
            exercise.setValue(elem.reps, forKey: "reps")
            
        } else {
            exercise.setValue(elem.speed, forKey: "speed")
            exercise.setValue(elem.resistance, forKey: "resistance")
            exercise.setValue(elem.time, forKey: "time")
        }
        
        do {
            try moc.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
            return -1
        }
        return 0;
    }
    
    //Returns an array 7 integers long with each index holding that day's amount of completed exercises
    //Main use will be in the graph for my progress
    class func countCompletion() -> [Int]
    {
        var dayArray: [Int] = [0, 0, 0, 0, 0, 0, 0]
        let exerciseArray = DataHandler.getExerciseArray()
        for elem in exerciseArray {
            if (elem.getCompletion() == true && elem.day == 0)
            {dayArray[0] = dayArray[0] + 1}
            else if (elem.getCompletion() == true && elem.day == 1)
            {dayArray[1] = dayArray[1] + 1}
            else if (elem.getCompletion() == true && elem.day == 2)
            {dayArray[2] = dayArray[2] + 1}
            else if (elem.getCompletion() == true && elem.day == 3)
            {dayArray[3] = dayArray[3] + 1}
            else if (elem.getCompletion() == true && elem.day == 4)
            {dayArray[4] = dayArray[4] + 1}
            else if (elem.getCompletion() == true && elem.day == 5)
            {dayArray[5] = dayArray[5] + 1}
            else if (elem.getCompletion() == true && elem.day == 6)
            {dayArray[6] = dayArray[6] + 1}
            
            
            
        }
        return dayArray
    }
}
