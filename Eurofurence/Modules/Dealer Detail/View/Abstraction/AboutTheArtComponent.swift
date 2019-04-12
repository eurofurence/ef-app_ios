import Foundation

protocol AboutTheArtComponent {

    func setComponentTitle(_ title: String)
    func showAboutTheArtDescription(_ aboutTheArt: String)
    func showArtPreviewImagePNGData(_ artPreviewImagePNGData: Data)
    func showArtPreviewCaption(_ caption: String)

    func hideAboutTheArtDescription()
    func hideArtPreviewImage()
    func hideArtPreviewCaption()

}
