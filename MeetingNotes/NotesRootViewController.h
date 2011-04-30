//
//  NotesRootViewController.h
//  MeetingNotes
//
//  Created by Noel Curtis on 4/23/11.
//  Copyright 2011 Noel Curtis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Meeting;
@class NotesDetailViewController;
@interface NotesRootViewController : UITableViewController {
    
}
@property (nonatomic, retain) Meeting* meetingBeingEdited;
@property (nonatomic, retain) NotesDetailViewController* notesDetailViewController;
-(IBAction) addActionItem:(id) sender;
@end
