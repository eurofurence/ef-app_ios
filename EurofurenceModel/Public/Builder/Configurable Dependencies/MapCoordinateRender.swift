import Foundation

public protocol MapCoordinateRender {

    func render(x: Int, y: Int, radius: Int, onto data: Data) -> Data

}
