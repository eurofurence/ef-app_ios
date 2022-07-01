import UIKit

public class IconView: UIImageView {
    
    public enum Icon {
        
        case favourite
        case artshow
        case mainStage
        case sponsor
        case superSponsor
        case wine
        case bug
        case dealersDen
        case photoshoot
        
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
    
    private var iconView: UIView
    
    public init(icon: Icon) {
        iconView = icon.view
        super.init(frame: .zero)
        
        backgroundColor = .clear
        isAccessibilityElement = false
        translatesAutoresizingMaskIntoConstraints = false
        
        iconView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iconView)
        
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: iconView.leadingAnchor),
            trailingAnchor.constraint(equalTo: iconView.trailingAnchor),
            topAnchor.constraint(equalTo: iconView.topAnchor),
            bottomAnchor.constraint(equalTo: iconView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public var intrinsicContentSize: CGSize {
        iconView.intrinsicContentSize
    }
    
}
