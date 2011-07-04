//
//  NotesRootViewController.h
//  MeetingNotes
//
//  Created by Noel Curtis on 4/23/11.
//  Copyright 2011 Noel Curtis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AgendaItem.h"
#import "NotesDetailViewController.h"

@class Meeting;
@class NotesDetailViewController;
@class SortDetailViewController;
@class AgendaItemCell;

@interface UIBarButtonItem(ButtonWithImage)

+ (UIBarButtonItem*)barItemWithImage:(UIImage*)image target:(id)target action:(SEL)action;

@end

@interface NotesRootViewController : UITableViewController<AgendaItemTitleChangeDelegate> {
    
}
@property (nonatomic, retain) Meeting* meetingBeingEdited;
@property (nonatomic, retain) NotesDetailViewController* notesDetailViewController;
@property (nonatomic, retain) SortDetailViewController* sortDetailViewController;
@property (nonatomic, retain) NSMutableArray* agendaItems;
@property (nonatomic, retain) IBOutlet AgendaItemCell* agendaItemCell;
@property (nonatomic, retain)AgendaItemCell *currentSelectedCell;
-(IBAction) addAgendaItem:(id) sender;

//-(void)saveContextAndReloadTable;
-(void)saveContextAndReloadTableWithNewAgendaItem:(AgendaItem*)newAgendaItem;

-(IBAction)backButtonAction:(id)sender;

@end
