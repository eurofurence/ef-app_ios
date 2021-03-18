import DealerComponent
import EurofurenceModel
import Foundation
import TestUtilities

extension DealerDetailAboutTheArtistViewModel: RandomValueProviding {

    public static var random: DealerDetailAboutTheArtistViewModel {
        return DealerDetailAboutTheArtistViewModel(title: .random, artistDescription: .random)
    }

}
