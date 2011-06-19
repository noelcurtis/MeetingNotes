//
//  SortDetailViewController.m
//  MeetingNotes
//
//  Created by Noel Curtis on 4/18/11.
//  Copyright 2011 Noel Curtis. All rights reserved.
//

#import "SortDetailViewController.h"
#import "SortRootViewController.h"
#import "NotesRootViewController.h"
#import "NotesDetailViewController.h"
#import "MeetingListViewController.h"
#import "DropboxSDK.h"
#import "SettingsViewController.h"
#import "EventsViewController.h"

@interface SortDetailViewController()
@property(nonatomic, retain) UINavigationController* settingsNavigationController;
@end

@implementation SortDetailViewController

@synthesize toolBar;
@synthesize rvController;
@synthesize rootViewPopover;
@synthesize activeViewController;
@synthesize managedObjectContext;
@synthesize createMinutePopoverController;
@synthesize calenderCreatePopover;
@synthesize isActiveViewControllerHidden;
@synthesize settingsNavigationController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [settingsNavigationController release];
    [calenderCreatePopover release];
    [createMinutePopoverController release];
    [managedObjectContext release];
    [activeViewController release];
    [rootViewPopover release];
    [rvController release];
    [toolBar release];
    [super dealloc];
}

#pragma mark - Managing the active detail view
-(void) setupToolbarForMeetingListViewController{
    
    NSMutableArray *currentItems = [[self.toolBar items] mutableCopy];
       
    UIBarButtonItem *calenderButton = [[UIBarButtonItem alloc]  initWithImage:[UIImage imageNamed:@"icon_calendar"] style:
                                       UIBarButtonItemStylePlain target:self action:@selector(calenderButtonClick:)];
    UIBarButtonItem *addMeetingButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonPressed:)];
    
    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *applicationSettingsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_settings.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(didPressSettingsButton:)];
    
    NSMutableArray *items;
    if([currentItems count]==5)
    {
        [[currentItems objectAtIndex:0] setTitle:@"Categories"];
        items = [NSMutableArray arrayWithObjects: [currentItems objectAtIndex:0] ,flexButton, applicationSettingsButton, calenderButton, addMeetingButton, nil];
    }else{
        items = [NSMutableArray arrayWithObjects:flexButton, applicationSettingsButton, calenderButton, addMeetingButton, nil];
    }
    [self.toolBar setItems:items];
    [calenderButton release];
    [flexButton release];
    [addMeetingButton release];
    [currentItems release];
}

-(void) setupWithMeetingListViewController{
    MeetingListViewController *meetingsList = [[MeetingListViewController alloc] initWithNibName:@"MeetingListViewController" bundle:nil];
    meetingsList.masterSortDetailView = self;
    meetingsList.masterSortRootView = self.rvController;
    [self setupWithActiveViewController:meetingsList];
    [meetingsList release];
}

// Use to change the active sub view controller in the Detail view
-(void) setupWithActiveViewController:(UIViewController*) controller
{
    [self.activeViewController.view removeFromSuperview];
	self.activeViewController = controller;
    // Customize the size of the frame so that the toolbar is not hidden.
	CGRect r = CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height);
	self.activeViewController.view.frame = r;
    [self.activeViewController viewWillAppear:NO];
	[self.view addSubview:self.activeViewController.view];
	[self.activeViewController viewDidAppear:NO];
    self.isActiveViewControllerHidden = NO;
}

// Use to completely remove the active view controller
-(void) hideActiveViewController{
    [self.activeViewController.view removeFromSuperview];
    self.isActiveViewControllerHidden = YES;
}

-(void) showActiveViewController{
    [self.activeViewController viewWillAppear:NO];
    [self.view addSubview:self.activeViewController.view];
    [self.activeViewController viewDidAppear:NO];
    self.isActiveViewControllerHidden = NO;
}

#pragma mark - Showing the Notes view
// The add button is attached to this action
// Push the NotesView controllers when the add button is pressed
-(IBAction) addButtonPressed:(id) sender
{
    // make sure you dissmiss the popover if one already exsits
    if (self.createMinutePopoverController.popoverVisible == YES){
        [self.createMinutePopoverController dismissPopoverAnimated:YES]; 
    }else{
    
    // create a view to enter a meeting manually
    CreateMinutesViewController *createMinutesVC = [[CreateMinutesViewController alloc] initWithNibName:@"CreateMinutesView" bundle:nil];
    createMinutesVC.managedObjectContext = self.managedObjectContext;
    createMinutesVC.delegate = self;
    
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:createMinutesVC];
	createMinutePopoverController = [[UIPopoverController alloc] initWithContentViewController:navigationController];
	createMinutePopoverController.delegate = self;
    CGSize size = {320, 390};
    [createMinutePopoverController setPopoverContentSize:size];
    [createMinutePopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	
	[navigationController release];
	[createMinutesVC release];
    }
}

#pragma mark - CalendarView show method

-(IBAction)calenderButtonClick:(id)sender{
    if (self.calenderCreatePopover.popoverVisible == YES){
        [self.calenderCreatePopover dismissPopoverAnimated:YES]; 
    }else{
        EventsViewController *eventsViewController = [[EventsViewController alloc] initWithNibName:@"EventsViewController" bundle:nil];
        UINavigationController *eventsNavigationController = [[UINavigationController alloc] initWithRootViewController:eventsViewController];
        
        eventsViewController.calenderEventSelectedDelegate = self;
        self.calenderCreatePopover = [[UIPopoverController alloc]
                                  initWithContentViewController:eventsNavigationController];
        CGSize size = {320, 390};
        self.calenderCreatePopover.popoverContentSize = size;
        [self.calenderCreatePopover presentPopoverFromBarButtonItem:sender 
                                       permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        [eventsViewController release];
        [eventsNavigationController release];
    }
}

#pragma mark -
#pragma mark CreateMinutesModalViewControllerDelegate

- (void)didDismissModalView {
	//[self dismissModalViewControllerAnimated:YES];	
	[createMinutePopoverController dismissPopoverAnimated:YES];
}

-(void) insertNewMeeting:(Meeting *)newMeeting{
    [createMinutePopoverController dismissPopoverAnimated:YES];
    [(MeetingListViewController*)self.activeViewController insertNewMeeting:newMeeting];
}

#pragma mark -CalendarEventSelectedDelegate
-(void) insertMeeting:(EKEvent *)event{
    [(MeetingListViewController*)self.activeViewController insertNewMeetingWithEvent:event];
}

-(void) didDismissEventsViewController{
    [self.calenderCreatePopover dismissPopoverAnimated:YES];
}

#pragma mark- Push the Meeting Notes View Controllers

// Use method to push Meeting Notes View Controller with a meeting to edit
-(void) pushMeetingNotesViewControllers:(Meeting *)meetingToEdit
{
    // Push the controllers for the Notes Editing views
    // Create the notes root view controller
    NotesRootViewController *notesRVController = [[NotesRootViewController alloc] initWithNibName:@"NotesRootViewController" bundle:nil];
    // Add self to the controller so that you can push it back in future
    notesRVController.sortDetailViewController = self;
    // Create the detail view controller
    NotesDetailViewController *notesDetailView = [[NotesDetailViewController alloc] initWithNibName:@"NotesDetailViewController" bundle:nil];
    notesRVController.notesDetailViewController = notesDetailView;
    notesDetailView.notesRootViewController = notesRVController;
    // setup the meeting to edit in the root view controler
    notesRVController.meetingBeingEdited = meetingToEdit;
    
    // get the navigation controller from the SplitView Controller
    UINavigationController *navController = [self.splitViewController.viewControllers objectAtIndex:0];
    // push the NotesRootView Controller
    [navController pushViewController:notesRVController animated:YES];
    [notesRVController release];
    // push the new detail view controller
    // pass the toolbar on so the new detail view can edit it
    notesDetailView.detailViewControllerToolbar = self.toolBar;
    [self setupWithActiveViewController:notesDetailView];
    if([meetingToEdit.AgendaItems count]==0){
        [self hideActiveViewController];
    }
    [notesDetailView release];
}

#pragma mark -
#pragma mark Popover Delegate

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController {
	if (popoverController == createMinutePopoverController) {
		return NO;
	}
	return YES;
}


#pragma mark - SplitViewController delegate methods

-(void) splitViewController:(UISplitViewController *)svc 
     willHideViewController:(UIViewController *)aViewController 
          withBarButtonItem:(UIBarButtonItem *)barButtonItem 
       forPopoverController:(UIPopoverController *)pc{
    
    //barButtonItem.title = aViewController.title;  // set the title for the button
    if ([self.activeViewController isKindOfClass:[MeetingListViewController class]]) {
        barButtonItem.title = aViewController.title;
    }else{
        barButtonItem.title = @"Agenda Items";
    }
    NSMutableArray *items = [[self.toolBar items] mutableCopy];
    NSMutableArray *newItems = [NSMutableArray arrayWithObject:barButtonItem];
    [newItems addObjectsFromArray:items];
    [self.toolBar setItems:newItems // setup bar button item for toolbar
                  animated:YES];
    [items release];
    self.rootViewPopover = pc;    
}

-(void) splitViewController:(UISplitViewController *)svc 
     willShowViewController:(UIViewController *)aViewController 
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem{
    
    NSMutableArray *items = [[toolBar items] mutableCopy];
    [items removeObject:barButtonItem];
    [toolBar setItems:items animated:YES];
    [items release];
    self.rootViewPopover = nil;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];    // Do any additional setup after loading the view from its nib.
    //show a list of all the current meetings
    [self setupWithMeetingListViewController];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - Application Settings

-(IBAction) didPressSettingsButton:(id)sender{
    
    SettingsViewController *settingsVC = [[SettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
    settingsVC.settingsViewControllerDelegate = self;
    self.settingsNavigationController = [[UINavigationController alloc] initWithRootViewController:settingsVC];
    [self.settingsNavigationController setModalPresentationStyle:UIModalPresentationFormSheet];
    [self presentModalViewController:self.settingsNavigationController animated:YES];
    [settingsVC release];
    [self.settingsNavigationController release];
}

#pragma mark - Satisfying SettingsViewController Delegate

-(void) dismissSettingsViewController{
    [self.settingsNavigationController dismissModalViewControllerAnimated:YES];
}

@end
