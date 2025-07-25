//
//  ItemViewController.swift
//  barcode-scan
//
//  Created by John on 2/18/18.
//  Copyright © 2018 John Thompson. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    let cellReuseIdentifier = "cell"
    
    var sku: String!
    var productName: String!
    var model: String!
    
    var itemData: [String: Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.querySKU()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func querySKU() {
        let url = URL(string: "YOUR_NETO_URL")!
        var bodyContent: [String: Any] = ["Filter":
            ["OutputSelector":
                ["ID", "ImageURL", "Model", "WarehouseQuantity", "RRP", "ProductURL", "UnitOfMeasure", "CommittedQuantity", "AvailableSellQuantity", "CostPrice", "IsActive", "PromotionPrice", "Subtitle"]
            ]
        ]
        if (self.sku != nil && self.sku.count > 0) {
            if var filterContent = bodyContent["Filter"] as? [String: Any] {
                filterContent["SKU"] = self.sku
                bodyContent["Filter"] = filterContent
            }
        } else if (self.productName != nil && self.productName.count > 0) {
            if var filterContent = bodyContent["Filter"] as? [String: Any] {
                filterContent["Name"] = self.productName
                bodyContent["Filter"] = filterContent
            }
        } else if (self.model != nil && self.model.count > 0) {
            if var filterContent = bodyContent["Filter"] as? [String: Any] {
                filterContent["Model"] = self.model
                bodyContent["Filter"] = filterContent
            }
        } else {
            self.navigationItem.title = String(localized: "no_data_inputted", comment: "Error message when no search criteria provided")
            return
        }
        let jsonData = try? JSONSerialization.data(withJSONObject: bodyContent)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = [
            "NETOAPI_ACTION": "GetItem",
            "NETOAPI_USERNAME": "YOUR_NETO_USERNAME",
            "NETOAPI_KEY": "YOUR_NETO_APIKEY",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                guard let itemData = responseJSON["Item"] as? [Any] else { return }
                if (itemData.count > 0) {
                    guard let item0Data = itemData[0] as? [String: Any] else { return }
                    self.itemData = item0Data
                    if let imageURL = item0Data["ImageURL"] as? String {
                        let url: URL? = URL(string: imageURL)
                        let data = try? Data(contentsOf: url!)
                        DispatchQueue.main.async {
                            self.navigationItem.title = item0Data["Model"] as? String
                            if (data != nil) {
                                self.imageView.image = UIImage(data: data!)
                            }
                            self.tableView.reloadData()
                        }
                    } else {
                        print("Didnt work2")
                        DispatchQueue.main.async {
                            self.navigationItem.title = item0Data["Model"] as? String
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.navigationItem.title = String(localized: "item_not_found", comment: "Error message when item search returns no results")
                    }
                }
            }
        }
        task.resume()
    }
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.itemData != nil) {
            if let wq = self.itemData["WarehouseQuantity"] as? [Any] {
                //If there are multiple warehouses, we need to add them into the original data count and subtract an additional one for the 1 (WarehouseQuantity) we never used
                return self.itemData.count + wq.count - 2
            } else {
                //We have to subtract one for the ImageURL not displayed in table
                return self.itemData.count - 1
            }
        } else {
            return 0
        }
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        if (self.itemData != nil) {
            if (indexPath.row == 0) {
                // set the text from the data model
                cell.textLabel?.text = "Model"
                cell.detailTextLabel?.text = self.itemData["Model"] as? String
            } else if (indexPath.row == 1) {
                cell.textLabel?.text = "Subtitle"
                cell.detailTextLabel?.text = self.itemData["Subtitle"] as? String
            } else if (indexPath.row == 2) {
                cell.textLabel?.text = "SKU"
                cell.detailTextLabel?.text = self.itemData["SKU"] as? String
            } else if (indexPath.row == 3) {
                cell.textLabel?.text = String(localized: "inventory_id", comment: "Label for inventory ID field")
                cell.detailTextLabel?.text = self.itemData["ID"] as? String
            } else if (indexPath.row == 4) {
                cell.textLabel?.text = "RRP"
                cell.detailTextLabel?.text = self.itemData["RRP"] as? String
            } else if (indexPath.row == 5) {
                cell.textLabel?.text = "Price"
                cell.detailTextLabel?.text = self.itemData["CostPrice"] as? String
            } else if (indexPath.row == 6) {
                cell.textLabel?.text = String(localized: "promotion_price", comment: "Label for promotion price field")
                cell.detailTextLabel?.text = self.itemData["PromotionPrice"] as? String
            } else if (indexPath.row == 7) {
                cell.textLabel?.text = String(localized: "committed_quantity", comment: "Label for committed quantity field")
                cell.detailTextLabel?.text = self.itemData["CommittedQuantity"] as? String
            } else if (indexPath.row == 8) {
                cell.textLabel?.text = String(localized: "available_sell_quantity", comment: "Label for available sell quantity field")
                cell.detailTextLabel?.text = self.itemData["AvailableSellQuantity"] as? String
            } else if (indexPath.row == 9) {
                cell.textLabel?.text = String(localized: "is_active", comment: "Label for active status field")
                cell.detailTextLabel?.text = self.itemData["IsActive"] as? String
            } else if (indexPath.row == 10) {
                cell.textLabel?.text = String(localized: "unit_of_measure", comment: "Label for unit of measure field")
                cell.detailTextLabel?.text = self.itemData["UnitOfMeasure"] as? String
            } else if (indexPath.row == 11) {
                cell.textLabel?.text = String(localized: "product_url", comment: "Label for product URL field")
                cell.detailTextLabel?.text = self.itemData["ProductURL"] as? String
            } else if (indexPath.row > 11) {
                if let wq = self.itemData["WarehouseQuantity"] as? [Any] {
                    if wq.count != 0 && indexPath.row - 12 < wq.count {
                        if let wqi = wq[indexPath.row - 12] as? [String: Any] {
                            cell.textLabel?.text = String(format: String(localized: "warehouse_quantity_format", comment: "Label format for warehouse quantity"), wqi["WarehouseID"] as! String)
                            cell.detailTextLabel?.text = wqi["Quantity"] as? String
                        }
                    }
                } else if let wq = self.itemData["WarehouseQuantity"] as? [String: Any] {
                    cell.textLabel?.text = String(format: String(localized: "warehouse_quantity_format", comment: "Label format for warehouse quantity"), wq["WarehouseID"] as! String)
                    cell.detailTextLabel?.text = wq["Quantity"] as? String
                }
            }
        } else {
            cell.textLabel?.text = ""
            cell.detailTextLabel?.text = ""
        }
        
        return cell
    }
    
    
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if indexPath.row == 11 && cell?.detailTextLabel?.text != "" {
            let urlAsString = cell?.detailTextLabel?.text
            let url = URL(string : urlAsString!)
            UIApplication.shared.open(url!, options: [:]) { (success) in return }
        }
    }

}
