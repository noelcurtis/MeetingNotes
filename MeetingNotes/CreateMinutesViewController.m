//
//  CreateMinutesViewController.m
//  Notes
//
//  Created by Scott Penrose on 8/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CreateMinutesViewController.h"
#import "StartsEndsViewController.h"
#import "SelectCategorieViewController.h"
#import "Attendee.h"
#import "Meeting.h"
#import "SortRootViewController.h"

@class Meeting;
@class Attendee;
@class Category;

@interface CreateMinutesViewController()
@property (nonatomic, retain) Attendee* personSelectedFromPeoplePicker;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) Category *selectedCategory;
@end

@implementation CreateMinutesViewController

@synthesize delegate, titleTextField, locationTextField, titleCell, locationCell, startsEndsCell, attendees, personSelectedFromPeoplePicker;
@synthesize managedObjectContext;
@synthesize tableView = _tableView;
@synthesize startsDate;
@synthesize endsDate;
@synthesize startsDateLabel;
@synthesize endsDateLabel;
@synthesize dateFormatter;
@synthesize selectedCategory;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void) viewDidAppear:(BOOL)animated{
    self.startsDateLabel.text = [self.dateFormatter stringFromDate:self.startsDate];
    self.endsDateLabel.text =  [self.dateFormatter stringFromDate:self.endsDate];
    [super viewDidAppear:animated];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
    CGSize size = {320, 353};
    [self setContentSizeForViewInPopover:size];
    // setup the default category
    //self.selectedCategory = [SortRootViewController getDefaultCategory];
    
    // setup the dates
    self.dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    // setup the starts date and end dates as now
    self.startsDate = [[NSDate alloc] init];
    self.endsDate = [[NSDate alloc] initWithTimeIntervalSinceNow:60*60];
    // Done Button
	//self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
	//																						target:self 
	//																						action:@selector(done:)] autorelease];
	// Cancel Button
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
																						   target:self 
                                                                                           action:@selector(cancel:)] autorelease];
    //Add buttons to the toolbar
    NSArray *itemArray = [NSArray arrayWithObjects: @"Add", @"Contacts", @"Done", nil];

    UISegmentedControl *options = [[UISegmentedControl alloc] initWithItems:itemArray];
    options.segmentedControlStyle = UISegmentedControlStyleBezeled;
    [options addTarget:self action:@selector(optionsSegmentAction:) forControlEvents:UIControlEventValueChanged];
    options.frame = CGRectMake(0, 0, 200, 30);
    UIBarButtonItem *optionsButton = [[UIBarButtonItem alloc] initWithCustomView:options];
    self.navigationItem.rightBarButtonItem = optionsButton;
}


#pragma mark -
#pragma mark Actions

// options segment action
- (IBAction)optionsSegmentAction:(id)sender{
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    
	switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            NSLog(@"Segment clicked: %d", segmentedControl.selectedSegmentIndex);
            segmentedControl.selectedSegmentIndex = -1;
            break;
        case 1:
            NSLog(@"Segment clicked: %d", segmentedControl.selectedSegmentIndex);
            [self addActionableAttendeesAction];
            segmentedControl.selectedSegmentIndex = -1;
            break;
        case 2:
            NSLog(@"Segment clicked: %d", segmentedControl.selectedSegmentIndex);
            segmentedControl.selectedSegmentIndex = -1;
            [self done:sender];
            break;           
        default:
            break;
    }
}

// The done button was tapped, save and close Modal view
- (IBAction)done:(id)sender {
	// TODO - Check for all values
    // create the new meeting from the managed object context
    Meeting *newMeeting = [NSEntityDescription insertNewObjectForEntityForName:@"Meeting" inManagedObjectContext:self.managedObjectContext];
    NSError *error;
    // Set the values for the new Meeting
    [newMeeting setName:titleTextField.text];
    [newMeeting setLocation:locationTextField.text];
    [newMeeting addAttendees:[[NSSet alloc] initWithArray:self.attendees]];
    [newMeeting setStartDate:self.startsDate];
    [newMeeting setEndDate:self.endsDate];
    [newMeeting setCategory:self.selectedCategory];
    if (![self.managedObjectContext save:&error]) {
        
        /*Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
         abort();*/
    }
    NSLog(@"Added new Meeting with Name:%@ and Location:%@", newMeeting.name, newMeeting.location);
    [delegate insertNewMeeting:newMeeting];
    [self.delegate didDismissModalView];
}

// The cancel button was tapped, display alert letting them know they will lose changes
- (IBAction)cancel:(id)sender {
	// Alert them they will lose changes
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Discard Changes?" 
													message:@"Are you sure you want to discard changes?" 
												   delegate:self 
										  cancelButtonTitle:@"No" 
										  otherButtonTitles:nil];
	[alert addButtonWithTitle:@"Yes"];
	[alert show];
	[alert release];
}

#pragma mark - SelectCategoryViewControllerDelegate methods

-(void) didSelectCategory:(Category *)category{
    if(category != nil){
        // get new category
        self.selectedCategory = category;
    }else{
        //reset category to default category
        self.selectedCategory = nil;
    }
    [self.tableView cellForRowAtIndexPath:
     [NSIndexPath indexPathForRow:0 inSection:2]].textLabel.text
    = [NSString stringWithFormat:@"Category: %@", self.selectedCategory.name];

}

#pragma mark -
#pragma mark UIAlertView delegate methods

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	// Pressed Cancel Button
	if (buttonIndex == 0) {
		// Do nothing because they choose not to discard changes
	}
	
	// Pressed OK button
	else if (buttonIndex == 1) {
		// They choose to lose changes so close modal view
		[self.delegate didDismissModalView];
	}
}

#pragma mark -
#pragma mark Table view data source

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSString *title = nil;
    switch (section) {
        case 3:
            if([self.attendees count] > 0)
                title = @"Attendees";
            break;
            
        default:
            break;
    }
    return title;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 1;
        case 2:
            return 1;
        case 3:
            return [self.attendees count];
        default:
            return 0;
            break;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
		if (indexPath.row == 0) {
			return titleCell;
		}
		else if (indexPath.row == 1) {
			return locationCell;
		}
	}else if (indexPath.section == 1) {
		if (indexPath.row == 0) {
			return startsEndsCell;
		}
	}else if(indexPath.section == 2){
        static NSString *CellIdentifier = @"newCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        if(self.selectedCategory){
            cell.textLabel.text = [NSString stringWithFormat:@"Category: %@",self.selectedCategory.name];
        }else{
            cell.textLabel.text = [NSString stringWithFormat:@"Category: All Meetings"];
        }
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell setSelectionStyle:UITableViewCellEditingStyleNone];
        return cell;
    }
    else{
        static NSString *CellIdentifier = @"newCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        Attendee *attendeeAtIndex = [self.attendees objectAtIndex:indexPath.row];
        cell.textLabel.text = attendeeAtIndex.name;
        return cell;
    }
	NSLog(@"There is not cell for indexPath row=%@ section=%@", indexPath.row, indexPath.section);
	NSException *exception = [NSException exceptionWithName:@"NoCell" reason:@"There is no table view cell for this indexPath" userInfo:nil];
	@throw exception;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        

    }   
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // The table view should not be re-orderable.
    return NO;
}

#pragma mark ABPeoplePickerNavigationControllerDelegate methods
// Displays the information of a selected person
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    NSString *emailAddress = nil;
    NSString *firstName = (NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString *lastName = (NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    ABMultiValueRef emailRef = ABRecordCopyValue(person, kABPersonEmailProperty);
    if(emailRef!=nil && ABMultiValueGetCount(emailRef) != 0){
        emailAddress = [NSString stringWithFormat:@"%@",ABMultiValueCopyValueAtIndex(emailRef, 0)];
    }
        
    self.personSelectedFromPeoplePicker = [NSEntityDescription insertNewObjectForEntityForName:@"Attendee" inManagedObjectContext:self.managedObjectContext];
    //self.personSelectedFromPeoplePicker = [[Attendee alloc] 
    
    //Add a new name to the new attendee
    if(firstName != nil && lastName != nil){
        [self.personSelectedFromPeoplePicker setName:[NSString stringWithFormat:@"%@ %@",firstName, lastName]];
    }
    else if (firstName !=nil && lastName ==nil){
        [self.personSelectedFromPeoplePicker setName:firstName];
    }
    else if (firstName == nil && lastName != nil){
        [self.personSelectedFromPeoplePicker setName:lastName];
    }
    else if (firstName == nil && lastName == nil && emailAddress != nil){
        [self.personSelectedFromPeoplePicker setName:emailAddress];
    }
    
    //Add a new email to the new attendee
    if (emailAddress != nil){
        [self.personSelectedFromPeoplePicker setEmail:emailAddress];
    }
    
    // Add attendee to the list of attendees
    if (self.attendees == nil) {
        // initialize the attendees list
        self.attendees = [[NSMutableArray alloc] init];
        [self.attendees addObject:self.personSelectedFromPeoplePicker];
    }else{
        [self.attendees addObject:self.personSelectedFromPeoplePicker];
    }
    // save the context as new Attendee has been created
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        
        /*Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
         abort();*/
    }

    NSLog(@"New attendee %@ picked and created, to add to the attendee list.", [self.personSelectedFromPeoplePicker description]);
    [firstName release];
    [lastName release];
    [emailAddress release];
    [self.navigationController dismissModalViewControllerAnimated:YES];
    [_tableView reloadData];
    return NO;
}


// Does not allow users to perform default actions such as dialing a phone number, when they select a person property.
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person 
								property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
	return NO;
}


// Dismisses the people picker and shows the application when users tap Cancel. 
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
	[personSelectedFromPeoplePicker release];
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

#pragma mark - Adding new Actionable Attendees
-(void) addActionableAttendeesAction{
    NSLog(@"Add actionable attendees items button pressed.");
    
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.modalInPopover = TRUE;
    picker.modalPresentationStyle = UIModalPresentationCurrentContext;
    picker.peoplePickerDelegate = self;
    // Show the picker
    [self.navigationController presentModalViewController:picker animated:YES];
	[picker release];	
}




#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Selected Starts and Ends Dates
	if (indexPath.section == 1 && indexPath.row == 0) {
		[titleTextField resignFirstResponder];
		[locationTextField resignFirstResponder];
		[startsEndsCell setSelected:NO];
		
		StartsEndsViewController *startsEndsVC = [[StartsEndsViewController alloc] initWithNibName:@"StartsEndsView" bundle:nil];
		startsEndsVC.createMinutesViewControllerRef = self;
        startsEndsVC.title = @"Start & End";
        [self.navigationController pushViewController:startsEndsVC animated:YES];
		[startsEndsVC release];
	}
    if (indexPath.section == 2 && indexPath.row == 0) {
		[titleTextField resignFirstResponder];
		[locationTextField resignFirstResponder];
		
        SelectCategorieViewController *selectCatagoryVC = [[SelectCategorieViewController alloc] 
                                                           initWithNibName:@"SelectCategorieViewController" bundle:nil]; 
        selectCatagoryVC.managedObjectContext = self.managedObjectContext;
        selectCatagoryVC.selectCategoryViewControllerDelegate = self;
        [self.navigationController pushViewController:selectCatagoryVC animated:YES];
		[selectCatagoryVC release];
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	// Default height
	CGFloat height = 44;
	// Size for Starts Ends Cell
	if (indexPath.section == 1 && indexPath.row == 0) {
		height = 70;
	}
	return height;
}


#pragma mark -
#pragma mark Rotation support

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [self.dateFormatter release];
    [startsDateLabel release];
    [endsDateLabel  release];
    [endsDate release];
    [startsDate release];
    [managedObjectContext release];
    [_tableView release];
    [personSelectedFromPeoplePicker release];
    [titleTextField release];
    [locationTextField release];
    [titleCell release];
    [locationCell release];
    [startsEndsCell release];
    [attendees release];
    [super dealloc];
}


@end
