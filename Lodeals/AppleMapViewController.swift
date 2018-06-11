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

        let newRegion = MKCoordinateRegion(center: searchLocation!, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(newRegion, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//    MARK: -- OTHER UI

    
//    MARK: -- MAPS
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//        mapView.removeAnnotations(mapView.annotations)
//        addRestaurantAnnotation(restaurants!)
    }
    
    // set up for CLLocationManager
    func configureLocationManager() {
        CLLocationManager.locationServicesEnabled()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = 1.0
        locationManager.distanceFilter = 100.0
        locationManager.startUpdatingLocation()
    }
    
    //don't need b/c already using didUpdate userLocation for mapView
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print("location manager didUpdateLocations")
//        let location = locations.last! as CLLocation
//
//        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//
//        mapView.setRegion(region, animated: true)
//    }
    
    // add all annotations in businesses array
    func addRestaurantAnnotation(_ businesses : [Restaurant]) {
        DispatchQueue.main.async {
            self.mapView.addAnnotations(businesses)
        }
    }
    
    func addMoreRestaurants() {
        let radius = mapView.region.distanceMax()
        
        
    }
    
    // set up details for each annotation
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
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let newRegion = MKCoordinateRegion(center: self.mapView.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(newRegion, animated: true)
//        mapView.setRegion(MKCoordinateRegionMake((mapView.userLocation.location?.coordinate)!, MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
    }

//    MARK: -- Navigation

    @IBAction func unwindFromDetailsVC(sender: UIStoryboardSegue) {
        if sender.source is DetailsViewController {
            if let senderVC = sender.source as? DetailsViewController {
                let editedRestaurant = senderVC.restaurant

                print("unwind from details vc to apple map vc:")
                print("BEFORE SET AND SORT")
                for restaurant in restaurants! {
                    print("\t\(restaurant.name) with \(restaurant.deals.count) deals")
                }
                
                if let restIndex = restaurants?.index(of: self.selectedRestaurant!) {
                    print("\nrestIndex is \(String(describing: restIndex))")
                    print("before reset: \(restaurants![restIndex].name)")
                    restaurants![restIndex] = editedRestaurant!
                    print("before reset: \(restaurants![restIndex].name)")
                    self.mapView.removeAnnotation(self.selectedRestaurant!)
                    self.mapView.addAnnotation(self.selectedRestaurant!)
                }
                
                restaurants?.sort(by: {$0.deals.count > $1.deals.count})
                
                print("\nAFTER SET AND SORT")
                for restaurant in restaurants! {
                    print("\t\(restaurant.name) with \(restaurant.deals.count) deals")
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showDetailsVCFromMap") {
            print("prepare for segue -- show details vc from map")
            let destVC = segue.destination as? DetailsViewController
            
            destVC?.restaurant = self.selectedRestaurant
            destVC?.senderAlias = "map"
        }
    }

}
