//
//  EvernoteSettingsController.m
//  MeetingNotes
//
//  Created by Noel Curtis on 6/25/11.
//  Copyright 2011 Noel Curtis. All rights reserved.
//

#import "EvernoteSettingsController.h"
#import "SharingServiceAdapter.h"
#import "EvernoteConfig.h"

@interface EvernoteSettingsController()
- (void) done:(id)sender;
- (void) setWorking:(BOOL)working;
- (void) cancel:(id)sender;
//- (void) asyncFunction;
@end

@implementation EvernoteSettingsController

@synthesize passwordCell = _passwordCell;
@synthesize usernameCell = _usernameCell;
@synthesize notebookCell = _notebookCell;
@synthesize usernameTextView = _usernameTextView;
@synthesize passwordTextView = _passwordTextView;
@synthesize notebookTextView = _notebookTextView;
@synthesize evernoteSettingsViewControllerDelegate;
@synthesize activityIndicator;
@synthesize evernoteLogo;

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
    [_passwordCell release];
    [_usernameCell release];
    [_notebookCell release];
    [_usernameTextView release];
    [_passwordTextView release];
    [_notebookTextView release];
    [activityIndicator release];
    [evernoteLogo release];
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
    
    self.title = @"Evernote Settings";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    [self.navigationController.navigationBar setBackgroundColor:[UIColor blackColor]];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
                                               initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                               target:self action:@selector(done:)] 
                                              autorelease];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    [self.activityIndicator setFrame:CGRectMake(240.0, 225.0, 37.0, 37.0)];
    [self.tableView addSubview:self.activityIndicator];
    [self.evernoteLogo setFrame:CGRectMake(240.0, 225.0, 60.0, 60.0)];
    [self.tableView addSubview:self.evernoteLogo];
    EvernoteConfig *sharedEvernoteConfig = [[SharingServiceAdapter sharedSharingService] sharedEvernoteConfiguration];
    [SharingServiceAdapter sharedSharingService].sharingServiceAdapterDelegate = self;
    if (sharedEvernoteConfig) {
        self.notebookTextView.text = sharedEvernoteConfig.notebookName;
        self.usernameTextView.text = sharedEvernoteConfig.username;
        self.passwordTextView.text = sharedEvernoteConfig.password;
    }
    //[self setWorking:YES];
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        switch (indexPath.section) {
            case 0:
                return _usernameCell;
                break;
            case 1:
                return _passwordCell;
                break;
            case 2:
                return _notebookCell;
                break;
            default:
                break;
        }
    }
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
}

-(void) done:(id)sender{
    [[SharingServiceAdapter sharedSharingService] setupEvernoteWith:self.notebookTextView.text username:self.usernameTextView.text password:self.passwordTextView.text];
}

-(void) didStartConfiguringEvernote{
    [self setWorking:YES];
}

-(void) didFinishConfiguringEvernote{
    [self setWorking:NO];
    [self.evernoteSettingsViewControllerDelegate dismissEvernoteSettingsViewController];
}

-(void) didFailConfiguringEvernoteWithError:(NSError *)error{
    [self setWorking:NO];
    if([error.domain isEqualToString:@"EvernoteAuthError"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incorrect username and/or password." 
        message:@"" 
        delegate:self 
        cancelButtonTitle:@"Ok" 
        otherButtonTitles:nil];
        //[alert addButtonWithTitle:@"Yes"];
        [alert show];
        [alert release];
    }
    if([error.domain isEqualToString:@"EvernoteNotebookError"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not create Notebook because it might already exist." 
                                                        message:@"" 
                                                       delegate:self 
                                              cancelButtonTitle:@"Ok" 
                                              otherButtonTitles:nil];
        //[alert addButtonWithTitle:@"Yes"];
        [alert show];
        [alert release];
    }
}

-(void) cancel:(id)sender{
    [self.evernoteSettingsViewControllerDelegate dismissEvernoteSettingsViewController];
}

- (void)setWorking:(BOOL)working {
    self.view.userInteractionEnabled = !working;
    self.navigationController.view.userInteractionEnabled = !working;
    if (working) {
        self.evernoteLogo.hidden = YES;
        [activityIndicator startAnimating];
    } else {
        self.evernoteLogo.hidden = NO;
        [activityIndicator stopAnimating];
    }
}



@end
