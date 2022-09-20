import SwiftUI

struct StarRating: View {
    
    @Binding private var rating: Int
    @State private var editingValue: Int
    @State private var layoutWidth: CGFloat = 1
    @Environment(\.selectionChangedHaptic) private var selectionChangedHaptic
    private let minRating: Int
    private let maxRating: Int
    private let ratings: [Rating]
    
    private struct Rating: Identifiable {
        
        var id: some Hashable {
            value
        }
        
        var value: Int
        
    }
    
    init(rating: Binding<Int>, minRating: Int, maxRating: Int) {
        precondition(minRating < maxRating)
        
        _rating = rating
        editingValue = rating.wrappedValue
        self.minRating = minRating
        self.maxRating = maxRating
        
        let range = minRating...maxRating
        ratings = range.map { value in
            Rating(value: value)
        }
    }
    
    var body: some View {
        HStack {
            ForEach(ratings) { option in
                let isFilled = option.value <= editingValue
                
                Image(systemName: isFilled ? "star.fill" : "star")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.yellow)
                    .onTapGesture {
                        rating = option.value
                    }
            }
        }
        .measure { newSize in
            layoutWidth = newSize.width
        }
        .gesture(
            DragGesture()
                .onChanged { change in
                    editingValue = estimatedValue(fromDrag: change)
                }
                .onEnded { change in
                    rating = estimatedValue(fromDrag: change)
                }
        )
        .onChange(of: editingValue) { newValue in
            selectionChangedHaptic()
        }
        .onChange(of: rating) { newValue in
            editingValue = newValue
        }
    }
    
    private func estimatedValue(fromDrag value: DragGesture.Value) -> Int {
        let point = value.location
        let horizontalProportion = point.x / layoutWidth
        let estimatedValue = horizontalProportion * CGFloat(maxRating)
        let truncatedValue = Int(ceil(estimatedValue))
        let rangedValue = min(maxRating, max(minRating, truncatedValue))
        
        return rangedValue
    }
    
}

struct StarRating_Previews: PreviewProvider {
    
    static var previews: some View {
        StarRating(rating: .constant(3), minRating: 1, maxRating: 5)
            .previewLayout(.sizeThatFits)
    }
    
}
