//
//  AppleMapViewController.swift
//  Lodeals
//
//  Created by Rachel Chang on 6/8/18.
//  Copyright © 2018 Rachel Chang. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class AppleMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    var selectedRestaurant : Restaurant?
    var restaurants : [Restaurant]?
    var searchLocation : CLLocationCoordinate2D?
    
    let locationManager = CLLocationManager()
//    let myAptLocation = CLLocationCoordinate2D(latitude: 35.300499, longitude: -120.677059)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLocationManager()
        self.addRestaurantAnnotation(restaurants!)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        let newRegion = MKCoordinateRegion(center: searchLocation!, span: span)
        mapView.setRegion(newRegion, animated: true)
        //showAnnotations([MKAnnotation], animated: bool)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        mapView.removeAnnotations(mapView.annotations)
        addRestaurantAnnotation(restaurants!)
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        print("did update user location?")
        mapView.setRegion(MKCoordinateRegionMake((mapView.userLocation.location?.coordinate)!, MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)), animated: true)
    }
    
    func configureLocationManager() {
        CLLocationManager.locationServicesEnabled()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = 1.0
        locationManager.distanceFilter = 100.0
        locationManager.startUpdatingLocation()
    }
    
    func addRestaurantAnnotation(_ businesses : [Restaurant]) {
        DispatchQueue.main.async {
            self.mapView.addAnnotations(businesses)
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
        if(segue.identifier == "showDetailsVCFromMap") {
            let destVC = segue.destination as? DetailsViewController
            
            destVC?.restaurant = self.selectedRestaurant
            //NOTE: SET RESTAURANT INDEX TOO!!!
        }
    }

}
