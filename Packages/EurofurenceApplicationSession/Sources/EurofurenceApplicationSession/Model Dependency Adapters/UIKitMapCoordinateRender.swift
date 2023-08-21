import EurofurenceModel
import UIKit

struct UIKitMapCoordinateRender: MapCoordinateRender {

    func render(x: Int, y: Int, radius: Int, onto data: Data) -> Data {
        guard let image = UIImage(data: data), image.cgImage != nil else { return Data() }

        UIGraphicsBeginImageContext(image.size)
        defer { UIGraphicsEndImageContext() }

        image.draw(at: .zero)

        let highlightPath = UIBezierPath(arcCenter: CGPoint(x: CGFloat(x), y: CGFloat(y)),
                                         radius: CGFloat(radius),
                                         startAngle: 0,
                                         endAngle: .pi * 2,
                                         clockwise: true)
        highlightPath.lineWidth = 3

        UIColor.red.setStroke()
        highlightPath.stroke()

        guard let highlightedImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else { return Data() }

        let viewportWindow = max(CGFloat(radius) * 7.5, 700)
        let croppingRect = CGRect(x: CGFloat(x) - viewportWindow / 2,
                                  y: CGFloat(y) - viewportWindow / 2,
                                  width: viewportWindow,
                                  height: viewportWindow)
        guard let croppedImage = highlightedImage.cropping(to: croppingRect) else { return Data() }

        let drawable = UIImage(cgImage: croppedImage)
        return drawable.pngData() ?? Data()
    }

}
