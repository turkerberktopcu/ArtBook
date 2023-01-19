//
//  MapViewController.swift
//  ArtBook
//
//  Created by Türker Berk Topçu on 17.01.2023.
//

import UIKit
import MapKit
import CoreLocation
import CoreData


class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var saveButton: UIButton!
    
    var selectedButton: String?
    var selectedId: UUID?
    var selectedLatitude: Double?
    var selectedLongitude: Double?
    var locationManager = CLLocationManager()
    var touchedCoordinate: CLLocationCoordinate2D?
    var annotationTitle: String?
    var annotationSubtitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
      
        if selectedButton == "see" {
            setData()
        }
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.distanceFilter = 100
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
      
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(createAnnotation))
        longPressRecognizer.minimumPressDuration = 1.5
        mapView.addGestureRecognizer(longPressRecognizer)
    }
    
 
    
    @objc func createAnnotation(gestureRecognizer: UILongPressGestureRecognizer){
        let touchedPoint = gestureRecognizer.location(in: self.mapView)
        let touchedCoordinate = self.mapView.convert(touchedPoint, toCoordinateFrom: self.mapView)
        self.touchedCoordinate = touchedCoordinate
        let annotation = MKPointAnnotation()
        annotation.coordinate = touchedCoordinate
        annotation.title = self.annotationTitle
        annotation.subtitle = self.annotationSubtitle
        
        self.mapView.addAnnotation(annotation)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if selectedButton == "see" {
                let location = CLLocationCoordinate2D(latitude: self.selectedLatitude!, longitude: self.selectedLongitude!)
                let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                let region = MKCoordinateRegion(center: location, span: span)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = location
                annotation.title = self.annotationTitle
                annotation.subtitle = self.annotationSubtitle
                
                self.mapView.addAnnotation(annotation)
                self.mapView.setRegion(region, animated: true)
                
                
            }
        else{
            let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            let region = MKCoordinateRegion(center: location, span: span)
            
            self.mapView.setRegion(region, animated: true)
            self.locationManager.stopUpdatingLocation()

            
        }
        
        
    }
    
    func setData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let idString = self.selectedId!.uuidString
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
        fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
        fetchRequest.returnsObjectsAsFaults = false
        
        do{
            let results = try context.fetch(fetchRequest)
            
            for result in results as! [NSManagedObject] {
                if let latitude = result.value(forKey: "latitude") as? Double {
                    self.selectedLatitude = latitude
                }
                else{
                    
                }
                if let longitude = result.value(forKey: "longitude") as? Double {
                    self.selectedLongitude = longitude
                }
                else{
                    
                }
                if let title = result.value(forKey: "artName") as? String{
                    self.annotationTitle = title
                }
                if let subtitle = result.value(forKey: "artistName") as? String {
                    self.annotationSubtitle = subtitle
                }
                
            }
            
        }catch{
            
        }
        
        
        self.saveButton.isHidden = true
    }

    @IBAction func saveButtonClicked(_ sender: Any) {
        if let touchedCoordinate = self.touchedCoordinate {
            let alert = UIAlertController(title: "Saved", message: "Location is saved", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { UIAlertAction in
                DetailsViewController.coordinateToSave = touchedCoordinate
                _ = self.navigationController?.popViewController(animated: true)
            })
            
            present(alert, animated: true)
        }
        else {
            let alert = UIAlertController(title: "Error", message: "Location is not saved", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { UIAlertAction in
                _ = self.navigationController?.popViewController(animated: true)
            })
            
            present(alert, animated: true)
        
        }
        
       
        
        
    }
    
    

    }
    
    
    
    
    
    
    
    
    


extension MapViewController: CLLocationManagerDelegate{}

extension MapViewController: MKMapViewDelegate{
        


    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "custom"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView

        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
             } else {
            annotationView!.annotation = annotation
        }
        annotationView?.canShowCallout = true
        annotationView?.tintColor = .red
        annotationView?.glyphImage = UIImage(named: "pin-icon")
        annotationView?.rightCalloutAccessoryView = UIButton(type: UIButton.ButtonType.detailDisclosure)
        annotationView?.rightCalloutAccessoryView?.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
   
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
                if self.selectedButton == "see" {
            let location = CLLocation(latitude: self.selectedLatitude!, longitude: self.selectedLongitude!)
            CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                if let placemark = placemarks{
                    if placemark.count > 0 {
                        let newPlaceMark = MKPlacemark(placemark: placemark[0])
                        let item = MKMapItem(placemark: newPlaceMark)
                        item.name = self.annotationTitle
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
                        item.openInMaps(launchOptions: launchOptions)
                    }
                }
            }
        }
    }
        
       

}
