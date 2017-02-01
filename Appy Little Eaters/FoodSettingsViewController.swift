//
//  SettingsViewController.swift
//  AppyLittleEaters
//
//  Created by RUSSELL STATHER on 03/11/2015.
//  Copyright © 2015 Ready Steady Rainbow. All rights reserved.
//

import UIKit

class FoodSettingsViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodColourCell", for: indexPath)
        switch indexPath.row{
        case 0:
            cell.textLabel?.text = "Red food settings"
            break
        case 1:
            cell.textLabel?.text = "Orange food settings"
            break
        case 2:
            cell.textLabel?.text = "Yellow food settings"
            break
        case 3:
            cell.textLabel?.text = "Purple food settings"
            break
        case 4:
            cell.textLabel?.text = "Green food settings"
            break
        case 5:
            cell.textLabel?.text = "White food settings"
            break
        default:
            break
        }
        return cell
    }
    
    
    var FoodColour:String!
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row{
        case 0:
            FoodColour = "Red"
            performSegue(withIdentifier: "FoodColourSegue", sender: self)
            break
        case 1:
            FoodColour = "Orange"
            performSegue(withIdentifier: "FoodColourSegue", sender: self)
            break
        case 2:
            FoodColour = "Yellow"
            performSegue(withIdentifier: "FoodColourSegue", sender: self)
            break
        case 3:
            FoodColour = "Purple"
            performSegue(withIdentifier: "FoodColourSegue", sender: self)
            break
        case 4:
            FoodColour = "Green"
            performSegue(withIdentifier: "FoodColourSegue", sender: self)
            break
        case 5:
            FoodColour = "White"
            performSegue(withIdentifier: "FoodColourSegue", sender: self)
            break
        default:
            break
        }
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let vc = segue.destination as! ChooseFoodController
        vc.FoodColour = FoodColour
        
    }

}
