//
//  SettingsViewController.m
//  MeetingNotes
//
//  Created by Noel Curtis on 6/5/11.
//  Copyright 2011 EMC Corporation. All rights reserved.
//

#import "SettingsViewController.h"
#import "DropboxSDK.h"
#import "EvernoteSettingsController.h"

@interface SettingsViewController() <DBLoginControllerDelegate>
-(void) done:(id)sender;
-(IBAction) didPressLinkDropboxAccount:(id)sender;
-(IBAction) didPressLinkEvernoteAccount:(id) sender;
@property (nonatomic, retain)UINavigationController* evernoteNavController;
@end

@implementation SettingsViewController

@synthesize settingsViewControllerDelegate;
@synthesize evernoteNavController;

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
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    [self.navigationController.navigationBar setBackgroundColor:[UIColor blackColor]];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
                                               initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                               target:self action:@selector(done:)] 
                                              autorelease];
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
    self.title = @"App Settings";
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
        case 0:
            title = @"Accounts:";
            break;
        case 1:
            title = @"Other:";
            break;
        default:
            break;
    }
    return title;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    if(indexPath.section == 0){
        // Configure the cell...
        [cell.textLabel setTextAlignment:UITextAlignmentCenter];
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Dropbox Account Configuration";
                break;
            case 1:
                cell.textLabel.text = @"Evernote Account Configuration";
                break;
            case 2:
                cell.textLabel.text = @"Link Twitter Account";
                break;
            default:
                break;
        }
    }else{
        cell.textLabel.text = @"Rate the app";
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
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
    switch (indexPath.row) {
        case 0:
            [self didPressLinkDropboxAccount:[self tableView:self.tableView cellForRowAtIndexPath:indexPath]];
            break;
        case 1:
            [self didPressLinkEvernoteAccount:[self tableView:self.tableView cellForRowAtIndexPath:indexPath]];
            break;
        default:
            break;
    }
}

#pragma mark - Application Settings

-(IBAction) didPressLinkEvernoteAccount:(id) sender{
    EvernoteSettingsController *evSettingsController = [[EvernoteSettingsController alloc] initWithNibName:@"EvernoteSettingsController" bundle:nil];
    evSettingsController.evernoteSettingsViewControllerDelegate = self;
    evernoteNavController = [[UINavigationController alloc] initWithRootViewController:evSettingsController];
    evernoteNavController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentModalViewController:evernoteNavController animated:YES];
    [evernoteNavController release];
}

-(IBAction) didPressLinkDropboxAccount:(id)sender{
    if (![[DBSession sharedSession] isLinked]) {
        DBLoginController* controller = [[DBLoginController new] autorelease];
        controller.delegate = self;
        [controller presentFromController:self];
    } else {
        [[DBSession sharedSession] unlink];
        [[[[UIAlertView alloc] 
           initWithTitle:@"Account Unlinked!" message:@"Your dropbox account has been unlinked" 
           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]
          autorelease]
         show];
    }
}

#pragma mark DBLoginControllerDelegate methods

- (void)loginControllerDidLogin:(DBLoginController*)controller {
    NSLog(@"Loging to Dropbox successful");
}

- (void)loginControllerDidCancel:(DBLoginController*)controller {
    
}

-(void)done:(id)sender{
    [self.settingsViewControllerDelegate dismissSettingsViewController];
}

#pragma mark - EvernoteViewControllerDelegate

-(void) dismissEvernoteSettingsViewController{
    [self.evernoteNavController dismissModalViewControllerAnimated:YES];
}

@end
