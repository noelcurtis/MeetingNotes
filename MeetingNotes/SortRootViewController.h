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

@interface SortRootViewController : UITableViewController<UISplitViewControllerDelegate> {
    
}

@property (nonatomic, retain) IBOutlet SortDetailViewController *dvController;
@end
