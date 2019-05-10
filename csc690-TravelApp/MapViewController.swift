//
//  MapViewController.swift
//  csc690-TravelApp
//
//  Created by SiuChun Kung on 5/2/19.
//  Copyright © 2019 SiuChun Kung. All rights reserved.
//

import UIKit
import MapKit
import Contacts

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    static var spots: [Spot] = []
    
    var annotations = [MKPointAnnotation()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        self.mapView.showsUserLocation = true
        getCurrentLocation()
        addSpotOnMap()

        // Do any additional setup after loading the view.
    }
    
    // Annotation right callout accessory opens this mapItem in Maps app
    func mapItem(address: String, location: CLLocationCoordinate2D) -> MKMapItem {
        let add = address
        let locat = location
        let addressDict = [CNPostalAddressStreetKey: add]
        let placemark = MKPlacemark(coordinate: locat, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        return mapItem
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        guard let location = view.annotation?.coordinate else { return }
        guard let address = view.annotation?.subtitle else { return }
        let mapitem = mapItem(address: (address)!, location: location)
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        mapitem.openInMaps(launchOptions: launchOptions)
        
    }
    
    func getCurrentLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func addSpotOnMap() {
        let annotationRegion = MKPointAnnotation()
        
        // adding each spot into mapView
        for spot in MapViewController.spots {
            let address = spot.spotAddress
            let lat = spot.spotLat
            let lng = spot.spotLng
            let spotName = spot.spotName
            let spotCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, lng)
            
            //adding each spot into MAP
            let annotation = MKPointAnnotation()
            annotation.coordinate = spotCoordinate
            annotation.title = spotName
            annotation.subtitle = address
            annotations.append(annotation)
            // update last annotation coordinate
            annotationRegion.coordinate = spotCoordinate
        }
        mapView.addAnnotations(annotations)
        
        // update Region
        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let newLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(annotationRegion.coordinate.latitude, annotationRegion.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegion(center: newLocation, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    //Wire a button to the pin callout
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.isEnabled = true
        pinView?.pinTintColor = UIColor.red
        pinView?.canShowCallout = true
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: .zero, size: smallSquare))
        button.setBackgroundImage(UIImage(named: "car"), for: .normal)
        pinView?.leftCalloutAccessoryView = button
        return pinView
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func refresh(_ sender: Any) {
        // remove all map annotations & clear annotaions list
        mapView.removeAnnotations(annotations)
        annotations.removeAll()
        
        // add new annotations from list
        addSpotOnMap()
    }
    
}


