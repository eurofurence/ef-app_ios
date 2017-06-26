//
//  KnowledgeTableViewController.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

class KnowledgeTableViewController: UITableViewController {
	let dataContext: IDataContext = try! ContextResolver.container.resolve()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataContext.KnowledgeGroups.value.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dataContext.KnowledgeGroups.value[section].KnowledgeEntries.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "KnowledgeEntryCell", for: indexPath)
		cell.textLabel!.text = dataContext.KnowledgeGroups.value[indexPath.section].KnowledgeEntries[indexPath.row].Title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }
    
    override func tableView( _ tableView : UITableView,  titleForHeaderInSection section: Int)->String {
        return dataContext.KnowledgeGroups.value[section].Name
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "KnowledgeGroupCell") as? KnowledgeGroupCell else {
			return nil
		}
		
		cell.knowledgeGroup = dataContext.KnowledgeGroups.value[section]
		
        //let headerTapped = UITapGestureRecognizer (target: self, action:#selector(InfoTableViewController.sectionHeaderTapped(_:)))
        //cell.addGestureRecognizer(headerTapped)
        
        return cell
    }
    
    func sectionHeaderTapped(_ recognizer: UITapGestureRecognizer) {
        //print("Tapping working")
        //print(recognizer.view?.tag)
        /**
         var indexPath : NSIndexPath = NSIndexPath(forRow: 0, inSection:(recognizer.view?.tag as Int!)!)
         if (indexPath.row == 0) {
         
         //var collapsed = arrayForBool.objectAtIndex(indexPath.section).boolValue
         //collapsed       = !collapsed;
         
         //arrayForBool.replaceObjectAtIndex(indexPath.section, withObject: collapsed)
         //reload specific section animated
         var range = NSMakeRange(indexPath.section, 1)
         var sectionToReload = NSIndexSet(indexesInRange: range)
         self.tableView .reloadSections(sectionToReload, withRowAnimation:UITableViewRowAnimation.Fade)
         }
         **/
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "KnowledgeEntryDetailSegue" {
            if let destinationVC = segue.destination as? InfoViewController, let cell = sender as? KnowledgeEntryCell, let knowledgeEntry = cell.knowledgeEntry {
				destinationVC.knowledgeEntry = knowledgeEntry
            }
        }
    }
	
    @IBAction func openMenu(_ sender: AnyObject) {
        if let _ = self.slideMenuController() {
            self.slideMenuController()?.openLeft()
        }
    }
    
    
}
