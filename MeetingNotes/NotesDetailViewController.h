//
//  NotesDetailViewController.h
//  MeetingNotes
//
//  Created by Noel Curtis on 4/23/11.
//  Copyright 2011 Noel Curtis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NotesRootViewController;
@class AgendaItem;
@interface NotesDetailViewController : UITableViewController<UITextFieldDelegate, UITextViewDelegate> {
    
}

@property(nonatomic, retain)IBOutlet UITableViewCell* actionItemCell;
@property(nonatomic, retain)IBOutlet UITableViewCell* attendeeCell;
@property(nonatomic, retain)IBOutlet UITableViewCell* agendaItemNotesCell;
@property(nonatomic, retain)IBOutlet UITableViewCell* agendaItemTitleCell;
@property(nonatomic, retain)IBOutlet UITextView* notesTextView;
@property(nonatomic, retain)IBOutlet UILabel* attendeeUILabel;
@property(nonatomic, retain)IBOutlet UILabel* actionItemUILabel;
@property(nonatomic, retain)IBOutlet UITextField* agendaItemTitleTextField;

// From the root view controller
@property(nonatomic, retain)NotesRootViewController* notesRootViewController;
@property(nonatomic, retain)AgendaItem* agendaItem;

-(UITableViewCell *) configureCellAtIndexPath:(NSIndexPath *)indexPath;
-(void) setupDetailViewWithAgendaItem:(AgendaItem*) selectedAgendaItem;

// Button actions
-(IBAction) newActionItemAction:(id)sender;

// Test with the tool bar
@property (nonatomic, retain)IBOutlet UIToolbar* detailViewControllerToolbar;

@end
