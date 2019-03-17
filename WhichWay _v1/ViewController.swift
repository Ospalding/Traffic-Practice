//
//  ViewController.swift
//  WhichWay _v1
//
//  Created by Oliver Spalding on 11/2/18.
//  Copyright © 2018 Oliver Spalding. All rights reserved.
//

import UIKit


struct Directions: Decodable {
    let status: String
    let routes: [Route]
}

struct Route: Decodable {
    let summary: String
    let legs: [Leg]
}

struct Leg: Decodable {
    let duration : TextValue
    let distance : TextValue
    let endAddress : String
    let endLocation : Location
    let startAddress : String
    let startLocation : Location
    let steps : [Step]
}

struct TextValue: Decodable {
    let text: String
    let value : Int
}

struct Location: Decodable {
    let lat, lng : Double
}

struct Step: Decodable {
    let duration : TextValue
    let distance : TextValue
    let endLocation : Location
    let startLocation : Location
    let htmlInstructions : String
    let travelMode : String
}

            
class ViewController: UIViewController {

    var orgin: String = ""
    var destination: String = ""
    var direct: String = "Fancyman"
    var stringoutput: String = ""
    var a: String = ""
    var b: String = ""
    var x: String = "Boston,MA"
    var y: String = "Salem,MA"
    var DirectOneText: String = ""
    var DirectOneTime: String = ""
    var DirectTwoText: String = ""
    var DirectTwoTime: String = ""

    
    // declare orgin and destination labels
    
    @IBOutlet weak var OrginLabel: UILabel!
    
    @IBOutlet weak var DestinationLabel: UILabel!
    
    
    //declare Result Label
    @IBOutlet weak var ResultLabel: UILabel!
    
    
    //create button
    @IBAction func RouteButton(_ sender: UIButton) {
    
        //get input from text field
        orgin = OrginLabel.text!.replacingOccurrences(of: " ", with: "")
        destination = DestinationLabel.text!.replacingOccurrences(of: " ", with: "")

        
         (DirectOneText, DirectOneTime, DirectTwoText, DirectTwoTime) = RunAPI(orgin: orgin, destination: destination)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Change `2.0` to the desired number of seconds.
            // Code you want to be delayed
        
            if self.DirectOneText == "1" {
                self.ResultLabel.text = ("Route not found")
        } else {
                self.ResultLabel.text = (self.DirectOneText + "  " + self.DirectOneTime + " or " + self.DirectTwoText + " " + self.DirectTwoTime)
        }
        }
        
    }
    
    //Pull the API data and send to ResultLabel
    func RunAPI(orgin: String, destination: String) -> (String, String, String, String) {
        
        //Set API link
        let JSONURLLink = "https://maps.googleapis.com/maps/api/directions/json?origin=" + orgin + "&destination=" + destination + "&departure_time=now&alternatives=true&key=AIzaSyAxOKJ9EeQOf6VvzkEjoOMDJBxQ2yU7ZeY"
        
          guard let url = URL(string: JSONURLLink) else {return ("","", "", "")}
        
          URLSession.shared.dataTask(with: url) { (data, response, err) in
                
              guard let data = data else { return }
                
            do {
                
                let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                
                 let directions = try
                      decoder.decode(Directions.self, from: data)

                
//Error protect if no result
                if directions.routes.count == 0 {
                    self.DirectOneText = "1"
                    self.DirectOneTime = ""
                    self.DirectTwoText = ""
                    self.DirectTwoTime = ""
                }
                else {
                
//Get First Direction
                if directions.routes.count-1 >= 0 {
                    let directOne = directions.routes[0]
                    self.DirectOneText = directOne.summary
                    for item in directOne.legs {
                        self.DirectOneTime = item.duration.text
                    }
                } else {
                    self.DirectOneText = ""
                    self.DirectOneTime = ""
                }
                
                
        // Get Second Direction
                if directions.routes.count-1 >= 1 {
                    let directTwo = directions.routes[1]
                    self.DirectTwoText = directTwo.summary
                    for itemtwo in directTwo.legs {
                        self.DirectTwoTime = itemtwo.duration.text
                    }
                }
                 else {
                    self.DirectTwoText = ""
                    self.DirectTwoTime = ""
            }
                }
                
                
               
        // Old Methodology
//                for item in directions.routes {
                  //  print(item.summary)
  //                  self.direct = item.summary
    //                for items in item.legs {
      //                  self.stringoutput = items.duration.text
                  //      print(items.duration.text)
        //                }
                    
          //      }
                
                
            } catch let jsonErr {
                print("error", jsonErr)
                
            }
           
            }
            
            .resume()
        
        
        return (DirectOneText, DirectOneTime, DirectTwoText, DirectTwoTime)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        let orginText: String = UserDefaults.standard.value(forKey: "Home") as! String
        let destinationText: String = UserDefaults.standard.value(forKey: "Work") as! String
        OrginLabel.text = orginText
        DestinationLabel.text = destinationText

    
    }

    
    
    
    override func didReceiveMemoryWarning() {
        didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }


}
