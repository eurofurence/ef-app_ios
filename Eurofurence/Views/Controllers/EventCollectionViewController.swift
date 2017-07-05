//
//  EventCollectionViewController.swift
//  eurofurence
//
//  Created by Vincent BONMARCHAND on 09/03/2016.
//  Copyright © 2016 eurofurence. All rights reserved.
//

import UIKit

class EventCollectionViewController: UICollectionViewController {
	private let reuseIdentifier = "cell"
	private let sectionMenu = ["All", "Room", "Track", "Day"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(EventCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  sectionMenu.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 100)
    }

    func createCollectionCellCustom() -> UIView {
        let whiteRoundedCornerView = UIView(frame: CGRect(x: 5, y: 10, width: (collectionView!.frame.size.width)-10, height: 110))
        whiteRoundedCornerView.backgroundColor = UIColor(red: 0/255.0, green: 120/255.0, blue: 106/255.0, alpha: 1.0)
        whiteRoundedCornerView.layer.masksToBounds = false
        whiteRoundedCornerView.layer.shadowOpacity = 1.55
        whiteRoundedCornerView.layer.shadowOffset = CGSize(width: 1, height: 0)
        whiteRoundedCornerView.layer.shadowColor = UIColor(red: 53/255.0, green: 143/255.0, blue: 185/255.0, alpha: 1.0).cgColor
        whiteRoundedCornerView.layer.cornerRadius = 3.0
        whiteRoundedCornerView.layer.shadowOffset = CGSize(width: -1, height: -1)
        whiteRoundedCornerView.layer.shadowOpacity = 0.5
        return whiteRoundedCornerView
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (sectionMenu[(indexPath as NSIndexPath).row] == "All") {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as UICollectionViewCell

            //cell.cellTitle.text = sectionMenu[indexPath.row];

            // Configure the cell
            cell.contentView.backgroundColor=UIColor.clear

            //let whiteRoundedCornerView = createCollectionCellCustom()
            //cell.contentView.addSubview(whiteRoundedCornerView)
            //cell.contentView.sendSubviewToBack(whiteRoundedCornerView)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! EventCollectionViewCell

            cell.cellTitle.text = sectionMenu[(indexPath as NSIndexPath).row]

            // Configure the cell
            cell.contentView.backgroundColor=UIColor.clear

            //let whiteRoundedCornerView = createCollectionCellCustom()
            //cell.contentView.addSubview(whiteRoundedCornerView)
            //cell.contentView.sendSubviewToBack(whiteRoundedCornerView)
            return cell
        }

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "EventCollectionToFilterSegue" {
            if let destinationVC = segue.destination as? EventFilterTableViewController {
                let cell = sender as! EventCollectionViewCell
                let index = self.collectionView?.indexPath(for: cell)
                destinationVC.category = sectionMenu[(index! as NSIndexPath).row]
            }
        }
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
