import UIKit.UIViewController

class MessageDetailViewController: UIViewController,
                                   UICollectionViewDataSource,
                                   MessageDetailScene {

    // MARK: IBOutlets

    @IBOutlet weak var collectionView: UICollectionView!
    private var messageCell: MessageBubbleCollectionViewCell?
    private var binders = [CellBinder]()

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate?.messageDetailSceneDidLoad()
    }

    // MARK: UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return binders.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return binders[indexPath.row].makeCell(from: collectionView, forItemAt: indexPath)
    }

    // MARK: MessageDetailScene

    var delegate: MessageDetailSceneDelegate?

    func setMessageDetailTitle(_ title: String) {
        super.title = title
    }

    func addMessageComponent(with binder: MessageComponentBinder) {
        binders.append(CellBinder(binder: binder))
        collectionView.reloadData()
    }

    // MARK: Binding

    private struct CellBinder {

        var binder: MessageComponentBinder

        func makeCell(from collectionView: UICollectionView, forItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeue(MessageBubbleCollectionViewCell.self, for: indexPath)
            binder.bind(cell)

            return cell
        }

    }

}
