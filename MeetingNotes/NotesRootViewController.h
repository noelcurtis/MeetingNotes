//
//  NotesRootViewController.h
//  MeetingNotes
//
//  Created by Noel Curtis on 4/23/11.
//  Copyright 2011 Noel Curtis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AgendaItem.h"

@class Meeting;
@class NotesDetailViewController;
@class SortDetailViewController;
@class AgendaItemCell;

@interface UIBarButtonItem(ButtonWithImage)

+ (UIBarButtonItem*)barItemWithImage:(UIImage*)image target:(id)target action:(SEL)action;

@end

@interface NotesRootViewController : UITableViewController {
    
}
@property (nonatomic, retain) Meeting* meetingBeingEdited;
@property (nonatomic, retain) NotesDetailViewController* notesDetailViewController;
@property (nonatomic, retain) SortDetailViewController* sortDetailViewController;
@property (nonatomic, retain) NSMutableArray* agendaItems;
@property (nonatomic, retain) IBOutlet AgendaItemCell* agendaItemCell;
-(IBAction) addActionItem:(id) sender;

//-(void)saveContextAndReloadTable;
-(void)saveContextAndReloadTableWithNewAgendaItem:(AgendaItem*)newAgendaItem;

// options segment action
-(IBAction)optionsSegmentAction:(id)sender;

-(IBAction)backButtonAction:(id)sender;

@end
