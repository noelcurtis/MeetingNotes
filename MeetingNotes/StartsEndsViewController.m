    //
//  StartsEndsViewController.m
//  Notes
//
//  Created by Scott Penrose on 8/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "StartsEndsViewController.h"
#import "CreateMinutesViewController.h"

@interface StartsEndsViewController()
@property (nonatomic, retain)NSDateFormatter *dateFormatter;
@end

@implementation StartsEndsViewController

@synthesize startsCell, endsCell, startsDateTimeLabel, endsDateTimeLabel;
@synthesize startsDate, endsDate;
@synthesize datePicker;
@synthesize tableView = _tableView;
@synthesize dateFormatter;
@synthesize createMinutesViewControllerRef;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

#pragma mark -
#pragma mark View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	CGSize size = {320, 353};
    [self setContentSizeForViewInPopover:size];
    // Done Button
	//self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
	//																						target:self 
	//																						action:@selector(done:)] autorelease];
	self.dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [self.datePicker setDate:self.createMinutesViewControllerRef.startsDate];
    self.startsDate = self.createMinutesViewControllerRef.startsDate;
    self.endsDate = self.createMinutesViewControllerRef.endsDate;
    self.startsDateTimeLabel.text = [self.dateFormatter stringFromDate:self.startsDate];
    self.endsDateTimeLabel.text = [self.dateFormatter stringFromDate:self.endsDate];
    // Cancel Button
	//self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
	//																					   target:self 
	//																					   action:@selector(cancel:)] autorelease];
}

-(void) viewWillAppear:(BOOL)animated{
    [self tableView:_tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    [super viewWillAppear:animated];
}


#pragma mark -
#pragma mark Actions

// The done button was tapped, save and close Modal view
- (IBAction)done:(id)sender {
	// TODO - Check for all values
	
	// Save values for minutes	
	
}

// The cancel button was tapped, pop off nav stack
- (IBAction)cancel:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)dateAction:(id)sender{
    NSLog(@"Picked date...");
    NSIndexPath *indexPath = [_tableView indexPathForSelectedRow];
    //NSLog(@"%@", [[self.dateFormatter stringFromDate:self.datePicker.date] description]);
    NSLog(@"%@", [self.datePicker.date description]);
    switch (indexPath.row) {
        case 0:
            self.startsDateTimeLabel.text = [self.dateFormatter stringFromDate:self.datePicker.date];
            self.startsDate = self.datePicker.date;
            
            self.endsDate = [[NSDate alloc] initWithTimeInterval:60*60 sinceDate:self.startsDate];
            self.endsDateTimeLabel.text = [self.dateFormatter stringFromDate:self.endsDate];
            self.createMinutesViewControllerRef.startsDate = self.startsDate;
            self.createMinutesViewControllerRef.endsDate = self.endsDate;
            break;
        case 1:
            self.endsDateTimeLabel.text = [self.dateFormatter stringFromDate:self.datePicker.date];
            self.endsDate = self.datePicker.date;
            self.createMinutesViewControllerRef.endsDate = self.endsDate;
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
		if (indexPath.row == 0) {
			return startsCell;
		}
		else if (indexPath.row == 1) {
			return endsCell;
		}
	}
	NSLog(@"There is not cell for indexPath row=%@ section=%@", indexPath.row, indexPath.section);
	NSException *exception = [NSException exceptionWithName:@"NoCell" reason:@"There is no table view cell for this indexPath" userInfo:nil];
	@throw exception;
}

/*
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
		
    }   
}
*/

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // The table view should not be re-orderable.
    return NO;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	// Default height
	CGFloat height = 44;
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
    [createMinutesViewControllerRef release];
    [dateFormatter release];
    [_tableView release];
    [datePicker release];
    [startsCell release];
    [endsCell release];
    [startsDateTimeLabel release];
    [endsDateTimeLabel release];
    [startsDate release];
    [endsDate release];
    [super dealloc];
}


@end
