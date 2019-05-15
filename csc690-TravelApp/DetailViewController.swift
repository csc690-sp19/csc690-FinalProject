//
//  DetailViewController.swift
//  csc690-TravelApp
//
//  Created by SiuChun Kung on 5/2/19.
//  Copyright © 2019 SiuChun Kung. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage



class DetailViewController: UIViewController {

    @IBOutlet weak var spotImage: UIImageView!
    @IBOutlet weak var spotName: UILabel!
    @IBOutlet weak var spotAddress: UILabel!
    @IBOutlet weak var spotTips: UILabel!
    
    @IBOutlet weak var type: UILabel!
    var spot: Spot?
    var todoList = Todo()
    var service: WeatherService = WeatherService()
    var alertController = UIAlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = spot?.spotName
        spotName.text = spot?.spotName
        spotAddress.text = spot?.spotAddress
        type.text = spot?.description
        // Do any additional setup after loading the view.
        
        fetch()
        }
    
    func fetch() {
        // get current date
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyymmdd"
        let currentDate = formatter.string(from: date)
        
        if let id = spot?.id {
            let photoURL = URL(string: "https://api.foursquare.com/v2/venues/\(id)/photos?&client_id=\(FourSquareAPI.client_id)&client_secret=\(FourSquareAPI.client_secret)&v=\(currentDate)")!
            
            Alamofire.request(photoURL).responseJSON { (response) in
                if
                    let dataDictionary = response.result.value as? [String: Any],
                    let response = dataDictionary["response"] as? [String: Any],
                    let photos = response["photos"] as? [String: Any],
                    let count = photos["count"] as? Int
                {
                    if (count>0) {
                        let items = photos["items"] as? [[String: Any]]
                        let suffix = items![0]["suffix"] as! String
                        
                        let imgAddress = "https://fastly.4sqi.net/img/general/360x240\(suffix)"
                        let imgURL = URL(string: imgAddress)!
                        self.spotImage.af_setImage(withURL: imgURL)
                    } else {
                        let noImgAddress = "https://vignette.wikia.nocookie.net/simpsons/images/6/60/No_Image_Available.png/revision/latest?cb=20170219125728"
                        let noIMGURL = URL(string: noImgAddress)!
                        self.spotImage.af_setImage(withURL: noIMGURL)
                    }
                }
            }
            
            let tipsURL = URL(string: "https://api.foursquare.com/v2/venues/\(id)/tips?&client_id=\(FourSquareAPI.client_id)&client_secret=\(FourSquareAPI.client_secret)&v=\(currentDate)")!
            
            Alamofire.request(tipsURL).responseJSON { (response) in
                if
                    let dataDictionary = response.result.value as? [String: Any],
                    let response = dataDictionary["response"] as? [String: Any],
                    let tips = response["tips"] as? [String: Any],
                    let count = tips["count"] as? Int {
                    if (count>0) {
                        let items = tips["items"] as? [[String: Any]]
                        let text = items![0]["text"] as! String
                        
                        self.spotTips.text = text
                    } else {
                        self.spotTips.text = "No tips guide for this spot yet!"
                    }
                }
            }
            
            
        }
    }
    @IBAction func addTodo(_ sender: Any) {
//        task.insert((spotname: spotName.text!, addr: spotAddress.text!), at: 0)
        task.insert((spotname: spotName.text!, addr: spotAddress.text!, URL: spot!.IconURL), at: 0)
//        let saveData: [[String: Any]] = task.map { ["spotname": $0.spotname, "addr": $0.addr] }
        let saveData: [[String: Any]] = task.map { ["spotname": $0.spotname, "addr": $0.addr, "URL": $0.URL] }
        UserDefaults.standard.set(saveData, forKey: "Todo")
        
        
        let alert = UIAlertController(title: "Travel Bucket", message: "Successfully added!", preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        })
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func getWeather(_ sender: Any) {
        print("clicked")
        guard let lat = spot?.spotLat else { return }
        guard let lng = spot?.spotLng else { return }
        let stringlat = String(format:"%f", lat)
        let stringlng = String(format:"%f", lng)
        
        service.getCity(forLat: stringlat, long: stringlng) { (city) in
             let name = city.name
             let temperature = city.temperature
            
            let alert = UIAlertController(title: "Tempertaure", message: "Today, \(name) is \(temperature) °C", preferredStyle: UIAlertController.Style.alert)
            let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            })
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

