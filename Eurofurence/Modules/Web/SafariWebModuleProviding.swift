import SafariServices

struct SafariWebModuleProviding: WebModuleProviding {

    func makeWebModule(for url: URL) -> UIViewController {
        var safeURL = url
        if var components = URLComponents(url: url, resolvingAgainstBaseURL: false), components.scheme != "https" {
            components.scheme = "https"
            
            if let schemedURL = components.url {
                safeURL = schemedURL
            }
        }

        let module = SFSafariViewController(url: safeURL)
        module.preferredBarTintColor = .safariBarTint
        module.preferredControlTintColor = .safariControlTint

        return module
    }

}
