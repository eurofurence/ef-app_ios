import EurofurenceModel

extension MapContent: Equatable {

    public static func == (lhs: MapContent, rhs: MapContent) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none):
            return true

        case (.location(let lx, let ly, let lname), .location(let rx, let ry, let rname)):
            return lx == rx && ly == ry && lname == rname

        case (.room(let lRoom), .room(let rRoom)):
            return lRoom.name == rRoom.name

        case (.dealer(let lDealer), .dealer(let rDealer)):
            return lDealer.identifier == rDealer.identifier

        case (.multiple(let lMultiple), .multiple(let rMultiple)):
            return lMultiple.elementsEqual(rMultiple)

        default:
            return false
        }
    }

}
