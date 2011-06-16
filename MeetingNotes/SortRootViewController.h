//
//  SortRootViewController.h
//  MeetingNotes
//
//  Created by Noel Curtis on 4/18/11.
//  Copyright 2011 Noel Curtis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SortDetailViewController;
@class NotesRootViewController;
@class SortViewCell;

@interface SortRootViewController : UITableViewController<UISplitViewControllerDelegate, NSFetchedResultsControllerDelegate> {
    
}

@property (nonatomic, retain) IBOutlet SortDetailViewController *dvController;
@property (nonatomic, retain) IBOutlet SortViewCell *sortViewCell;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end
