//
//  ShowViewController.swift
//  ArtBook
//
//  Created by Türker Berk Topçu on 14.01.2023.
//

import UIKit
import CoreData

class ShowViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var artNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    var selectedId : UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(selectedId)
        setData()
    }
    
    func setData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
        let idStringUpdated = self.selectedId!.uuidString
        
        fetchRequest.predicate = NSPredicate(format: "id = %@", idStringUpdated )
        fetchRequest.returnsObjectsAsFaults = false
        
        do{
             let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let artName = result.value(forKey: "artName") as? String
                    {
                        self.artNameLabel.text = artName
                    }
                    if let artistName = result.value(forKey: "artistName") as? String
                    {
                        self.artistNameLabel.text = artistName
                    }
                    if let year = result.value(forKey: "year") as? String
                    {
                        self.yearLabel.text = year
                    }
                    if let image = result.value(forKey: "image") as? Data
                    {
                        self.imageView.image = UIImage(data: image)
                    }
                }
            }
        }catch {
            print("Error !! ")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
