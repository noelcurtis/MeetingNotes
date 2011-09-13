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
#import "AgendaItemCell.h"
#import "SortRootViewController.h"
#import "MeetingNotesAppDelegate.h"

@interface NotesRootViewController()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)selectCellAtIndexPath:(NSIndexPath*) indexPath;
@end

@implementation UIBarButtonItem(ButtonWithImage)
// use to make a custom button...
+ (UIBarButtonItem*)barItemWithImage:(UIImage*)image target:(id)target action:(SEL)action{
    // Move your item creation code here
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    
    button.frame= CGRectMake(0.0, 0.0, image.size.width, image.size.height);
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIView *v=[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, image.size.width, image.size.height) ];
    
    [v addSubview:button];
    
    return [[UIBarButtonItem alloc] initWithCustomView:v];
}
@end

@implementation NotesRootViewController

@synthesize meetingBeingEdited;
@synthesize notesDetailViewController;
@synthesize agendaItems;
@synthesize sortDetailViewController;
@synthesize agendaItemCell;
@synthesize currentSelectedCell;

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
    [currentSelectedCell release];
    [agendaItemCell release];
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

-(IBAction) addAgendaItem:(id)sender{
    
    // example code to create new action items
    NSManagedObjectContext *context = [(MeetingNotesAppDelegate*)[UIApplication sharedApplication].delegate managedObjectContext];
    
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
    [self.agendaItems addObject:agendaItem];
    NSIndexPath *newAgendaItemIndex = [NSIndexPath indexPathForRow:[self.agendaItems count] -1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newAgendaItemIndex] withRowAnimation:UITableViewRowAnimationTop];
    [self tableView:self.tableView didSelectRowAtIndexPath:newAgendaItemIndex];
    
    [TestFlight passCheckpoint:@"Added agenda item."];
}

-(void)saveContextAndReloadTableWithNewAgendaItem:(AgendaItem*)newAgendaItem{
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
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // setup navigation bar
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
																							target:self 
																							action:@selector(addAgendaItem:)] autorelease];
    
    UIImage *backButtonImage = [UIImage imageNamed:@"btn_back"];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barItemWithImage:backButtonImage target:self action:@selector(backButtonAction:)];
    self.navigationItem.hidesBackButton = YES;
    
    // setup meeting being edited
    if(self.meetingBeingEdited == nil)
    {
        NSException *exception = [NSException exceptionWithName:@"NoMeetingToEdit" reason:@"You did not give me a meeting to edit." userInfo:nil];
        @throw exception;
    }
    self.title = self.meetingBeingEdited.name;
    self.agendaItems = [[NSMutableArray alloc] initWithArray:[self.meetingBeingEdited.AgendaItems allObjects]];
    self.currentSelectedCell = nil;
    [self setContentSizeForViewInPopover:CGSizeMake(320.0, 704.0)];
}

-(IBAction)backButtonAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
    // replace the detail view in the split view controller
    NSLog(@"Replacing the detail view with the MeetingListViewController");
    [self.sortDetailViewController setupWithMeetingListViewController];
    [self.sortDetailViewController.rvController selectRowForCategory:self.meetingBeingEdited.Category];
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
    UIImageView *backgroundImageView = [self.navigationController.view.subviews objectAtIndex:0];
    if(backgroundImageView){
        [backgroundImageView removeFromSuperview];
    }
    if(self.view.frame.size.height == 1004.0 || self.view.frame.size.height == 741.0){
        [self.tableView setContentInset:UIEdgeInsetsMake(5.0, 0.0, 0.0, 0.0)];
        [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
        backgroundImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 37, 320, 704)] autorelease];
        backgroundImageView.image = [UIImage imageNamed:@"cat_view_bg_p"];
    }else{
        [self.tableView setContentInset:UIEdgeInsetsMake(50.0, 0.0, 0.0, 0.0)];
        [self.navigationController.navigationBar setBackgroundColor:[UIColor blackColor]];
        backgroundImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(22, 44, 276, 704)] autorelease];
        backgroundImageView.image = [UIImage imageNamed:@"cat_view_bg_l"];
    }
    [self.navigationController.view insertSubview:backgroundImageView atIndex:0];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // Uncomment the following line to preserve selection between presentations.
    //self.clearsSelectionOnViewWillAppear = NO;
    //display the detail view controller with the fist agenda item when the Notes view controllers are shown at first
    
    if(!currentSelectedCell){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        if([self.agendaItems count] >= 1)
        {
            [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
        }
    }
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


-(void)selectCellAtIndexPath:(NSIndexPath*) indexPath{
    if(self.currentSelectedCell){
        // reset the arrow of the old selected cell to hidded
        self.currentSelectedCell.redArrow.hidden = YES;
    }
    // update the current selected cell
    self.currentSelectedCell = (AgendaItemCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    self.currentSelectedCell.redArrow.hidden = NO;
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 54;
    return height;
}

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
    static NSString *CellIdentifier = @"AgendaItemsCell";
    AgendaItemCell *cell = (AgendaItemCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"AgendaItemCell" owner:self options:nil];
        cell = self.agendaItemCell;
        self.agendaItemCell = nil;
    }
    
    // Configure the cell...
    AgendaItem *currentItem = [self.agendaItems objectAtIndex:indexPath.row];
    [cell setupWithAgendaItem:currentItem];
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
    NSManagedObjectContext *context = [(MeetingNotesAppDelegate*)[UIApplication sharedApplication].delegate managedObjectContext];
    NSLog(@"Deleting at index path:%@", [indexPath description]);
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        AgendaItem* agendaItemToDelete = [self.agendaItems objectAtIndex:indexPath.row];
        NSLog(@"Deleting agenta item %@", [agendaItemToDelete description]);
        // remove object for the agendaItems array first
        [self.agendaItems removeObjectAtIndex:indexPath.row];
        // delete the object from the context
        [self.meetingBeingEdited removeAgendaItemsObject:agendaItemToDelete];
        NSError *error = nil;
        if (![context save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        //self.agendaItems = nil;
        //self.agendaItems = [[NSMutableArray alloc] initWithArray:[self.meetingBeingEdited.AgendaItems allObjects]];
        //[self.tableView reloadData];
        // delete the row
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
        
        if([self.meetingBeingEdited.AgendaItems count] > 0){
            NSInteger newRow;
            if(indexPath.row == [self.agendaItems count]){
                newRow = indexPath.row - 1;
            }else{
                newRow = indexPath.row;
            }
            NSIndexPath *newSelectedIndex = [NSIndexPath indexPathForRow:newRow inSection:indexPath.section];
            [self tableView:self.tableView didSelectRowAtIndexPath:newSelectedIndex];
        }else{
            self.notesDetailViewController.newActionItemButton.enabled = NO;
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
    [self selectCellAtIndexPath:indexPath];
    // setup the detail view with the selected agenda item
    if (self.sortDetailViewController.isActiveViewControllerHidden) {
        [self.sortDetailViewController showActiveViewController];
    }
    [self.notesDetailViewController setupDetailViewWithAgendaItem:[self.agendaItems objectAtIndex:indexPath.row]];
}

#pragma mark - AgendaItemTitleChangeDelegate
-(void) agendaTitleDidChangeCharactersInRange:(NSRange)range 
                            replacementString:(NSString *)string{
    AgendaItemCell *selectedCell = [self currentSelectedCell];
    NSString *currentLabelText = selectedCell.agendaItemLabel.text;
    currentLabelText = [currentLabelText stringByReplacingCharactersInRange:range withString:string];
    [selectedCell.agendaItemLabel setText:currentLabelText];
}

@end
