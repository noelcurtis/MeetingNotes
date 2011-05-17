//
//  ActionItemsViewController.m
//  MeetingNotes
//
//  Created by Noel Curtis on 5/8/11.
//  Copyright 2011 EMC Corporation. All rights reserved.
//

#import "ActionItemsViewController.h"
#import "ActionItem.h"
#import "Meeting.h"
#import "Attendee.h"
#import "AgendaItem.h"

@interface ActionItemsViewController()
-(UITableViewCell *) configureCellAtIndexPath:(UITableViewCell*)cell atIndexPath:(NSIndexPath *)indexPath;
-(void)done:(id)sender;
@end

@implementation ActionItemsViewController

@synthesize agendaItem;
@synthesize actionItem;
@synthesize allAttendees;
@synthesize actionableAttendeesToAdd;
@synthesize actionItemNoteCell;
@synthesize meetingBeingEdited;
@synthesize actionableAttendeesToRemove;
@synthesize actionItemNote;

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
    [agendaItem release];
    [actionItemNote release];
    [actionableAttendeesToRemove release];
    [meetingBeingEdited release];
    [actionItemNoteCell release];
    [allAttendees release];
    [actionableAttendeesToAdd release];
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

- (void)viewDidLoad{
    
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    // Done Button
	//self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
	//																						target:self 
	//																						action:@selector(addActionableAttendeesAction:)] autorelease];
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
                                               initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                               target:self action:@selector(done:)] 
                                               autorelease];
    // setup all attendees from the meeting
    self.allAttendees = [[NSMutableArray alloc] initWithArray:[self.meetingBeingEdited.Attendees allObjects]];
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

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSString *title = nil;
    switch (section) {
        case 1:
            if([self.meetingBeingEdited.Attendees count] > 0)
                title = @"Actionable Attendees";
            break;
            
        default:
            break;
    }
    return title;
}


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
            return [self.allAttendees count];
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
        Attendee *attendee = [self.allAttendees objectAtIndex:indexPath.row];
        cell.textLabel.text = attendee.name;
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
                if(self.actionableAttendeesToRemove == nil)
                {
                    self.actionableAttendeesToRemove = [[NSMutableArray alloc] init];
                }
                // update the actionableattendees and the actionableattendeestoremove
                [self.actionableAttendeesToAdd removeObjectIdenticalTo:[self.allAttendees objectAtIndex:indexPath.row]];
                [self.actionableAttendeesToRemove addObject:[self.allAttendees objectAtIndex:indexPath.row]];
                
                NSLog((@"An actionable attendee has been de-selected for this action item"));
            }
            else
            {
                [[self.tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
                if(self.actionableAttendeesToAdd == nil)
                {
                    self.actionableAttendeesToAdd = [[NSMutableArray alloc] init];
                }
                // update the actionableattendees and the actionableattendeestoremove
                [self.actionableAttendeesToAdd addObject:[self.allAttendees objectAtIndex:indexPath.row]];
                [self.actionableAttendeesToRemove removeObjectIdenticalTo:[self.allAttendees objectAtIndex:indexPath.row]];
                
                NSLog(@"A new actionable attendee has been selected for this action item");
            }

            break;
        default:
            break;
    }
}

/*
#pragma mark - Adding new Actionable Attendees
-(IBAction) addActionableAttendeesAction:(id)sender{
    NSLog(@"Add actionable attendees items button pressed.");
    
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.modalInPopover = TRUE;
    picker.modalPresentationStyle = UIModalPresentationCurrentContext;
    //picker.view.frame.size = self.view.frame.size;
    picker.peoplePickerDelegate = self;
    // Display only a person's phone, email, and birthdate
    // Show the picker
    [self.navigationController presentModalViewController:picker animated:YES];
	[picker release];	

}

#pragma mark ABPeoplePickerNavigationControllerDelegate methods
// Displays the information of a selected person
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
	//NSString *emailAddress;
    NSString *firstName = (NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString *lastName = (NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    //ABMultiValueRef emailRef = ABRecordCopyValue(person, kABPersonEmailProperty);
    //if(emailRef!=nil && ABMultiValueGetCount(emailRef) != 0){
    //    emailAddress = [NSString stringWithFormat:@"%@",ABMultiValueCopyValueAtIndex(emailRef, 0)];
    //}
    
    self.personSelectedFromPeoplePicker = [NSEntityDescription insertNewObjectForEntityForName:@"Attendee" inManagedObjectContext:[self.meetingBeingEdited managedObjectContext]];
    
    //Add a new name to the new attendee
    if(firstName != nil && lastName != nil){
        [self.personSelectedFromPeoplePicker setName:[NSString stringWithFormat:firstName,@" ",lastName]];
    }
    else if (firstName !=nil && lastName ==nil){
        [self.personSelectedFromPeoplePicker setName:firstName];
    }
    else if (firstName == nil && lastName != nil){
        [self.personSelectedFromPeoplePicker setName:lastName];
    }
    //else if (firstName == nil && lastName == nil && emailAddress != nil){
    //    [self.personSelectedFromPeoplePicker setName:emailAddress];
    //}
    
    //Add a new email to the new attendee
    //if (emailAddress != nil){
    //    [self.personSelectedFromPeoplePicker setEmail:emailAddress];
    //}
    
    // Add attendee to the list of all attendees of the meeting
    if (self.allAttendees == nil) {
        // initialize the attendees list
        self.allAttendees = [[NSMutableArray alloc] init];
        [self.allAttendees addObject:self.personSelectedFromPeoplePicker];
    }else{
        [self.allAttendees addObject:self.personSelectedFromPeoplePicker];
    }
    // ?? should you release personSelectedFromPeoplePicker ?????????????????????????????
    
    NSLog(@"New attendee picked and created, need to add to the attendee list.");
    [firstName release];
    [lastName release];
    //[emailAddress release];
    [self.navigationController dismissModalViewControllerAnimated:YES];
    [self.tableView reloadData];
    return NO;
}


// Does not allow users to perform default actions such as dialing a phone number, when they select a person property.
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
	return NO;
}


// Dismisses the people picker and shows the application when users tap Cancel. 
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
	[personSelectedFromPeoplePicker release];
    [self.navigationController dismissModalViewControllerAnimated:YES];
}*/

#pragma mark - Done button/Update the context
-(void)done:(id)sender{
    NSLog(@"Done button pressed for Action Items view controller.");
    // setup the action item if it is not passed in
    if(!self.actionItem){
        // create an action item if there is none
        NSLog(@"Creating a new Action Item as one was not passed into the Action Item view controller");
        self.actionItem = [NSEntityDescription insertNewObjectForEntityForName:@"ActionItem" inManagedObjectContext:[self.meetingBeingEdited managedObjectContext]];
    }
    
    // add note to the action item
    self.actionItem.notes = self.actionItemNote.text;
    
    // add new actionable attendees into the action item
    for(Attendee *actionableAttendee in self.actionableAttendeesToAdd){
        if(![self.actionItem.Attendees containsObject:actionableAttendee]){
            NSLog(@"Adding new actionable attendee: %@ to the action item: %@", 
                  [actionableAttendee description], [self.actionItem description]);
            [self.actionItem addAttendeesObject:actionableAttendee];
        }
    }
    
    // remove actionable attendees that have been deselected
    for(Attendee *actionableAttendeeToRemove in self.actionableAttendeesToRemove){
        if([self.actionItem.Attendees containsObject:actionableAttendeeToRemove]){
            NSLog(@"Removing actionable attendee: %@ to the action item: %@", 
                  [actionableAttendeeToRemove description], [self.actionItem description]);
            [self.actionItem removeAttendeesObject:actionableAttendeeToRemove];
        }
    }
    
    // add the agenda item to the agenda item
    NSLog(@"Adding the new action item: %@ to the agenda item: %@", [self.actionItem description], [self.agendaItem description]);
    [self.agendaItem addActionItemsObject:self.actionItem];
    
    NSLog(@"Saving the context in the Action Items view controller.");
    // Save the context.
    NSError *error = nil;
    if (![[self.meetingBeingEdited managedObjectContext] save:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}



@end
