// Line 57: Navigation title for no data
self.navigationItem.title = String(localized: "no_data_inputted", 
    comment: "Navigation title when no search data is provided")

// Line 100: Navigation title for not found
self.navigationItem.title = String(localized: "item_not_found", 
    comment: "Navigation title when item is not found")

// Table view labels (user-facing UI elements)
// Line 140
cell.textLabel?.text = String(localized: "inventory_id_label", 
    comment: "Label for inventory ID field")

// Line 149
cell.textLabel?.text = String(localized: "promotion_price_label", 
    comment: "Label for promotion price field")

// Line 152
cell.textLabel?.text = String(localized: "committed_quantity_label", 
    comment: "Label for committed quantity field")

// Line 155
cell.textLabel?.text = String(localized: "available_sell_quantity_label", 
    comment: "Label for available sell quantity field")

// Line 158
cell.textLabel?.text = String(localized: "is_active_label", 
    comment: "Label for active status field")

// Line 161
cell.textLabel?.text = String(localized: "unit_of_measure_label", 
    comment: "Label for unit of measure field")

// Line 164
cell.textLabel?.text = String(localized: "product_url_label", 
    comment: "Label for product URL field")

// Lines 170 and 175: Warehouse quantity labels
// Note: We'll keep the string interpolation but localize the template
cell.textLabel?.text = String(localized: "warehouse_quantity_label",
    defaultValue: "Warehouse %@ Quantity",
    comment: "Label for warehouse quantity where %@ is the warehouse ID")
    .formatted(wqi["WarehouseID"] as? String ?? "")
