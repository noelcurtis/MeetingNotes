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
#import "SharingServiceAdapter.h"
#import "SharingViewController.h"
#import "CreateMinutesViewController.h"

//@class SharingServiceAdapter;

@interface NotesDetailViewController()<CreateMinutesModalViewControllerDelegate, UIPopoverControllerDelegate>
- (void)configureButtonsForToolbar;
@property (nonatomic, retain) UIPopoverController* sharingPopoverController;
@property (nonatomic, retain) UIPopoverController* agendaItemPopoverController;
@property (nonatomic, retain) UIBarButtonItem *meetingSettingsButton;
@property (nonatomic, retain) UIBarButtonItem *shareButton;
@property (nonatomic, retain) UIPopoverController *createMinutePopoverController;
@property (nonatomic, assign) BOOL isNotesTextViewActive;
- (void)didDismissModalView;
- (IBAction) meetingSettingsAction:(id)sender;
- (IBAction) shareAction:(id)sender;
- (void)registerForNotifications;
- (void)keyboardWasShown:(NSNotification*)aNotification;
- (void)keyboardWillBeHidden:(NSNotification*)aNotification;
//- (void)deviceDidChangeOrientation:(NSNotification*)aNotification;
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
@synthesize newActionItemButton;
@synthesize meetingSettingsButton;
@synthesize shareButton;
@synthesize sharingPopoverController;
@synthesize agendaItemTitleChangeDelegate;
@synthesize notesHeaderView;
@synthesize actionHeaderView;
@synthesize createMinutePopoverController;
@synthesize isNotesTextViewActive;

- (id)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc{
    [meetingSettingsButton release];
    [shareButton release];
    [newActionItemButton release];
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
    // do not enable the action item button unless the agenda item is set
    if(self.agendaItem){
        newActionItemButton.enabled = YES;
    }else{
        newActionItemButton.enabled = NO;
    }
    [self.tableView  reloadData];
    NSLog(@"Setup the Notes detail view with a new AgendaItem: %@", [selectedAgendaItem.ActionItems description]);
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self registerForNotifications];
    
    //
    // Create a header view. Wrap it in a container to allow us to position
    // it better.
    //
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)configureButtonsForToolbar{
    // setup buttons on the toolbar
    NSMutableArray *items = [[self.detailViewControllerToolbar items] mutableCopy];
    newActionItemButton = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"btn_add_action"] 
                                                     target:self action:@selector(newActionItemAction:)];
    
    // do not enable the action item button unless the agenda item is set
    if(self.agendaItem){
        newActionItemButton.enabled = YES;
    }else{
        newActionItemButton.enabled = NO;
    }
    //meetingSettingsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_settings.png"] 
    //                                                         style:UIBarButtonItemStyleBordered target:self action:@selector(meetingSettingsAction:)];
    
    meetingSettingsButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(meetingSettingsAction:)];
    //shareButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_action.png"] 
    //                                               style:UIBarButtonItemStyleBordered target:self action:@selector(shareAction:)];
    shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareAction:)];
    
    switch ([items count]) {
        case 5:{
            [[items objectAtIndex:0] setTitle:@"Agenda Items"];
            [self.detailViewControllerToolbar setItems:[NSMutableArray arrayWithObjects:[items objectAtIndex:0], 
                                                        [items objectAtIndex:1], meetingSettingsButton, shareButton,newActionItemButton ,nil]];
            break;
        }
        case 4:{
            UIBarButtonItem *replaceFlexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            [self.detailViewControllerToolbar setItems:[NSArray arrayWithObjects:
                                                        replaceFlexButton,meetingSettingsButton, shareButton,
                                                        newActionItemButton, nil] animated:YES];
            [replaceFlexButton release];
            break;
        }
        default:
            break;
    }
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
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
	return NO;
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

/*
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
*/
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
        [cell setupWithActionItem:(ActionItem *)[actionItems objectAtIndex:indexPath.row]];
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


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if(indexPath.section == 2){
        return YES;
    }else{
        return NO;
    }
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        ActionItem *actionItemToDelete = [[self.agendaItem.ActionItems allObjects] objectAtIndex:indexPath.row];
        [self.agendaItem removeActionItems:[NSSet setWithObject:actionItemToDelete]];
        // Save the context.
		NSError *error;
		if (![self.agendaItem.managedObjectContext save:&error]) {
			/*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.*/
             
             NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
             abort();
		}
        if ([self.agendaItem.ActionItems count] == 0) {
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
        }else{
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }  
}


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

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 1){
        return self.notesHeaderView;
    }else if(section == 2){
        return self.actionHeaderView;
    }else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 0;
    }else{
        return 29;
    }
}

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
    [textField becomeFirstResponder];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSLog(@"text field did change %@", string);
    [self.agendaItemTitleChangeDelegate agendaTitleDidChangeCharactersInRange:range replacementString:string];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"Text field did end editing, updating agenda item and saving context");
    [self.agendaItem setNote:self.noteView.text];
    [self.agendaItem setTitle:self.agendaItemTitleTextField.text];
    //[self.notesRootViewController saveContextAndReloadTable];
    [self.notesRootViewController saveContextAndReloadTableWithNewAgendaItem:self.agendaItem];
    [textField resignFirstResponder];
    // change the current agenda item
    // save the context
    // reload the table
}

-(void) textViewDidBeginEditing:(UITextView *)textView{
    NSLog(@"Text view did begin editing");
    [textView becomeFirstResponder];
    self.isNotesTextViewActive = YES;
}

-(void) textViewDidChange:(UITextView *)textView{
    NSLog(@"Text view did change");
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    NSLog(@"Text view did end editing, updating agenda item and saving context");
    [self.agendaItem setNote:self.noteView.text];
    [self.agendaItem setTitle:self.agendaItemTitleTextField.text];
    [self.notesRootViewController saveContextAndReloadTableWithNewAgendaItem:self.agendaItem];
    [textView resignFirstResponder];
    self.isNotesTextViewActive = NO;
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
        [agendaItemPopoverController presentPopoverFromBarButtonItem:newActionItemButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        NSLog(@"Action item view conrtollers displayed.");
        [navigationController release];
        [actionItemsVC release];
    }
}

-(IBAction) meetingSettingsAction:(id)sender{
    NSLog(@"Meeting settings button pressed");
    // make sure you dissmiss the popover if one already exsits
    if (self.createMinutePopoverController.popoverVisible == YES){
        [self.createMinutePopoverController dismissPopoverAnimated:YES]; 
    }else{
        
        // create a view to enter a meeting manually
        CreateMinutesViewController *createMinutesVC = [[CreateMinutesViewController alloc] initWithNibName:@"CreateMinutesView" bundle:nil];
        createMinutesVC.delegate = self;
        createMinutesVC.meetingBeingEdited = self.notesRootViewController.meetingBeingEdited;
        
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:createMinutesVC];
        createMinutePopoverController = [[UIPopoverController alloc] initWithContentViewController:navigationController];
        createMinutePopoverController.delegate = self;
        CGSize size = {320, 400};
        [createMinutePopoverController setPopoverContentSize:size];
        [createMinutePopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
        [navigationController release];
        [createMinutesVC release];
    }

    
}
-(IBAction) shareAction:(id)sender{
    NSLog((@"Share action button pressed"));
    //[[SharingServiceAdapter sharedSharingService] uploadMeetingToDropbox:self.notesRootViewController.meetingBeingEdited];
    //[[SharingServiceAdapter sharedSharingService] uploadMeetingToEvernote:self.notesRootViewController.meetingBeingEdited];
    if (self.sharingPopoverController.popoverVisible == YES){
        [self.sharingPopoverController dismissPopoverAnimated:YES];
        NSLog(@"Implement any cancel code you require to cancel adding new meeting items.");
    }else{
        
        // create a view to enter a meeting manually
        NSLog(@"Setting up the ActionItemsViewController with a meeting and agenda item");
        SharingViewController *sharingVC = [[SharingViewController alloc] initWithNibName:@"SharingViewController" bundle:nil ];
        // pass the meeting being edited along
        sharingVC.meetingToShare = self.notesRootViewController.meetingBeingEdited;
        sharingVC.navigationController.navigationBar.tintColor = [UIColor redColor];
        sharingPopoverController = [[UIPopoverController alloc] initWithContentViewController:sharingVC];
        sharingPopoverController.popoverContentSize = sharingVC.view.frame.size;
        [sharingPopoverController presentPopoverFromBarButtonItem:shareButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        NSLog(@"Sharing view controller displayed.");
        [sharingVC release];
    }
}

#pragma mark - ActionItemViewControllerDelegate

-(void) dismissActionItemsViewController{
    [self.agendaItemPopoverController dismissPopoverAnimated:YES];
    [self.tableView reloadData];
}

#pragma mark - CreateMinutesViewControllerDelegate

- (void)didDismissModalView {
	//[self dismissModalViewControllerAnimated:YES];	
	[createMinutePopoverController dismissPopoverAnimated:YES];
}

#pragma mark - Controlling the Keyboard
- (void)registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}
/*
- (void)deviceDidChangeOrientation:(NSNotification*)aNotification{
    if([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait){
        [self.noteView resignFirstResponder];
    }
}
*/
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    if(self.isNotesTextViewActive){
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{

}

@end
