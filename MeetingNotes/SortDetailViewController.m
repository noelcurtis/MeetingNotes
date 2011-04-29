//
//  SortDetailViewController.m
//  MeetingNotes
//
//  Created by Noel Curtis on 4/18/11.
//  Copyright 2011 Noel Curtis. All rights reserved.
//

#import "SortDetailViewController.h"
#import "CalenderView.h"
#import "SortRootViewController.h"
#import "NotesRootViewController.h"
#import "NotesDetailViewController.h"
#import "MeetingListViewController.h"

@interface SortDetailViewController() 
    @property (nonatomic, retain)UIViewController *activeViewController;
@end

@implementation SortDetailViewController

@synthesize toolBar;
@synthesize rvController;
@synthesize rootViewPopover;
@synthesize activeViewController;
@synthesize managedObjectContext;
@synthesize createMinutePopoverController;

@synthesize calendarButton, flexButton;

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
    [createMinutePopoverController release];
    [managedObjectContext release];
    [activeViewController release];
    [calendarButton release];
    [rootViewPopover release];
    [rvController release];
    [flexButton release];
    [toolBar release];
    [super dealloc];
}

#pragma mark - Managing the active detail view
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
}

#pragma mark - Showing the Notes view
// The add button is attached to this action
// Push the NotesView controllers when the add button is pressed
-(IBAction) addButtonPressed:(id) sender
{
    // create a view to enter a meeting manually
    CreateMinutesViewController *createMinutesVC = [[CreateMinutesViewController alloc] initWithNibName:@"CreateMinutesView" bundle:nil];
	createMinutesVC.delegate = self;
    
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:createMinutesVC];
	createMinutePopoverController = [[UIPopoverController alloc] initWithContentViewController:navigationController];
	createMinutePopoverController.delegate = self;
    createMinutePopoverController.popoverContentSize = createMinutesVC.view.frame.size;
	[createMinutePopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	
	[navigationController release];
	[createMinutesVC release];
}

#pragma mark - CalendarView show method

-(IBAction)calenderButtonClick:(id)sender{
    UIViewController *calenderView = [[CalenderView alloc] init];
    UIPopoverController *calenderPopover = [[UIPopoverController alloc]
                                     initWithContentViewController:calenderView]; 
    //calenderPopover.popoverContentSize = calenderView.view.frame.size;
    [calenderPopover presentPopoverFromBarButtonItem:sender 
                     permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}

#pragma mark -
#pragma mark CreateMinutesModalViewControllerDelegate

- (void)didDismissModalView {
	//[self dismissModalViewControllerAnimated:YES];	
	[createMinutePopoverController dismissPopoverAnimated:YES];
}

- (void)insertMinuteWithTitle:(NSString *)title place:(NSString *)place {
	// Save minute
    [createMinutePopoverController dismissPopoverAnimated:YES];
	[(MeetingListViewController*)self.activeViewController insertNewMeetingWithName:title andLocation:place];
}

#pragma mark Push the Meeting Notes View Controllers

// Use method to push Meeting Notes View Controllers
-(void) pushMeetingNotesViewControllers{
    // Push the controllers for the Notes Editing views
    NotesRootViewController *notesRVController = [[NotesRootViewController alloc] initWithNibName:@"NotesRootViewController" bundle:nil];
    // get the navigation controller from the SplitView Controller
    UINavigationController *navController = [self.splitViewController.viewControllers objectAtIndex:0];
    // push the NotesRootView Controller
    [navController pushViewController:notesRVController animated:YES];
    [notesRVController release];
    [navController release];
    // push the NotesDetailView Controller
    NotesDetailViewController *notesDetailView = [[NotesDetailViewController alloc] initWithNibName:@"NotesDetailViewController" bundle:nil];
    [self setupWithActiveViewController:notesDetailView];
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
    
    barButtonItem.title = aViewController.title;  // set the title for the button
    NSMutableArray *items = [[self.toolBar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [self.toolBar setItems:items // setup bar button item for toolbar
                  animated:YES]; 
    self.rootViewPopover = pc;

    
}

-(void) splitViewController:(UISplitViewController *)svc 
     willShowViewController:(UIViewController *)aViewController 
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem{
    
    NSMutableArray *items = [[toolBar items] mutableCopy];
    [items removeObjectAtIndex:0];
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
    MeetingListViewController *meetingsList = [[MeetingListViewController alloc] initWithNibName:@"MeetingListViewController" bundle:nil];
    meetingsList.managedObjectContext = self.managedObjectContext;
    meetingsList.masterSortDetailView = self;
    [self setupWithActiveViewController:meetingsList];
    [meetingsList release];
    
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

@end
