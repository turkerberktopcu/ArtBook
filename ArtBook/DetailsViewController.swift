//
//  DetailsViewController.swift
//  ArtBook
//
//  Created by Türker Berk Topçu on 6.01.2023.
//

import UIKit
import CoreData
import PhotosUI

class DetailsViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
  
    
    var selectedId: UUID?
    var selectedButtonForMap: String?
    public static var coordinateToSave: CLLocationCoordinate2D?
    
    
    @IBOutlet weak var pinButton: UIButton!
    @IBOutlet weak var seeLocationButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var artNameField: UITextField!
    @IBOutlet weak var yearField: UITextField!
    @IBOutlet weak var artistNameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
        imageView.isUserInteractionEnabled = true
        let imageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        imageView.addGestureRecognizer(imageGestureRecognizer)
        
        if let newId = self.selectedId {
            setData()
        }
        else{
            self.seeLocationButton.isHidden = true
        }
    }
    
 
    func setData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
        let uuidString = self.selectedId!.uuidString
      
        fetchRequest.predicate = NSPredicate(format: "id = %@", uuidString)
        fetchRequest.returnsObjectsAsFaults = false
        
        do{
            let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject]{
        
                if let data = result.value(forKey: "image") as? Data {
                    imageView.image = UIImage(data: data)
                }
                artistNameField.text = result.value(forKey: "artistName") as? String
                artNameField.text = result.value(forKey: "artName") as? String
                if let tmpYear = result.value(forKey: "year") as? String{
                    print("Year \(tmpYear)")
                    yearField.text = tmpYear
                }
                
                artistNameField.isUserInteractionEnabled = false
                yearField.isUserInteractionEnabled = false
                artNameField.isUserInteractionEnabled = false
                imageView.isUserInteractionEnabled = false
                
                self.saveButton.isHidden = true
                self.pinButton.isHidden = true
            }
            
        }catch{
            
        }
        
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func selectImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        
        present(picker, animated: true)
        
        print("1.2debug")

        
        
    }
    
    
    
    
    @objc func hideKeyboard(){
        view.endEditing(true)
        
    }
    
   
    
   
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        if imageView.image == UIImage(named: "select"){
            let alertController = UIAlertController(title: "Something is Empty", message: "", preferredStyle: .alert)
            let alertBtn = UIAlertAction(title: "OK", style: .default) {
                UIAlertAction in
                self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(alertBtn)
            present(alertController, animated: true)
        }
        if  artNameField.text == "" {
            let alertController = UIAlertController(title: "Something is Empty", message: "", preferredStyle: .alert)
            let alertBtn = UIAlertAction(title: "OK", style: .default) {
                UIAlertAction in
                self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(alertBtn)
            present(alertController, animated: true)
        }
        if  artistNameField.text == "" {
            let alertController = UIAlertController(title: "Something is Empty", message: "", preferredStyle: .alert)
            let alertBtn = UIAlertAction(title: "OK", style: .default) {
                UIAlertAction in
                self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(alertBtn)
            present(alertController, animated: true)
        }
        if yearField.text == "" {
            let alertController = UIAlertController(title: "Something is Empty", message: "", preferredStyle: .alert)
            let alertBtn = UIAlertAction(title: "OK", style: .default) {
                UIAlertAction in
                self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(alertBtn)
            present(alertController, animated: true)
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newPainting = NSEntityDescription.insertNewObject(forEntityName: "Entity", into: context)
        
        newPainting.setValue(artNameField.text!, forKey: "artName")
        newPainting.setValue(artistNameField.text!, forKey: "artistName")
        
        if let locationToSave = DetailsViewController.coordinateToSave {
            newPainting.setValue(locationToSave.longitude, forKey: "longitude")
            newPainting.setValue(locationToSave.latitude, forKey: "latitude")
        }
        
        if let year = Int(yearField.text!) {
            newPainting.setValue(year, forKey: "year")
        }
        newPainting.setValue(UUID(), forKey: "id")

        let data = imageView.image!.jpegData(compressionQuality: 0.5)
        newPainting.setValue(data, forKey: "image")
        
        do {
            try context.save()
            let alertController = UIAlertController(title: "Saved", message: "", preferredStyle: .alert)
            let alertBtn = UIAlertAction(title: "OK", style: .default) {
                UIAlertAction in
                NotificationCenter.default.post(name: NSNotification.Name("newDataCame"), object: nil)
                self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(alertBtn)
            present(alertController, animated: true)
            
        }
        catch{
            print("Error !!")
        }
    }
    
    @IBAction func seeLocationButton(_ sender: Any) {
        self.selectedButtonForMap = "see"
        performSegue(withIdentifier: "toMapView", sender: nil)
    }
    
    @IBAction func pinButtonClicked(_ sender: Any) {
        self.selectedButtonForMap = "pin"
        performSegue(withIdentifier: "toMapView", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMapView" {
            let destination = segue.destination as! MapViewController
            destination.selectedButton = self.selectedButtonForMap
            destination.selectedId = self.selectedId
        }
    }

}
