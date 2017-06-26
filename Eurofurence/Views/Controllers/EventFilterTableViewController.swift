//
//  EventFilterTableViewController.swift
//  eurofurence
//
//  Created by Vincent BONMARCHAND on 09/03/2016.
//  Copyright © 2016 eurofurence. All rights reserved.
//

import UIKit

class EventFilterTableViewController: UITableViewController {
    var category = ""
	var room: [EventConferenceRoom] = []
	var day: [EventConferenceDay] = []
	var track: [EventConferenceTrack] = []
	
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor =  UIColor(red: 35/255.0, green: 36/255.0, blue: 38/255.0, alpha: 1.0)
		
		// Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        switch category {
        case "All":
           self.performSegue(withIdentifier: "EventFilterToEventTableSegue", sender: self);
        case "Room":
            self.navigationItem.title = "Room";
            //room = EventConferenceRoom.getAll();
        case "Track":
            self.navigationItem.title = "Track";
            //track = EventConferenceTrack.getAll();
        case "Day":
            self.navigationItem.title = "Day";
            //day = EventConferenceDay.getAll();
        default:
            break
        }
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch category {
        case "All":
            break
        case "Room":
            //room = EventConferenceRoom.getAll();
            return room.count
        case "Track":
            //track = EventConferenceTrack.getAll();
            return track.count
        case "Day":
            //day = EventConferenceDay.getAll();
            return day.count
        default:
            return 0
        }
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventFilterCell", for: indexPath)
        cell.backgroundColor = UIColor(red: 35/255.0, green: 36/255.0, blue: 38/255.0, alpha: 1.0)
        switch category {
        case "All":
            break
        case "Room":
            cell.textLabel?.text = room[indexPath.row].Name
        case "Track":
            cell.textLabel?.text = track[indexPath.row].Name
        case "Day":
            cell.textLabel?.text = day[indexPath.row].Name
        default:
            break
        }
        // Configure the cell...
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
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
        if segue.identifier == "EventFilterToEventTableSegue"
        {
            if let destinationVC = segue.destination as? EventTableViewController{
                let index = self.tableView.indexPathForSelectedRow!
                destinationVC.eventByType = self.category
                switch category {
                case "Room":
                    destinationVC.eventTypeKey = room[index.row].Id
                case "Track":
                    destinationVC.eventTypeKey = track[index.row].Id
                case "Day":
                   destinationVC.eventTypeKey = day[index.row].Id
                default:
                    break
                }
                
            }
        }
    }
    
}
