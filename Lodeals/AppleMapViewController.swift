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

class AppleMapViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchDoneButton: UIButton!
    
    var selectedRestaurant : Restaurant?
    var restaurants : [Restaurant]?
    var searchLocation : CLLocationCoordinate2D?
    var newRestaurantsFromMap : [Restaurant] = []
    
    let currLocationPin = MKPointAnnotation()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // hide keyboard if touch anywhere outside of text field
        self.hideKeyboardWhenTappedAround()
        
        configureLocationManager()
        self.addRestaurantAnnotation(restaurants!)

        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let newRegion = MKCoordinateRegion(center: searchLocation!, span: span)
        mapView.setRegion(newRegion, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//    MARK: -- OTHER UI
    
//    // sets text field's didEndEditing to true and close keyboard
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        self.view.endEditing(true)
//        return false
//    }
    
//    MARK: -- MAPS
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//        mapView.removeAnnotations(mapView.annotations)
//        addRestaurantAnnotation(restaurants!)
    }
    
    func configureLocationManager() {
        CLLocationManager.locationServicesEnabled()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = 1.0
        locationManager.distanceFilter = 100.0
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        mapView.removeAnnotation(currLocationPin)
        let location = locations.last! as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        //set region on the map
        mapView.setRegion(region, animated: true)
        
        currLocationPin.coordinate = location.coordinate
        currLocationPin.title = "Current Location"
        mapView.addAnnotation(currLocationPin)
        
    }
    
    func addRestaurantAnnotation(_ businesses : [Restaurant]) {
        DispatchQueue.main.async {
            self.mapView.addAnnotations(businesses)
        }
    }
    
    func addMoreRestaurants() {
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is Restaurant {
            let disclosureButton = UIButton(type: .detailDisclosure)
            let annotationView = MKPinAnnotationView()
            
            annotationView.rightCalloutAccessoryView = disclosureButton
            annotationView.annotation = annotation
            annotationView.canShowCallout = true
            annotationView.animatesDrop = true
            
            let rest = annotation as! Restaurant
            
            if rest.deals.count > 0 {
                annotationView.pinTintColor = .red
            }
            else {
                annotationView.pinTintColor = .gray
            }
            
            return annotationView
        }
        else if annotation is MKPointAnnotation {
            let annotationView = MKPinAnnotationView()
            
            annotationView.pinTintColor = .blue
            annotationView.annotation = annotation
            annotationView.canShowCallout = true
            annotationView.animatesDrop = false
            
            return annotationView
        }
        
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            print("callout accessory control tapped")
            self.selectedRestaurant = view.annotation as? Restaurant
            performSegue(withIdentifier: "showDetailsVCFromMap", sender: self)
    }
    
    // tells the delegate that the location of the user was updated
    // THIS IS DOING NOTHING FOR ME RN
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        print("did update user location!")
        mapView.setRegion(MKCoordinateRegionMake((mapView.userLocation.location?.coordinate)!, MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
        
        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        
        myAnnotation.coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
        myAnnotation.title = "Current location"
        mapView.addAnnotation(myAnnotation)
    }

//    MARK: -- Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showDetailsVCFromMap") {
            print("prepare for segue -- show details vc from map")
            let destVC = segue.destination as? DetailsViewController
            
            destVC?.restaurant = self.selectedRestaurant
            //NOTE: SET RESTAURANT INDEX TOO!!!
        }
    }

}
