//
//  MainTVC.swift
//  SnapLister
//
//  Created by Khalid Naseem on 22/07/2016.
//  Copyright © 2016 Khalid Naseem. All rights reserved.
//

import UIKit
import CoreData

class MainTVC: UITableViewController, NSFetchedResultsControllerDelegate {
    
    //MARK: Managed Object Context (serves table as flash saved)
    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    //MARK: Fetched Results Controller
    var frc : NSFetchedResultsController = NSFetchedResultsController()
    
    //MARK: Function for fetch request
    func fetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "Picture")
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    
    //MARK: Get fetch requests controller
    func getFRC() -> NSFetchedResultsController {
        frc = NSFetchedResultsController(fetchRequest: fetchRequest(), managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        return frc
        
    }
    
    //MARK: Tableview background setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 75
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "bg.jpg"))
        self.tableView.backgroundView?.alpha = 0.75
        
        // set frc
        frc = getFRC()
        frc.delegate = self
        
        // Perform initial fetch
        do {
            try frc.performFetch()
        } catch {
            print("fetch failed.")
            return
        }
        
        //When we load initial fetch we want to reload tabledata.
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        let numberOfSections = frc.sections?.count
        return numberOfSections!
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        let numbeOfRowsInSection = frc.sections?[section].numberOfObjects
        return numbeOfRowsInSection!
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        // Configure the cell...
        cell.textLabel?.textColor = UIColor.blackColor()
        cell.textLabel?.backgroundColor = UIColor.clearColor()
        cell.detailTextLabel?.backgroundColor = UIColor.clearColor()
       
        
        let picture = frc.objectAtIndexPath(indexPath) as! Picture
        cell.textLabel!.text = picture.title
        cell.detailTextLabel!.text = picture.location
        cell.imageView?.image = UIImage(data: (picture.image)!)

        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let managedObject : NSManagedObject = frc.objectAtIndexPath(indexPath) as! NSManagedObject
        moc.deleteObject(managedObject)
        
        do {
            try moc.save()
            
        } catch {
            print("Failed to save.")
            return
        }
    }
    
    // Callback function when swipe to delete cell
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        tableView.reloadData()
    }
    
    

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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "edit" {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let picController : AddEditVC = segue.destinationViewController as! AddEditVC
            let picture : Picture = frc.objectAtIndexPath(indexPath!) as! Picture
            picController.picture = picture
            
        }

    }
    
    
}
