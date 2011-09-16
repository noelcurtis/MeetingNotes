//
//  NotesDetailViewController.h
//  MeetingNotes
//
//  Created by Noel Curtis on 4/23/11.
//  Copyright 2011 Noel Curtis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionItemsViewController.h"

@class NotesRootViewController;
@class AgendaItem;
@class NoteView;
@class ActionItemCell;
@protocol AgendaItemTitleChangeDelegate;

@interface NotesDetailViewController : UITableViewController<UITextFieldDelegate, UITextViewDelegate, ActionItemsViewControllerDelegate> {
    
    UITableViewCell *actionHeaderCell;
    UITableViewCell *notesHeaderCell;
}

@property(nonatomic, retain)IBOutlet UITableViewCell* agendaItemTitleCell;
@property(nonatomic, retain)IBOutlet UITextField* agendaItemTitleTextField;
@property(nonatomic, retain)IBOutlet UITableViewCell* customNotesTextViewCell;
@property(nonatomic, retain)IBOutlet ActionItemCell *actionItemCell;
@property(nonatomic, retain)IBOutlet NoteView* noteView;
@property (nonatomic, retain) IBOutlet UITableViewCell *actionHeaderCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *notesHeaderCell;

// From the root view controller
@property(nonatomic, retain)NotesRootViewController* notesRootViewController;
@property(nonatomic, retain)AgendaItem* agendaItem;
@property (nonatomic, assign) id<AgendaItemTitleChangeDelegate> agendaItemTitleChangeDelegate;

// custom headers
@property (nonatomic, retain)IBOutlet UIView *notesHeaderView;
@property (nonatomic, retain)IBOutlet UIView *actionHeaderView;

// for the detail view
@property (nonatomic, retain) UIBarButtonItem *newActionItemButton;

-(UITableViewCell *) configureCellAtIndexPath:(NSIndexPath *)indexPath;
-(void) setupDetailViewWithAgendaItem:(AgendaItem*) selectedAgendaItem;

// Button actions
-(IBAction) newActionItemAction:(id)sender;

// Test with the tool bar
@property (nonatomic, retain)IBOutlet UIToolbar* detailViewControllerToolbar;

// Satisfy the ActionItemsViewControllerDelegate
-(void) dismissActionItemsViewController;

@end


@protocol AgendaItemTitleChangeDelegate
    -(void)agendaTitleDidChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
@end