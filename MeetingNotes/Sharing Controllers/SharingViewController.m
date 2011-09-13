//
//  SharingViewController.m
//  MeetingNotes
//
//  Created by Noel Curtis on 6/27/11.
//  Copyright 2011 Noel Curtis. All rights reserved.
//

#import "SharingViewController.h"
#import "SharingServiceAdapter.h"
#import "MeetingNotesAppDelegate.h"

@interface SharingViewController()
- (void) presentMailComposer;
@end

@implementation SharingViewController

@synthesize evernoteCell;
@synthesize dropboxCell;
@synthesize emailCell;
@synthesize meetingToShare = _meetingToShare;
@synthesize evernoteActivityIndicator = _evernoteAI;
@synthesize dropboxActivityIndicator = _dropboxAI;

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
    //[operationQueue dealloc];
    [evernoteCell release];
    [dropboxCell release];
    [emailCell release];
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
    [SharingServiceAdapter sharedSharingService].sharingServiceAdapterDelegate = self;
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    switch (indexPath.section) {
        case 0:
            return dropboxCell;
            break;
        case 1:
            return evernoteCell;
            break;
        case 2:
            return emailCell;
            break;
        default:
            break;
    }
    // Configure the cell...
    
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
    switch (indexPath.section) {
        case 0:
            [[SharingServiceAdapter sharedSharingService] uploadMeetingToDropbox:_meetingToShare];
            [_dropboxAI startAnimating];
            break;
        case 1:
        {
            [[(MeetingNotesAppDelegate*)[[UIApplication sharedApplication] delegate] operationQueue] addOperation:[[SharingServiceAdapter sharedSharingService] uploadMeetingAsync:_meetingToShare]]; 
            [_evernoteAI startAnimating];
            break;
        }
        case 2:
        {
            if([MFMailComposeViewController canSendMail]){
                [self presentMailComposer];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email trouble" 
                                                                message:@"Please make sure you have network connectivity and email is configured." 
                                                               delegate:self 
                                                      cancelButtonTitle:@"Ok" 
                                                      otherButtonTitles:nil];
                [alert show];
                [alert release];

            }
            break;
        }
        default:
            break;
    }
}
#pragma mark - Mail composer view and delegate methods

- (void) presentMailComposer{
	MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
	controller.mailComposeDelegate = self;
	[controller setSubject:@"Meeting notes summary..."];
	[controller setMessageBody:[self.meetingToShare asHtmlEmail] isHTML:YES];
	[self presentModalViewController:controller animated:YES];
	[controller release];
}

-(void) mailComposeController:(MFMailComposeViewController *)controller 
          didFinishWithResult:(MFMailComposeResult)result 
                        error:(NSError *)error{
    if(result==MFMailComposeResultFailed || error){
        NSLog(@"Error when trying to send email: %@", [error userInfo]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email trouble" 
                                                        message:@"Please make sure you have network connectivity and try again." 
                                                       delegate:self 
                                              cancelButtonTitle:@"Ok" 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    [self becomeFirstResponder];
	[self dismissModalViewControllerAnimated:YES];
}
#pragma mark - SharingServiceAdapterDelegate methods

-(void) didFinishUploadingToDropbox{
    [TestFlight passCheckpoint:@"Meetin uploaded to Dropbox"];
    [_dropboxAI stopAnimating];
}

-(void) didFailUploadingToDropbox:(NSError *)error{
    [_dropboxAI stopAnimating];
    NSLog(@"%@", [error userInfo]);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload trouble" 
													message:@"Please make sure you have network connectivity and try again." 
												   delegate:self 
										  cancelButtonTitle:@"Ok" 
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

-(void) didFinishUploadingToEvernote{
    [TestFlight passCheckpoint:@"Meeting uploaded to Evernote."];
    [_evernoteAI stopAnimating];
}


-(void) didFailUploadingToEvernote:(NSError *)error{
    [_evernoteAI stopAnimating];
    NSLog(@"%@", [error userInfo]);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload trouble" 
													message:@"Please make sure you have network connectivity and try again." 
												   delegate:self 
										  cancelButtonTitle:@"Ok" 
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}


@end
