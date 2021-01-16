//
//  PhotoViewController.swift
//  Virtual_Tourist_Rema
//
//  Created by Rema alsuwailm on 27/05/1442 AH.
//

import UIKit
import CoreData

class PhotoViewController: UIViewController {
    
    @IBOutlet weak var acitivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var colloctionView: UICollectionView!
    @IBOutlet weak var newColloction: UIButton!
    
    var fetchResultController: NSFetchedResultsController<Photo>!
    var pin: Pin!
    var dataController: DataController!
    var photos: [Photo]?
    var photosURL: [URL]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        acitivityIndicator.isHidden = true
        colloctionView.reloadData()
        fetchData()
        setPhotos()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        fetchResultController = nil
    }
    
    func fetchData(){
        let fetchRequst: NSFetchRequest<Photo> = Photo.fetchRequest()
        let sortDescriptors = NSSortDescriptor(key: "creationData", ascending: false)
        let predicate = NSPredicate(format: "pin == %@", pin)
        fetchRequst.sortDescriptors = [sortDescriptors]
        fetchRequst.predicate = predicate
        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequst, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil , cacheName: nil)
        fetchResultController.delegate = self as? NSFetchedResultsControllerDelegate
        do{
            try fetchResultController.performFetch()
        }catch{
            fatalError(error.localizedDescription)
        }
    }
    
    func setPhotos() -> Void {
        self.photos = fetchResultController.fetchedObjects
        if photos!.isEmpty {
            loctionPhotoReq()
            self.colloctionView.reloadData()
        }else{
            self.colloctionView.reloadData()
        }
    }
    
    func loctionPhotoReq(){
        Client.getPhotosByLocationRequst(long: pin.longitude, lat: pin.latitude, completion: completionHandeler)
    }
    
    func completionHandeler(success: Bool, response: [URL], error: Error?){
        if success {
            self.colloctionView.reloadData()
            saveNewPhoto(urls: response)
            self.colloctionView.reloadData()
        } else {
            showAlert(massage: error?.localizedDescription ?? "")
        }
    }
    
    
    func showAlert(massage: String){
        let alert = UIAlertController(title: "Error", message: massage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alert,sender: nil)
    }
    
    func saveNewPhoto(urls: [URL])->Void{
        self.photosURL = urls
//        colloctionView.reloadData()
        for url in urls {
            let data = try? Data(contentsOf: url)
            let photo = Photo(context: dataController.viewContext)
            photo.creationData = Date()
            photo.data = data
            photo.url = "\(url)"
            photo.pin = pin
            if photos != nil {
                photos?.append(photo)
            } else {
                photos = [photo]
            }
        }
        try? dataController.viewContext.save()
        colloctionView.reloadData()
    }
    
    
    
    func saveNewPhotoSingle(url: URL)->Photo{
        
            let data = try? Data(contentsOf: url)
            let photo = Photo(context: dataController.viewContext)
            photo.creationData = Date()
            photo.data = data
            photo.url = "\(url)"
            photo.pin = pin
            if photos != nil {
                photos?.append(photo)
            } else {
                photos = [photo]
            }

        try? dataController.viewContext.save()
        colloctionView.reloadData()

        return photo
    }
    
    
    @IBAction func loadNewCollection(_ sender: Any) {
        deletLocationPhotos()
    }
    
    func deletPhoto(index: IndexPath) -> Void {
        let photo = photos![index.row]
        photos?.remove(at: index.row)
        colloctionView.reloadData()
        dataController.viewContext.delete(photo)
        try? dataController.viewContext.save()
    }
    
    func deletLocationPhotos() -> Void {
        if let photos = photos {
            self.photos = nil
            colloctionView.reloadData()
            for photo in photos {
                dataController.viewContext.delete(photo)
            }
        }
        try? dataController.viewContext.save()
        loctionPhotoReq()
    }
    
}

extension PhotoViewController: UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        cell.load.isHidden = false
        cell.load.startAnimating()
        
        
        if let photos = self.photos {
            let photo = photos[(indexPath as NSIndexPath
            ).row]
            cell.setImage(photo: photo)
        }
//        if let r = self.photosURL?[indexPath.row] {
//            cell.photoCell.image = UIImage(data: try! Data(contentsOf: r))
//            saveNewPhotoSingle(url: r)
////            let d = saveNewPhotoSingle(url: r)
////            cell.setImage(photo:d)
//        }
        
//        cell.load.isHidden = true
//        cell.load.stopAnimating()
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        deletPhoto(index: indexPath)
    }
    
}
