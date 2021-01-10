//
//  MapViewController.swift
//  Virtual_Tourist_Rema
//
//  Created by Rema alsuwailm on 26/05/1442 AH.
//

import UIKit
import MapKit



class MapViewController: UIViewController {

    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Client.getPhotosByLocationRequst(long: 46.738586, lat: 24.774265) { (ids, arr, error) in
            print("hi there\(ids) and \(arr.count)")
        }
        // Do any additional setup after loading the view.
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
