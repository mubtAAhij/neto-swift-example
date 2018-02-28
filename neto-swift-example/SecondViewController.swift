//
//  SecondViewController.swift
//  barcode-scan
//
//  Created by John on 2/15/18.
//  Copyright © 2018 John Thompson. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var skuTextField: UITextField!
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var modelTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SecondViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemSegue" {
            let secondView: ItemViewController = segue.destination as! ItemViewController
            secondView.sku = skuTextField.text
            secondView.productName = productNameTextField.text
            secondView.model = modelTextField.text
        }
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

}

