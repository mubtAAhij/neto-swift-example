// Original file with localized strings
// [Previous imports and class declaration remain the same]

class ItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // [Previous outlet and property declarations remain the same]
    
    // [Previous functions remain the same until the point where strings need to be localized]
    
    private func querySKU() {
        // [Previous code remains the same until the title setting]
        } else {
            self.navigationItem.title = String(localized: "no_data_inputted", 
                comment: "Title shown when no search data was provided")
            return
        }
        
        // [Previous networking code remains the same until the error title]
        } else {
            DispatchQueue.main.async {
                self.navigationItem.title = String(localized: "item_not_found", 
                    comment: "Title shown when item search returns no results")
            }
        }
        // [Rest of the function remains the same]
    }
    
    // [Previous tableView methods remain the same until cellForRowAt]
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        if (self.itemData != nil) {
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Model"  // Not localized as it's a technical term
                cell.detailTextLabel?.text = self.itemData["Model"] as? String
            case 1:
                cell.textLabel?.text = "Subtitle"  // Not localized as it's a technical term
                cell.detailTextLabel?.text = self.itemData["Subtitle"] as? String
            case 2:
                cell.textLabel?.text = "SKU"  // Not localized as it's a technical term
                cell.detailTextLabel?.text = self.itemData["SKU"] as? String
            case 3:
                cell.textLabel?.text = String(localized: "inventory_id", 
                    comment: "Label for inventory ID field")
                cell.detailTextLabel?.text = self.itemData["ID"] as? String
            case 4:
                cell.textLabel?.text = "RRP"  // Not localized as it's a technical term
                cell.detailTextLabel?.text = self.itemData["RRP"] as? String
            case 5:
                cell.textLabel?.text = String(localized: "price", 
                    comment: "Label for price field")
                cell.detailTextLabel?.text = self.itemData["CostPrice"] as? String
            case 6:
                cell.textLabel?.text = String(localized: "promotion_price", 
                    comment: "Label for promotion price field")
                cell.detailTextLabel?.text = self.itemData["PromotionPrice"] as? String
            case 7:
                cell.textLabel?.text = String(localized: "committed_quantity", 
                    comment: "Label for committed quantity field")
                cell.detailTextLabel?.text = self.itemData["CommittedQuantity"] as? String
            case 8:
                cell.textLabel?.text = String(localized: "available_sell_quantity", 
                    comment: "Label for available sell quantity field")
                cell.detailTextLabel?.text = self.itemData["AvailableSellQuantity"] as? String
            case 9:
                cell.textLabel?.text = String(localized: "is_active", 
                    comment: "Label for active status field")
                cell.detailTextLabel?.text = self.itemData["IsActive"] as? String
            case 10:
                cell.textLabel?.text = String(localized: "unit_of_measure", 
                    comment: "Label for unit of measure field")
                cell.detailTextLabel?.text = self.itemData["UnitOfMeasure"] as? String
            case 11:
                cell.textLabel?.text = String(localized: "product_url", 
                    comment: "Label for product URL field")
                cell.detailTextLabel?.text = self.itemData["ProductURL"] as? String
            default:
                if let wq = self.itemData["WarehouseQuantity"] as? [Any] {
                    if wq.count != 0 && indexPath.row - 12 < wq.count {
                        if let wqi = wq[indexPath.row - 12] as? [String: Any] {
                            cell.textLabel?.text = String(localized: "warehouse_quantity_format",
                                comment: "Label format for warehouse quantity",
                                arguments: [wqi["WarehouseID"] as? String ?? ""])
                            cell.detailTextLabel?.text = wqi["Quantity"] as? String
                        }
                    }
                } else if let wq = self.itemData["WarehouseQuantity"] as? [String: Any] {
                    cell.textLabel?.text = String(localized: "warehouse_quantity_format",
                        comment: "Label format for warehouse quantity",
                        arguments: [wq["WarehouseID"] as? String ?? ""])
                    cell.detailTextLabel?.text = wq["Quantity"] as? String
                }
            }
        } else {
            cell.textLabel?.text = ""
            cell.detailTextLabel?.text = ""
        }
        
        return cell
    }
    
    // [Rest of the class implementation remains the same]
}
