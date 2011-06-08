//
//  NotesDetailViewController.m
//  MeetingNotes
//
//  Created by Noel Curtis on 4/23/11.
//  Copyright 2011 Noel Curtis. All rights reserved.
//

#import "NotesDetailViewController.h"
#import "AgendaItem.h"
#import "NotesRootViewController.h"
#import "SortDetailViewController.h"
#import "ActionItemsViewController.h"
#import "NoteView.h"
#import "ActionItemCell.h"
#import "ActionItem.h"

@interface NotesDetailViewController()
- (void)configureButtonsForToolbar;
@property (nonatomic, retain) UIPopoverController* agendaItemPopoverController;
@end

@implementation NotesDetailViewController

@synthesize agendaItem;
@synthesize agendaItemTitleTextField, agendaItemTitleCell;
@synthesize notesRootViewController;
@synthesize detailViewControllerToolbar;
@synthesize agendaItemPopoverController;
@synthesize noteView;
@synthesize customNotesTextViewCell;
@synthesize actionItemCell;

- (id)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc{
    [actionItemCell release];
    [customNotesTextViewCell release];
    [noteView release];
    [agendaItemPopoverController release];
    [detailViewControllerToolbar release];
    [agendaItemTitleCell release];
    [agendaItemTitleTextField release];
    [notesRootViewController release];
    [agendaItem release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void) setupDetailViewWithAgendaItem:(AgendaItem *)selectedAgendaItem{
    self.agendaItem = selectedAgendaItem;
    self.noteView.text = self.agendaItem.note;
    if(self.agendaItem.title != nil){
        self.agendaItemTitleTextField.text = self.agendaItem.title;
    }
    [self.tableView  reloadData];
    NSLog(@"Setup the Notes detail view with a new AgendaItem: %@", [selectedAgendaItem.ActionItems description]);
}

- (void)viewDidLoad{
    [super viewDidLoad];
    //self.tableView.backgroundColor = [UIColor clearColor];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)configureButtonsForToolbar{
    // setup buttons on the toolbar
    NSMutableArray *items = [[self.detailViewControllerToolbar items] mutableCopy];
    UIBarButtonItem *newAgendaItemButton = [[UIBarButtonItem alloc] initWithTitle:@"Add Action Item" style:UIBarButtonItemStyleBordered target:self action:@selector(newActionItemAction:)];
    
    switch ([items count]) {
        case 4:{
            [self.detailViewControllerToolbar setItems:[NSMutableArray arrayWithObjects:[items objectAtIndex:0], [items objectAtIndex:1], newAgendaItemButton ,nil]];
            break;
        }
        case 3:{
            UIBarButtonItem *replaceFlexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            [self.detailViewControllerToolbar setItems:[NSArray arrayWithObjects:
                                                        replaceFlexButton,
                                                        newAgendaItemButton, nil] animated:YES];
            [replaceFlexButton release];
            break;
        }
        default:
            break;
    }
    [newAgendaItemButton release];
}

- (void)viewDidUnload{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self configureButtonsForToolbar];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if([self.agendaItem.ActionItems count] >0){
        return 3;
    }else{
    return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return 1;
            break;
            
        case 1:
            return 1;
            break;
        
        case 2:
            return [self.agendaItem.ActionItems count];
            break;

        default:
            NSLog(@"There are no rows for section=%@", section);
            NSException *exception = [NSException exceptionWithName:@"NoRows" reason:@"There are no rows for section." userInfo:nil];
            @throw exception;
            break;
    }
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSString *title = nil;
    switch (section) {
        case 1:
            title = @"Notes";
            break;
        case 2:
            title = @"Action Items";
            break;
        default:
            break;
    }
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self configureCellAtIndexPath:indexPath];
}

-(UITableViewCell *) configureCellAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return self.agendaItemTitleCell;
    }
    else if(indexPath.section == 1 && indexPath.row == 0){
        return self.customNotesTextViewCell;
    }
    else if(indexPath.section == 2){
        // create a new ActionItemCell if one is not dequeued
        static NSString *CellIdentifier = @"ActionItemCell";
        ActionItemCell *cell = (ActionItemCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"ActionItemCell" owner:self options:nil];
            cell = actionItemCell;
            self.actionItemCell = nil;
        }
        // get the action items and push a new ActionItemCell with one
        NSMutableArray *actionItems = [[NSMutableArray alloc] initWithArray:[self.agendaItem.ActionItems allObjects]];
        cell.actionItemLabel.text = ((ActionItem *)[actionItems objectAtIndex:indexPath.row]).notes;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [actionItems release];
        return cell;
    }
    else{
        NSLog(@"There is no cell for indexPath row=%@ section=%@", indexPath.row, indexPath.section);
        NSException *exception = [NSException exceptionWithName:@"NoCell" reason:@"There is no table view cell for this indexPath" userInfo:nil];
        @throw exception;
    }    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 50;
    if (indexPath.section == 1 && indexPath.row == 0) {
        height = 400;
    }
    else if (indexPath.section == 2) {
        height = 65;
    }
    return height;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // create a view to enter a meeting manually
    if(indexPath.section == 2){
        // get the action item for the cel that you selected
        NSLog(@"Setting up the ActionItemsViewController with a meeting and agenda item");
        ActionItemsViewController *actionItemsVC = [[ActionItemsViewController alloc] initWithNibName:@"ActionItemsViewController" bundle:nil ];
        // pass the meeting being edited along
        actionItemsVC.meetingBeingEdited = self.notesRootViewController.meetingBeingEdited;
        actionItemsVC.agendaItem = self.agendaItem;
        actionItemsVC.actionViewControllerDelegate = self;
        // setup the action item for the popover controller
        actionItemsVC.actionItem = [[self.agendaItem.ActionItems allObjects] objectAtIndex:indexPath.row];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:actionItemsVC];
        self.agendaItemPopoverController = [[UIPopoverController alloc] initWithContentViewController:navigationController];
        //self.agendaItemPopoverController.delegate = self;
        self.agendaItemPopoverController.popoverContentSize = actionItemsVC.view.frame.size;
        //[self.agendaItemPopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];rz
        [self.agendaItemPopoverController presentPopoverFromRect:[self.tableView rectForRowAtIndexPath:indexPath] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        [navigationController release];
        [actionItemsVC release];
    }

}


#pragma mark - UITextView/UITextField delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.noteView setNeedsDisplay];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"text field did begin editing");
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSLog(@"text field did change %@", string);
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"Text field did end editing, updating agenda item and saving context");
    [self.agendaItem setNote:self.noteView.text];
    [self.agendaItem setTitle:self.agendaItemTitleTextField.text];
    [self.notesRootViewController saveContextAndReloadTable];
    [textField resignFirstResponder];
    // change the current agenda item
    // save the context
    // reload the table
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    NSLog(@"Text view did end editing, updating agenda item and saving context");
    [self.agendaItem setNote:self.noteView.text];
    [self.agendaItem setTitle:self.agendaItemTitleTextField.text];
    [self.notesRootViewController saveContextAndReloadTable];
    [textView resignFirstResponder];

}

#pragma mark - Button actions
-(IBAction) newActionItemAction:(id)sender{
    NSLog(@"New action item button pressed");
    if (self.agendaItemPopoverController.popoverVisible == YES){
        [self.agendaItemPopoverController dismissPopoverAnimated:YES];
        NSLog(@"Implement any cancel code you require to cancel adding new meeting items.");
    }else{
        
        // create a view to enter a meeting manually
        NSLog(@"Setting up the ActionItemsViewController with a meeting and agenda item");
        ActionItemsViewController *actionItemsVC = [[ActionItemsViewController alloc] initWithNibName:@"ActionItemsViewController" bundle:nil ];
        // pass the meeting being edited along
        actionItemsVC.meetingBeingEdited = self.notesRootViewController.meetingBeingEdited;
        actionItemsVC.agendaItem = self.agendaItem;
        actionItemsVC.actionViewControllerDelegate = self;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:actionItemsVC];
        self.agendaItemPopoverController = [[UIPopoverController alloc] initWithContentViewController:navigationController];
        //self.agendaItemPopoverController.delegate = self;
        agendaItemPopoverController.popoverContentSize = actionItemsVC.view.frame.size;
        [agendaItemPopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        NSLog(@"Action item view conrtollers displayed.");
        [navigationController release];
        [actionItemsVC release];
    }

}

#pragma mark - ActionItemViewControllerDelegate

-(void) dismissActionItemsViewController{
    [self.agendaItemPopoverController dismissPopoverAnimated:YES];
    [self.tableView reloadData];
}

@end
