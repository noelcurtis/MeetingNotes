    //
//  CreateMinutesViewController.m
//  Notes
//
//  Created by Scott Penrose on 8/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CreateMinutesViewController.h"
#import "StartsEndsViewController.h"

@implementation CreateMinutesViewController

@synthesize delegate, titleTextField, locationTextField, titleCell, locationCell, startsEndsCell;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	// Done Button
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
																							target:self 
																							action:@selector(done:)] autorelease];
	// Cancel Button
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
																						   target:self 
																						   action:@selector(cancel:)] autorelease];
}


#pragma mark -
#pragma mark Actions

// The done button was tapped, save and close Modal view
- (IBAction)done:(id)sender {
	// TODO - Check for all values
	
	// Save values for minutes	
	[delegate insertMinuteWithTitle:titleTextField.text place:locationTextField.text];
	
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int numberOfRows = 0;
	if(section == 0)
	{
		numberOfRows = 2;
	}
	else if (section == 1) {
		numberOfRows = 1;	
	}
	return numberOfRows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
		if (indexPath.row == 0) {
			return titleCell;
		}
		else if (indexPath.row == 1) {
			return locationCell;
		}
	}
	else if (indexPath.section == 1) {
		if (indexPath.row == 0) {
			return startsEndsCell;
		}
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


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Selected Starts and Ends Dates
	if (indexPath.section == 1 && indexPath.row == 0) {
		[titleTextField resignFirstResponder];
		[locationTextField resignFirstResponder];
		[startsEndsCell setSelected:NO];
		
		StartsEndsViewController *startsEndsVC = [[StartsEndsViewController alloc] initWithNibName:@"StartsEndsView" bundle:nil];
		startsEndsVC.title = @"Start & End";
        [self.navigationController pushViewController:startsEndsVC animated:YES];
		[startsEndsVC release];
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
    [super dealloc];
}


@end
