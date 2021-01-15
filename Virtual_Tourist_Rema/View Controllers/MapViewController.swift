//
//  MapViewController.swift
//  Virtual_Tourist_Rema
//
//  Created by Rema alsuwailm on 26/05/1442 AH.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController {
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var editItemBar: UIBarButtonItem!
    
    var fetchedResult: NSFetchedResultsController<Pin>!
    var dataController: DataController!
    var pins: [Pin] = []
    var isEdite: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setEditeItemBar()
        setGestureRecognizer()
        fetchedResults()
        addAnnotation()
        //        Client.getPhotosByLocationRequst(long: 46.738586, lat: 24.774265) { (ids, arr, error) in
        //            print("hi there\(ids) and \(arr.count)")
        //        }
        // Do any additional setup after loading the view.
    }
    
    func setEditeItemBar(){
        self.editItemBar.title = "Edit"
    }
    
    
    
    fileprivate func fetchedResults(){
        let fetchedResultPin: NSFetchRequest<Pin> = Pin.fetchRequest()
        let sort = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchedResultPin.sortDescriptors = [sort]
        
        fetchedResult = NSFetchedResultsController(fetchRequest: fetchedResultPin , managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "pins")
        fetchedResult.delegate = self as? NSFetchedResultsControllerDelegate
        do {
            try fetchedResult.performFetch()
        }catch{
            fatalError("\(error.localizedDescription)")
        }
    }
    
    fileprivate func addAnnotation() {
        if let pins = fetchedResult.fetchedObjects{
            var anns = [MKPointAnnotation]()
            for pin in pins {
                let lat = CLLocationDegrees(pin.latitude)
                let lon = CLLocationDegrees(pin.longitude)
                let coordinate = CLLocationCoordinate2DMake(lat, lon)
                let ann = MKPointAnnotation()
                ann.coordinate = coordinate
                anns.append(ann)
            }
            self.mapView.addAnnotations(anns)
            self.pins = pins
        }
    }
    
    func addNewPin(lat: Double , lon: Double){
        let pin = Pin(context: dataController.viewContext)
        pin.creationDate = Date()
        pin.longitude = lon
        pin.latitude = lat
        try? dataController.viewContext.save()
        self.pins.append(pin)
    }
    
    func deletePin(pin: Pin) -> Void {
        dataController.viewContext.delete(pin)
        try? dataController.viewContext.save()
        pins.removeAll(){ $0 == pin }
    }
    
    @IBAction func editAction(_ sender: Any) {
        isEditing.toggle()
        self.editItemBar.title = isEditing ? "Done" : "Edit"
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

extension MapViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin" ) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin" )
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation!, animated: true)
        let pin = view.annotation
        let newPin = self.pins.filter {
            $0.longitude == pin?.coordinate.longitude && $0.latitude == pin?.coordinate.latitude
        }
        
        if isEditing{
            mapView.removeAnnotation(view.annotation!)
            deletePin(pin: newPin.first!)
        }else{
            let locationPhoto = storyboard?.instantiateViewController(identifier: "PhotoViewController") as! PhotoViewController
            locationPhoto.pin = newPin.first
            locationPhoto.dataController = dataController
            present(locationPhoto, animated: true, completion: nil)
        }
    }
}

extension MapViewController : UIGestureRecognizerDelegate{
    
    func setGestureRecognizer(){
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(sender:)))
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func longPressed(sender: UILongPressGestureRecognizer){
        if sender.state != .began {
            return
        }
        let touchPoint = sender.location(in: mapView)
        let coordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        mapView.addAnnotation(annotation)
        addNewPin(lat: coordinates.latitude, lon: coordinates.longitude)
    }
    
    func handleTap(get: UILongPressGestureRecognizer){
        //
    }
}
