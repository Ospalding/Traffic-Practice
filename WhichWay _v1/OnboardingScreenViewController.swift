//
//  OnboardingScreenViewController.swift
//  WhichWay _v1
//
//  Created by Oliver Spalding on 12/27/18.
//  Copyright © 2018 Oliver Spalding. All rights reserved.
//

import UIKit

class OnboardingScreenViewController: UIViewController, UITextFieldDelegate {

    //Declare Text Fields
    @IBOutlet weak var TextField3: UITextField!
    
    @IBOutlet weak var TextField4: UITextField!
    
    //Declare Time Variables
    @IBOutlet weak var DepartureTimePicker: UIDatePicker!
    
    @IBOutlet weak var AfternoonDepartureTimePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextFields()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Configure Text Fields to show "Done" etc.
    private func configureTextFields() {
        TextField3.delegate = self
        TextField4.delegate = self
        
    }
    
    // called when 'return' key pressed. return NO to ignore.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        TextField3.resignFirstResponder()
        TextField4.resignFirstResponder()
        return true
    }

    
    @IBAction func continueTouched(_ sender: UIButton) {
        
        if TextField3.text != "Placeholder" && TextField4.text != "Placeholder" {
            
            UserDefaults.standard.set(TextField3.text, forKey: "Home")
            UserDefaults.standard.set(TextField4.text, forKey: "Work")

        }
        
            UserDefaults.standard.set(DepartureTimePicker.date, forKey: "DepartureTime")
            UserDefaults.standard.set(AfternoonDepartureTimePicker.date, forKey: "AfternoonTime")
        
            performSegue(withIdentifier: "toMainSegue", sender: self)
        
    }
    
    
    

  



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
