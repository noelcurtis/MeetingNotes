//
//  MeetingListViewController.m
//  MeetingNotes
//
//  Created by Noel Curtis on 4/25/11.
//  Copyright 2011 Noel Curtis. All rights reserved.
//

#import "MeetingListViewController.h"
#import "SortDetailViewController.h"
#import "SortRootViewController.h"
#import "Meeting.h"
#import "MeetingCell.h"
#import "Attendee.h"

@interface MeetingListViewController ()
- (void)configureCell:(MeetingCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (NSArray*) searchForMeetings:(NSString *) searchString;
@end

@implementation MeetingListViewController

@synthesize managedObjectContext;
@synthesize masterSortDetailView;
@synthesize meetingCell;
@synthesize meetingsForCategory;
@synthesize categoryForMeetings;
@synthesize masterSortRootView;
@synthesize filteredList;
@synthesize searchBar = _searchBar;

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
    [filteredList release];
    [masterSortRootView release];
    [categoryForMeetings release];
    [meetingCell release];
    [meetingsForCategory release];
    [masterSortDetailView release];
    [managedObjectContext release];
    [_searchBar release];
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
    CGRect bounds = self.tableView.bounds;
    bounds.origin.y = bounds.origin.y + _searchBar.bounds.size.height;
    self.tableView.bounds = bounds;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.filteredList = nil;
    self.meetingsForCategory = nil;
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
    [self.masterSortDetailView setupToolbarForMeetingListViewController];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return [self.filteredList count];
    return [self.filteredList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MeetingCell";
    MeetingCell *cell = (MeetingCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"MeetingCell" owner:self options:nil];
        cell = self.meetingCell;
        self.meetingCell = nil;
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}


- (void)configureCell:(MeetingCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Meeting *meetingAtIndex = [self.filteredList objectAtIndex:indexPath.row];
    [cell setupWithMeeting:meetingAtIndex];
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
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the managed object for the given index path
        Meeting *meetingToDelete = [self.meetingsForCategory objectAtIndex:indexPath.row];
        Category *categoryForMeeting = meetingToDelete.Category;
        [self.managedObjectContext deleteObject:meetingToDelete];
        NSLog(@"Deleting meeting: %@", [meetingToDelete description]);
        // Save the context.
		NSError *error;
		if (![self.managedObjectContext save:&error]) {
			/*
            Replace this implementation with code to handle the error appropriately.
            
            abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
            
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();*/
		}
        // reload the meetings for a category to update the expected number of rows in the table
        if(categoryForMeeting){
            self.meetingsForCategory = [NSMutableArray arrayWithArray:[categoryForMeeting.Meetings allObjects]];
        }else{
            self.meetingsForCategory = [NSMutableArray arrayWithArray:[self.masterSortRootView getAllMeetings]];
        }
        self.filteredList = self.meetingsForCategory;
        // Delete the row from the table
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 64;
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Push the Notes View Controllers in the split view
    [self.masterSortDetailView pushMeetingNotesViewControllers:[self.filteredList objectAtIndex:indexPath.row]];
}

#pragma mark - Inserting a new object
// Use to insert an Event into the database
-(void) insertNewMeeting:(Meeting *)newMeeting{
    // select the category for the new meeting
    [self.masterSortRootView selectRowForCategory:newMeeting.Category];
    // select the new meeting for that has just been added
    NSIndexPath *insertionPath = [NSIndexPath indexPathForRow:[self.filteredList indexOfObject:newMeeting] inSection:0];
    [self tableView:self.tableView didSelectRowAtIndexPath:insertionPath];
}

// Use to insert a Meeting from an EKEvent into the database
-(void) insertNewMeetingWithEvent:(EKEvent*)event{
    
    // Create a new Meeting
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Meeting" inManagedObjectContext:self.managedObjectContext];
    // Set the values for the new Meeting
    [(Meeting*)newManagedObject setName:event.title];
    if (event.location) {
        [(Meeting*)newManagedObject setLocation:event.location];
    }
    [(Meeting*)newManagedObject setStartDate:event.startDate];
    [(Meeting*)newManagedObject setEndDate:event.endDate];
    //[(Meeting*)newManagedObject setCategory:[SortRootViewController getDefaultCategory]];
    for (EKParticipant *participant in event.attendees) {
        Attendee *newAttendee = [NSEntityDescription insertNewObjectForEntityForName:@"Attendee" inManagedObjectContext:self.managedObjectContext];
        [newAttendee setName:participant.name];
        [(Meeting*)newManagedObject addAttendeesObject:newAttendee];
    }
    
    // Save the context.
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();*/
    }
    [masterSortRootView selectRowForCategory:((Meeting*)newManagedObject).Category];
}

/*
 // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
 {
 // In the simplest, most efficient, case, reload the table view.
 [self.tableView reloadData];
 }
 */


#pragma mark - searchbar delegate and handle search

-(NSArray*) searchForMeetings:(NSString *) searchString{
    NSString *searchTerm = [NSString stringWithFormat:@"*%@*", searchString];
    NSPredicate *search = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(name like[c] '%@') OR (location like[c] '%@')",searchTerm, searchTerm]];
    NSArray *meetingsFound = [self.meetingsForCategory filteredArrayUsingPredicate:search];
    return meetingsFound;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    self.filteredList = nil;
    self.filteredList = [NSMutableArray arrayWithArray:[self searchForMeetings:searchText]];
    [self.tableView reloadData];
}


-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    /*self.filteredList = nil;
    self.filteredList = [NSMutableArray arrayWithArray:[self searchForMeetings:searchBar.text]];
    [self.tableView reloadData];*/

}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self.filteredList = [NSArray arrayWithArray:self.meetingsForCategory];
    [self.tableView reloadData];
}
@end
