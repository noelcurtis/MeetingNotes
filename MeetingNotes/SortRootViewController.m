//
//  SortRootViewController.m
//  MeetingNotes
//
//  Created by Noel Curtis on 4/18/11.
//  Copyright 2011 Noel Curtis. All rights reserved.
//

#import "SortRootViewController.h"
#import "NotesRootViewController.h"
#import "NotesDetailViewController.h"
#import "SortDetailViewController.h"
#import "SettingsViewController.h"
#import "SortViewCell.h"
#import "MeetingListViewController.h"

@interface SortRootViewController()
- (void) configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
//+ (void) setDefaultCategory:(Category*) category;
//- (void) reassignMeetingsForCategory:(Category*) category;
- (NSArray*) getAllMeetings;
@end


@implementation SortRootViewController
// default category
//static Category* defaultCategory;

@synthesize dvController;
@synthesize sortViewCell;
@synthesize managedObjectContext;
@synthesize fetchedResultsController;
@synthesize newCategoryCell;
@synthesize newCategoryTextField;
@synthesize selectedCategory;

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
    [selectedCategory release];
    [newCategoryTextField release];
    [newCategoryCell release];
    [fetchedResultsController release];
    [managedObjectContext release];
    [sortViewCell release];
    [dvController release];
    [managedObjectContext release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
/*
+ (Category*)getDefaultCategory{
    
    return defaultCategory;
}

+ (void) setDefaultCategory:(Category*) category{
    defaultCategory = category;
}
*/
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    self.title = @"Categories";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    [self.navigationController.navigationBar setBackgroundColor:[UIColor blackColor]];
    
    // select the first row after the root view controller loads
    NSLog(@"Selecting the fist category when the SortRootViewController is loaded...");
    [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 54;
    return height;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    //return [[fetchedResultsController sections] count];
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 1) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:0];
        return [sectionInfo numberOfObjects];
    }else{
        return 2;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1){
        static NSString *CellIdentifier = @"SortViewCell";
        SortViewCell *cell = (SortViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"SortViewCell" owner:self options:nil];
            cell = self.sortViewCell;
            self.sortViewCell = nil;
        }
        [self configureCell:cell atIndexPath:indexPath];
        return cell;
    }else{
        if(indexPath.row == 0){
            return self.newCategoryCell;
        }else{
            static NSString *CellIdentifier = @"AllMeetingCell";
            SortViewCell *cell = (SortViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                [[NSBundle mainBundle] loadNibNamed:@"SortViewCell" owner:self options:nil];
                cell = self.sortViewCell;
                self.sortViewCell = nil;
            }
            [cell setupCellWithString:@"All Meetings"];
            return cell;
        }
    }
}

// Use to configure a cell for this table view.
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *swapIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
    NSManagedObject *managedObject = [fetchedResultsController objectAtIndexPath:swapIndexPath];
    /*if([[((Category*) managedObject).name lowercaseString] isEqualToString:@"all meetings"]){
        [SortRootViewController setDefaultCategory:(Category*) managedObject];
    }*/
    [(SortViewCell*)cell setupCellWithCategory:(Category *)managedObject];
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1){
        // Return NO if you do not want the specified item to be editable.
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
        // Delete the managed object for the given index path
        NSIndexPath *swapIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];    
        NSManagedObject *objectToDelete = [fetchedResultsController objectAtIndexPath:swapIndexPath];
        NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
        NSLog(@"Deleting category...");
        [context deleteObject:objectToDelete];
         // Save the context.
        NSError *error;
        if (![context save:&error]) {
         /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
        }
        // select all meetings if a Category is deleted
        //[self tableView:self.tableView didDeselectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    }   
}
/*
// Use to reassign meetings to the default category when a category is deleted
-(void) reassignMeetingsForCategory:(Category *)category{
    for (Meeting* meeting in category.Meetings) {
        [meeting setCategory:[SortRootViewController getDefaultCategory]];
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

-(void) selectRowForCategory:(Category*) category{
    if(category){
        NSIndexPath *indexPathToSelect = [NSIndexPath indexPathForRow:[fetchedResultsController indexPathForObject:category].row inSection:1];
        [self tableView:self.tableView didSelectRowAtIndexPath:indexPathToSelect];
        [indexPathToSelect release];
    }else{
        [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1){
        NSIndexPath *swapIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
        self.selectedCategory = [fetchedResultsController objectAtIndexPath:swapIndexPath];
        ((MeetingListViewController*)self.dvController.activeViewController).categoryForMeetings = self.selectedCategory;
        ((MeetingListViewController*)self.dvController.activeViewController).meetingsForCategory =  [[NSMutableArray alloc] initWithArray:[self.selectedCategory.Meetings allObjects]];
        ((MeetingListViewController*)self.dvController.activeViewController).managedObjectContext = [fetchedResultsController managedObjectContext];
        [((MeetingListViewController*)self.dvController.activeViewController).tableView reloadData];
    }else{
        if(indexPath.row == 1){
            ((MeetingListViewController*)self.dvController.activeViewController).categoryForMeetings = self.selectedCategory;
            ((MeetingListViewController*)self.dvController.activeViewController).meetingsForCategory =  [[NSMutableArray alloc] initWithArray:[self getAllMeetings]];
            ((MeetingListViewController*)self.dvController.activeViewController).managedObjectContext = [fetchedResultsController managedObjectContext];
            [((MeetingListViewController*)self.dvController.activeViewController).tableView reloadData];
        }
    }
}


#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (fetchedResultsController != nil) {
        return fetchedResultsController;
    }
    
    /*
     Set up the fetched results controller.
     */
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Category" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    [aFetchedResultsController release];
    [fetchRequest release];
    [sortDescriptor release];
    [sortDescriptors release];
    
    return fetchedResultsController;
}

-(NSArray*) getAllMeetings{
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Meeting"
                                              inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    
    NSError *error = nil;
    return [managedObjectContext executeFetchRequest:request error:&error];
}


#pragma mark - Fetched results controller delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    NSIndexPath *swapIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:1];
     NSIndexPath *swapNewIndexPath = [NSIndexPath indexPathForRow:newIndexPath.row inSection:1];
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:swapNewIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:swapIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:swapIndexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:swapIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:swapNewIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

/*
 // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
 {
 // In the simplest, most efficient, case, reload the table view.
 [self.tableView reloadData];
 }
 */

#pragma mark - Add new category action
-(IBAction) addNewCategory:(id)sender{
    [self.newCategoryTextField resignFirstResponder];
    if ([self.newCategoryTextField.text length]>0 && ![[self.newCategoryTextField.text lowercaseString] isEqualToString:@"all meetings"]) {
        NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Category" inManagedObjectContext:[fetchedResultsController managedObjectContext]];
        // Set the values for the new Meeting
        [(Category*)newManagedObject setName:self.newCategoryTextField.text];
        NSError *error;
		if (![[fetchedResultsController managedObjectContext] save:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}else{
            NSLog(@"User tried to add a duplicate All Meetings");
        }
        self.newCategoryTextField.text = @"";
        //NSIndexPath *newItemIndexPath = [fetchedResultsController indexPathForObject:newManagedObject];
        //NSIndexPath *newRowIndexPath = [NSIndexPath indexPathForRow:newItemIndexPath.row inSection:newItemIndexPath.section];
        //[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newRowIndexPath] withRowAnimation:UITableViewRowAnimationTop];
        //self configureCell:<#(UITableViewCell *)#> atIndexPath:<#(NSIndexPath *)#>
        //[self.tableView reloadData];
    }
}


@end
