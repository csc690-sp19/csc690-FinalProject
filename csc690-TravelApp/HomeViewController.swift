//
//  ViewController.swift
//  csc690-TravelApp
//
//  Created by SiuChun Kung on 5/2/19.
//  Copyright © 2019 SiuChun Kung. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import CoreLocation

class HomeViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    var spots: [Spot] = []
    static var errorMessage = ""
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.rowHeight = 90
        tableview.delegate = self
        tableview.dataSource = self
        self.searchTextField.delegate = self
        // Do any additional setup after loading the view.
        
        navigationItem.title = "TravalGo!"
        
        getCurrentLocation()
        fetchPost()
        
    }
    
    
    
    //function for fetching post
    func fetchPost() {
        FourSquareAPI().getVenue { ( spots: [Spot]?, error: Error?) in
            guard let post = spots else { return }
            self.spots = post
            MapViewController.spots = post
            self.tableview.reloadData()
            self.tableview.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
        }
        
    }
    
    func getCurrentLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        if let locationLag: Double = (locationManager.location?.coordinate.latitude),
            let locationLng: Double = (locationManager.location?.coordinate.longitude) {
            FourSquareAPI.currentLocation = "\(locationLag),\(locationLng)"
        } else {
            FourSquareAPI.currentLocation = "SF"
        }
    }
    
    //function for fetching new post
    func fetchNewPost() {
        FourSquareAPI().getNewVenue { (spots: [Spot]?,error: Error?) in
            guard let post = spots
                else {
                    let alert = UIAlertController(title: "invald input", message: FourSquareAPI.errorMessage, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default,handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                    return
            }
            self.spots = post
            MapViewController.spots = post
            self.tableview.reloadData()
            self.tableview.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
    
    
    //tableView function
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpotCell", for: indexPath) as! SpotCell
        cell.spot = spots[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spots.count
    }
    
    // hidden keyboard when "Search" press
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        
        // replace whitespeace for "%20" for url using.
        FourSquareAPI.currentLocation = textField.text!.replacingOccurrences(of: " ", with: "%20")
        fetchNewPost()
        
        searchTextField.text = ""
        return true
    }
    
    
    // hidden keyboard when user touch outside
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "DetailView") {
            let cell = sender as! UITableViewCell
            if let indexPath = tableview.indexPath(for: cell) {
                let spot = spots[indexPath.row]
                let detailViewController = segue.destination as!  DetailViewController
                detailViewController.spot = spot
            }
        }
    }
    
    @IBAction func searchTapped(_ sender: Any) {
        getCurrentLocation()
        fetchPost()
        
    }
    
    
    
}

