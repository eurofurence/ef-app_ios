import SafariServices

struct SafariWebModuleProviding: WebModuleProviding {

    func makeWebModule(for url: URL) -> UIViewController {
        var safeURL = url
        if var components = URLComponents(url: url, resolvingAgainstBaseURL: false), components.scheme != "https" {
            components.scheme = "https"
            safeURL = components.url!
        }

        let module = SFSafariViewController(url: safeURL)
        module.preferredBarTintColor = .pantone330U
        module.preferredControlTintColor = .white

        return module
    }

}
