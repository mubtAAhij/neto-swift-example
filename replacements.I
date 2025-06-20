// Replace these strings:
self.navigationItem.title = "No Data Inputted" 
→ self.navigationItem.title = String(localized: "no_data_inputted", comment: "Shown when no search data was provided")

self.navigationItem.title = "Item Not Found"
→ self.navigationItem.title = String(localized: "item_not_found", comment: "Shown when item search returns no results")

cell.textLabel?.text = "Inventory ID"
→ cell.textLabel?.text = String(localized: "inventory_id", comment: "Label for inventory ID field")

cell.textLabel?.text = "Promotion Price"
→ cell.textLabel?.text = String(localized: "promotion_price", comment: "Label for promotion price field")

cell.textLabel?.text = "Committed Quantity"
→ cell.textLabel?.text = String(localized: "committed_quantity", comment: "Label for committed quantity field")

cell.textLabel?.text = "Available Sell Quantity"
→ cell.textLabel?.text = String(localized: "available_sell_quantity", comment: "Label for available sell quantity field")

cell.textLabel?.text = "Is Active?"
→ cell.textLabel?.text = String(localized: "is_active", comment: "Label for active status field")

cell.textLabel?.text = "Unit of Measure"
→ cell.textLabel?.text = String(localized: "unit_of_measure", comment: "Label for unit of measure field")

cell.textLabel?.text = "Product URL"
→ cell.textLabel?.text = String(localized: "product_url", comment: "Label for product URL field")

// For the warehouse quantity strings, we'll use a format string:
cell.textLabel?.text = String("Warehouse \(wqi["WarehouseID"]!) Quantity")
→ cell.textLabel?.text = String(format: String(localized: "warehouse_quantity_format", comment: "Label for warehouse quantity with ID"), wqi["WarehouseID"] as! CVarArg)

cell.textLabel?.text = String("Warehouse \(wq["WarehouseID"]!) Quantity")
→ cell.textLabel?.text = String(format: String(localized: "warehouse_quantity_format", comment: "Label for warehouse quantity with ID"), wq["WarehouseID"] as! CVarArg)
