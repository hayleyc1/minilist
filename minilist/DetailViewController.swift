//
//  DetailViewController.swift
//  minilist
//
//  Created by Hayley Cundiff on 1/16/16.
//  Copyright © 2016 Artifylabs. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UITableViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    var miniListItems: NSMutableOrderedSet!
    //var objects = [AnyObject]()
    var detailItem: NSManagedObject! {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.valueForKey("name") as? String
            }
            miniListItems = detail.mutableOrderedSetValueForKey("items")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancelAddItem(segue:UIStoryboardSegue) {
        
    }
    @IBAction func saveAddItem(segue:UIStoryboardSegue){
        if let newItemViewController = segue.sourceViewController as? NewItemViewContriller {
            print("Here4")
            
            if let list = newItemViewController.list{
                print("Here5")
                
                self.newMiniListItem(list.Ourname)
                self.tableView.reloadData()
                
            }
            
        }
    }
    
    func newMiniListItem(name: String)
    {
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let entity =  NSEntityDescription.entityForName("MiniListItem",
            inManagedObjectContext:managedContext)
        
        let miniListItem = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext: managedContext)
        
        //3
        miniListItem.setValue(name, forKey: "itemname")
        
        let entityItem =  NSEntityDescription.entityForName("MiniListItem", inManagedObjectContext:managedContext)
        let newItem = NSManagedObject(entity: entityItem!, insertIntoManagedObjectContext: managedContext)
        newItem.setValue(name, forKeyPath: "itemname")
        
        miniListItems.addObject(newItem)

        
        //4
        do {
            try managedContext.save()
            //5
            //miniListItems.append(miniListItem)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func deleteAtIndex(index: Int)
    {
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        miniListItems.removeObjectAtIndex(index)
        
        do {
            try managedContext.save()
            //5
            //miniListItems.append(miniListItem)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }
    
/*    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "MiniListItems")
        
        //3
        do {
            //let results =
            //try managedContext.executeFetchRequest(fetchRequest)
            //miniListItems = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
*/
    
    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return miniListItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let miniListItem = miniListItems[indexPath.row]
        cell.textLabel!.text = miniListItem.valueForKey("itemname") as? String
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            deleteAtIndex(indexPath.row)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

