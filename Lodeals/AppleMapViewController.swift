//
//  AppleMapViewController.swift
//  Lodeals
//
//  Created by Rachel Chang on 6/8/18.
//  Copyright © 2018 Rachel Chang. All rights reserved.
//

import UIKit
import MapKit

class AppleMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    var selectedRestaurant : Restaurant?
    
    let locationManager = CLLocationManager()
    let myAptLocation = CLLocationCoordinate2D(latitude: 35.300499, longitude: -120.677059)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLocationManager()
//        refSchools = Database.database().reference().child("Schools")
//        geoFire = GeoFire(firebaseRef: Database.database().reference().child("GeoFire"))
        
        let span = MKCoordinateSpan(latitudeDelta: 0.7, longitudeDelta: 0.7)
        let newRegion = MKCoordinateRegion(center: myAptLocation, span: span)
        mapView.setRegion(newRegion, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        mapView.removeAnnotations(mapView.annotations)
        
        updateRegionQuery()
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        mapView.setRegion(MKCoordinateRegionMake((mapView.userLocation.location?.coordinate)!, MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)), animated: true)
    }
    
    func configureLocationManager() {
        CLLocationManager.locationServicesEnabled()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = 1.0
        locationManager.distanceFilter = 100.0
        locationManager.startUpdatingLocation()
    }
    
    func updateRegionQuery() {
//        if let oldQuery = regionQuery {
//            oldQuery.removeAllObservers()
//        }
//
//        regionQuery = geoFire?.query(with: mapView.region)
//
//        regionQuery?.observe(.keyEntered, with: { (key, location) in
//            self.refSchools?.queryOrderedByKey().queryEqual(toValue: key).observe(.value, with: { snapshot in
//
//                let newSchool = School(key: key, snapshot: snapshot)
//                self.addSchoolAnnotation(newSchool)
//            })
//        })
    }
    
    func addRestaurantAnnotation(_ business : Restaurant) {
        DispatchQueue.main.async {
            self.mapView.addAnnotation(business)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is Restaurant {
            let disclosureButton = UIButton(type: .detailDisclosure)
            let annotationView = MKPinAnnotationView()
            
            annotationView.rightCalloutAccessoryView = disclosureButton
            annotationView.pinTintColor = .red
            annotationView.annotation = annotation
            annotationView.canShowCallout = true
            annotationView.animatesDrop = true
            
            return annotationView
        }
        
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        self.selectedRestaurant = view.annotation as? Restaurant
        performSegue(withIdentifier: "showDetailsVC", sender: self)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showDetailsVC") {
            let destVC = segue.destination as? DetailsViewController
            
            destVC?.restaurant = self.selectedRestaurant
            //NOTE: SET RESTAURANT INDEX TOO!!!
        }
    }

}
