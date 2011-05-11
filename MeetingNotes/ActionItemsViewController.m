//
//  ActionItemsViewController.m
//  MeetingNotes
//
//  Created by Noel Curtis on 5/8/11.
//  Copyright 2011 EMC Corporation. All rights reserved.
//

#import "ActionItemsViewController.h"
#import "ActionItem.h"

@interface ActionItemsViewController()
-(UITableViewCell *) configureCellAtIndexPath:(UITableViewCell*)cell atIndexPath:(NSIndexPath *)indexPath;
@property (nonatomic, retain) NSMutableArray* personsSelectedFromPeoplePicker;
@end

@implementation ActionItemsViewController

@synthesize actionItem;
@synthesize actionableAttendees;
@synthesize actionItemNoteCell;
@synthesize personsSelectedFromPeoplePicker;

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
    [personsSelectedFromPeoplePicker release];
    [actionItemNoteCell release];
    [actionableAttendees release];
    [actionItem release];
    [super dealloc];
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
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    // Done Button
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
																							target:self 
																							action:@selector(addActionableAttendeesAction:)] autorelease];
    self.title = @"Add Action Item";
    
    // setup the current actionable attendees in this action item
    self.actionableAttendees = [[NSMutableArray alloc] initWithArray:[self.actionItem.Attendees allObjects]];
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
    switch (section) {
        case 0:
            return 1;
            break;
            
        case 1:
            return [self.actionableAttendees count];
            break;
            
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"AttendeeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    // Configure the cell...
    
    return [self configureCellAtIndexPath:cell atIndexPath:indexPath];
}

-(UITableViewCell *) configureCellAtIndexPath:(UITableViewCell*)cell atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return self.actionItemNoteCell;
    }
    else if(indexPath.section == 1){
        cell.textLabel.text = [self.actionableAttendees objectAtIndex:indexPath.row];
        return cell;
    }
    else{
        NSLog(@"There is no cell for indexPath row=%@ section=%@", indexPath.row, indexPath.section);
        NSException *exception = [NSException exceptionWithName:@"NoCell" reason:@"There is no table view cell for this indexPath" userInfo:nil];
        @throw exception;
    }    
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
    switch (indexPath.section) {
        case 0:
            break;
        case 1:
            if ([[self.tableView cellForRowAtIndexPath:indexPath ] accessoryType] == UITableViewCellAccessoryCheckmark)
            {
                [[self.tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];
            }
            else
            {
                [[self.tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
            }

            break;
        default:
            break;
    }
}

#pragma mark - Adding new Actionable Attendees
-(IBAction) addActionableAttendeesAction:(id)sender{
    NSLog(@"Add actionable attendees items button pressed.");
    
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.modalInPopover = TRUE;
    picker.modalPresentationStyle = UIModalPresentationCurrentContext;
    //picker.view.frame.size = self.view.frame.size;
    picker.peoplePickerDelegate = self;
    // Display only a person's phone, email, and birthdate
	/*NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty], 
                               [NSNumber numberWithInt:kABPersonEmailProperty],
                               [NSNumber numberWithInt:kABPersonBirthdayProperty], nil];
	
	
	picker.displayedProperties = displayedItems;*/
	// Show the picker
    [self.navigationController presentModalViewController:picker animated:YES];
	[picker release];	

}

#pragma mark ABPeoplePickerNavigationControllerDelegate methods
// Displays the information of a selected person
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
	if(personsSelectedFromPeoplePicker == nil){
        personsSelectedFromPeoplePicker = [[NSMutableArray alloc] init];
    }else{
        NSString *firstName = (NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        NSString *lastName = (NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
        [personsSelectedFromPeoplePicker addObject:[NSString stringWithFormat:firstName,@" ",lastName]];
    }
    [self.actionableAttendees addObjectsFromArray:self.personsSelectedFromPeoplePicker];
    [self.navigationController dismissModalViewControllerAnimated:YES];
    [self.tableView reloadData];
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
	[personsSelectedFromPeoplePicker release];
    [self.navigationController dismissModalViewControllerAnimated:YES];
}



@end
