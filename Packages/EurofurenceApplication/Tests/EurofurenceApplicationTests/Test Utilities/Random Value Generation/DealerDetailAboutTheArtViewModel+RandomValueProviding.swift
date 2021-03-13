import EurofurenceApplication
import EurofurenceModel
import TestUtilities

extension DealerDetailAboutTheArtViewModel: RandomValueProviding {

    public static var random: DealerDetailAboutTheArtViewModel {
        return DealerDetailAboutTheArtViewModel(title: .random,
                                                aboutTheArt: .random,
                                                artPreviewImagePNGData: .random,
                                                artPreviewCaption: .random)
    }

}
