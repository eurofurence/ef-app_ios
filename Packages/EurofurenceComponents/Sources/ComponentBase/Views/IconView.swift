import UIKit

public class IconView: UIImageView {
    
    public enum Icon: Int {
        
        case favourite
        case artshow
        case mainStage
        case sponsor
        case superSponsor
        case wine
        case bug
        case dealersDen
        case photoshoot
        case afterDarkDealersDen
        case warning
        case faceMaskRequired
        
        fileprivate var view: UIView {
            switch self {
            case .favourite:
                return makeSymbolView(symbolName: "heart.fill", symbolWeight: .regular, tint: .systemRed)
                
            case .artshow:
                return makeSymbolView(symbolName: "photo", symbolWeight: .bold)
                
            case .mainStage:
                return makeSymbolView(symbolName: "asterisk", symbolWeight: .bold)
                
            case .sponsor:
                return makeSymbolView(symbolName: "star", symbolWeight: .semibold)
                
            case .superSponsor:
                return makeSymbolView(symbolName: "star.fill", symbolWeight: .semibold)
                
            case .wine:
                return makeAwesomeFontIcon(code: "\u{f000}")
                
            case .bug:
                return makeAwesomeFontIcon(code: "\u{f188}")
                
            case .dealersDen:
                return makeSymbolView(symbolName: "cart.fill", symbolWeight: .semibold)
                
            case .photoshoot:
                return makeSymbolView(symbolName: "camera", symbolWeight: .medium)
                
            case .afterDarkDealersDen:
                return makeSymbolView(symbolName: "moon", symbolWeight: .medium)
                
            case .warning:
                return makeSymbolView(symbolName: "exclamationmark.triangle.fill", symbolWeight: .regular)
                
            case .faceMaskRequired:
                return makeSymbolView(symbolName: "facemask.fill", symbolWeight: .regular)
            }
        }
        
        private func makeSymbolView(
            symbolName: String,
            symbolWeight: UIImage.SymbolWeight,
            tint: UIColor = .efTintColor
        ) -> UIView {
            let symbolConfiguration = UIImage.SymbolConfiguration(weight: .medium)
            let image = UIImage(systemName: symbolName, withConfiguration: symbolConfiguration)
            let imageView = UIImageView(image: image)
            imageView.backgroundColor = .clear
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = tint
            
            return imageView
        }
        
        private func makeAwesomeFontIcon(code: String) -> UIView {
            let label = AwesomeFontLabel(frame: .zero)
            label.font = UIFont(name: "FontAwesome", size: 18)
            label.text = code
            
            return label
        }
        
    }
    
    public var icon: Icon {
        didSet {
            updateIconView()
        }
    }
    
    public init(icon: Icon) {
        self.icon = icon
        
        super.init(frame: .zero)
        
        backgroundColor = .clear
        isAccessibilityElement = false
        translatesAutoresizingMaskIntoConstraints = false
        
        setContentHuggingPriority(.required, for: .horizontal)
        setContentHuggingPriority(.required, for: .vertical)
        
        updateIconView()
    }
    
    required init?(coder: NSCoder) {
        let iconInt = coder.decodeInt32(forKey: "IconView.icon")
        guard let icon = Icon(rawValue: Int(iconInt)) else { return nil }
        
        self.icon = icon
        
        super.init(coder: coder)
        
        updateIconView()
    }
    
    override public func encode(with coder: NSCoder) {
        super.encode(with: coder)
        coder.encode(icon.rawValue, forKey: "IconView.icon")
    }
    
    override public var intrinsicContentSize: CGSize {
        if let existingView = subviews.first {
            return existingView.intrinsicContentSize
        } else {
            return .zero
        }
    }
    
    private func updateIconView() {
        if let existingView = subviews.first {
            existingView.removeFromSuperview()
        }
        
        let iconView = icon.view
        iconView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iconView)
        
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: iconView.leadingAnchor),
            trailingAnchor.constraint(equalTo: iconView.trailingAnchor),
            topAnchor.constraint(equalTo: iconView.topAnchor),
            bottomAnchor.constraint(equalTo: iconView.bottomAnchor)
        ])
    }
    
}
