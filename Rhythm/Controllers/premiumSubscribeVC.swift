//
//  premiumSubscribeVC.swift
//  Rhythm
//
//  Created by Vrushank on 2022-07-22.
//

import UIKit

class premiumSubscribeVC: UIViewController {

    var i = "year"
    @IBOutlet weak var yearSubBtn: UIButton!

    @IBOutlet weak var monthSub: UIButton!
    @IBOutlet weak var yearSub: UIButton!
    @IBOutlet weak var monthlySubBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        yearSubBtn.layer.borderWidth = 1
        yearSubBtn.layer.cornerRadius = 8
        // Do any additional setup after loading the view.
    }
    
    @IBAction func yearlySubscriptionSelection(_ sender: Any) {
        
            yearSubBtn.layer.borderWidth = 1
            yearSubBtn.layer.cornerRadius = 8
      
            monthlySubBtn.layer.borderWidth = 0
        
    }
    
    @IBAction func monthlySubscriptionSelection(_ sender: Any) {
       
        monthlySubBtn.layer.borderWidth = 1
        monthlySubBtn.layer.cornerRadius = 8
      
            
            yearSubBtn.layer.borderWidth = 0
        
    }
    
    @IBAction func yearlyPayClicked(_ sender: Any) {
        i = "year"
    }
    @IBAction func monthlyPayClicked(_ sender: Any) {
        i = "month"
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
