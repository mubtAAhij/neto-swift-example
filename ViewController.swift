let alert = UIAlertController(
    title: String(localized: "welcome_title", comment: "Welcome alert title"),
    message: String(localized: "welcome_message", comment: "Welcome alert instructions"),
    preferredStyle: .alert)

alert.addAction(UIAlertAction(
    title: String(localized: "got_it_button", comment: "Confirmation button for welcome alert"),
    style: .default,
    handler: { _ in
        UserDefaults.standard.set(true, forKey: "alertShown")
    }))
