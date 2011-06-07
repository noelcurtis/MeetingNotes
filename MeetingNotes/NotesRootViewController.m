//
//  NotesRootViewController.m
//  MeetingNotes
//
//  Created by Noel Curtis on 4/23/11.
//  Copyright 2011 Noel Curtis. All rights reserved.
//

#import "NotesRootViewController.h"
#import "Meeting.h"
#import "AgendaItem.h"
#import "NotesDetailViewController.h"
#import "SortDetailViewController.h"
#import "FileHandlerController.h"

@interface NotesRootViewController()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
-(void)addToolBarToView;
@end

@implementation NotesRootViewController

@synthesize meetingBeingEdited;
@synthesize notesDetailViewController;
@synthesize agendaItems;
@synthesize sortDetailViewController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [agendaItems release];
    [notesDetailViewController release];
    [meetingBeingEdited release];
    [sortDetailViewController release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Functions to update and save context

-(IBAction) addActionItem:(id)sender{
    
    // example code to create new action items
    NSManagedObjectContext *context = self.meetingBeingEdited.managedObjectContext;
    
    AgendaItem *agendaItem = [NSEntityDescription insertNewObjectForEntityForName:@"AgendaItem" inManagedObjectContext:context];
    [agendaItem setNote:@"Im a new note."];
    [agendaItem setTitle:@"New Agenda Item"];
    [self.meetingBeingEdited addAgendaItemsObject:agendaItem];    
    NSError *error = nil;
    if (![context save:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    NSLog(@"Added AgendaItem to meeting, current count for agenda items is %@", [NSNumber numberWithInteger:[self.meetingBeingEdited.AgendaItems count]]);
    [self.agendaItems release];
    self.agendaItems = [[NSMutableArray alloc] initWithArray:[self.meetingBeingEdited.AgendaItems allObjects]];
    NSUInteger positionOfNewAgendaItem = [self.agendaItems indexOfObject:agendaItem];
    [agendaItem release];
    [self.tableView reloadData];
    
    NSIndexPath *indexOfNewAgendaItem = [NSIndexPath indexPathForRow:positionOfNewAgendaItem inSection:0];
    [self tableView:self.tableView didSelectRowAtIndexPath:indexOfNewAgendaItem];
    
}

-(void)saveContextAndReloadTable{
    NSManagedObjectContext *context = self.meetingBeingEdited.managedObjectContext;
    NSError *error = nil;
    if (![context save:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    // release the old agenda items
    [self.agendaItems release];
    self.agendaItems = [[NSMutableArray alloc] initWithArray:[self.meetingBeingEdited.AgendaItems allObjects]];
    [self.tableView reloadData];
    // ?? how do I make sure that the agenda item that was just updated is selected....
}

#pragma mark - Meeting options to allow to print PDFs, send email and view meeting details

- (IBAction)optionsSegmentAction:(id)sender
{
	// The segmented control was clicked, handle it here 
	UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
	NSLog(@"Segment clicked: %d", segmentedControl.selectedSegmentIndex);
    
	switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            segmentedControl.selectedSegmentIndex = -1;
            // create a .txt file with the meeting notes
            FileHandlerController *fileHandlerController = [[FileHandlerController alloc] init];
            [fileHandlerController exportMeetingToFile:self.meetingBeingEdited];
            //[fileHandlerController release];
            break;
        /*case 1:
            NSLog(@"Segment clicked: %d", segmentedControl.selectedSegmentIndex);
            [self addActionableAttendeesAction];
            segmentedControl.selectedSegmentIndex = -1;
            break;
        case 2:
            NSLog(@"Segment clicked: %d", segmentedControl.selectedSegmentIndex);
            segmentedControl.selectedSegmentIndex = -1;
            [self done:sender];
            break;  */         
        default:
            break;
    }

}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(self.meetingBeingEdited == nil)
    {
        NSException *exception = [NSException exceptionWithName:@"NoMeetingToEdit" reason:@"You did not give me a meeting to edit." userInfo:nil];
        @throw exception;
    }
    self.title = self.meetingBeingEdited.name;
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
																							target:self 
																							action:@selector(addActionItem:)] autorelease];
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonSystemItemRewind target:self action:@selector(backButtonAction:)] autorelease];
    self.navigationItem.hidesBackButton = YES;
    self.agendaItems = [[NSMutableArray alloc] initWithArray:[self.meetingBeingEdited.AgendaItems allObjects]];
    [self addToolBarToView];
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
}

-(IBAction)backButtonAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
    // replace the detail view in the split view controller
    NSLog(@"Replacing the detail view with the MeetingListViewController");
    [self.sortDetailViewController setupWithMeetingListViewController];
}

-(void)addToolBarToView{
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    toolbar.barStyle = UIBarStyleDefault;
    [toolbar sizeToFit];
    //Caclulate the height of the toolbar
    CGFloat toolbarHeight = [toolbar frame].size.height;
    
    //Get the bounds of the parent view
    CGRect rootViewBounds = self.parentViewController.view.bounds;
    
    //Get the height of the parent view.
    CGFloat rootViewHeight = CGRectGetHeight(rootViewBounds);
    
    //Get the width of the parent view,
    CGFloat rootViewWidth = CGRectGetWidth(rootViewBounds);
    
    //Create a rectangle for the toolbar
    CGRect rectArea = CGRectMake(0, (rootViewHeight-toolbarHeight), rootViewWidth, toolbarHeight);
    
    //Reposition and resize the receiver
    [toolbar setFrame:rectArea];
    
    //Add buttons to the toolbar
    NSArray *itemArray = [NSArray arrayWithObjects: @"PDF", @"Email", @"Meeting", nil];
    
    UISegmentedControl *meetingOptions = [[UISegmentedControl alloc] initWithItems:itemArray];
    meetingOptions.tintColor = [UIColor darkGrayColor];
    meetingOptions.segmentedControlStyle = UISegmentedControlStyleBezeled;
    [meetingOptions addTarget:self action:@selector(optionsSegmentAction:) forControlEvents:UIControlEventValueChanged];
    meetingOptions.frame = CGRectMake(0, 0, 200, 30);
    UIBarButtonItem *optionsButton = [[UIBarButtonItem alloc] initWithCustomView:meetingOptions];
    UIBarButtonItem *flex1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *flex2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolbar setItems:[NSArray arrayWithObjects:flex1, optionsButton, flex2, nil]];
    [meetingOptions release];
    [flex1 release];
    [flex2 release];
    [self.navigationController.view addSubview:toolbar];
    [toolbar release];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // display the detail view controller with the fist agenda item when the Notes view controllers are shown at first
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    if([self.agendaItems count] >= 1)
    {
        [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
    }
    [indexPath release];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section==0) {
        return [self.agendaItems count];
    }
    else return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    AgendaItem *currentItem = [self.agendaItems objectAtIndex:indexPath.row];
    cell.textLabel.text = currentItem.title;
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    // If the row is within the range of the number of ingredients for the current recipe, then configure the cell to show the ingredient name and amount.
    static NSString *agendaItemsIdentifier = @"AgendaItemCell";
    
    cell = [self.tableView dequeueReusableCellWithIdentifier:agendaItemsIdentifier];
    
    if (cell == nil) {
        // Create a cell to display an ingredient.
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:agendaItemsIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    AgendaItem *currentItem = [self.agendaItems objectAtIndex:indexPath.row];
    cell.textLabel.text = currentItem.title;
    [currentItem release];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSString *title = nil;
    switch (section) {
        case 0:
            title = @"Agenda Items";
            break;
        
        default:
            break;
    }
    return title;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Deleting at index path:%@", [indexPath description]);
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"Deleting agenta item %@", [[self.agendaItems objectAtIndex:indexPath.row] description]);
        [[self.meetingBeingEdited managedObjectContext] deleteObject:[self.agendaItems objectAtIndex:indexPath.row]];
        NSManagedObjectContext *context = self.meetingBeingEdited.managedObjectContext;
        NSError *error = nil;
        if (![context save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        self.agendaItems = nil;
        self.agendaItems = [[NSMutableArray alloc] initWithArray:[self.meetingBeingEdited.AgendaItems allObjects]];
        [self.tableView reloadData];
        if([self.meetingBeingEdited.AgendaItems count] > 0){
            NSInteger newRow;
            if(indexPath.row == [self.agendaItems count]){
                newRow = indexPath.row - 1;
            }else{
                newRow = indexPath.row;
            }
            NSIndexPath *newSelectedIndex = [NSIndexPath indexPathForRow:newRow inSection:indexPath.section];
            [self.tableView selectRowAtIndexPath:newSelectedIndex animated:YES scrollPosition:UITableViewScrollPositionTop];
            [self tableView:self.tableView didSelectRowAtIndexPath:newSelectedIndex];
            [newSelectedIndex release];
        }else{
            [self.sortDetailViewController hideActiveViewController];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    // setup the detail view with the selected agenda item
    if (self.sortDetailViewController.isActiveViewControllerHidden) {
        [self.sortDetailViewController showActiveViewController];
    }
    [self.notesDetailViewController setupDetailViewWithAgendaItem:[self.agendaItems objectAtIndex:indexPath.row]];
}

@end
