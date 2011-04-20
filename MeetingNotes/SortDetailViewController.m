//
//  SortDetailViewController.m
//  MeetingNotes
//
//  Created by Noel Curtis on 4/18/11.
//  Copyright 2011 Noel Curtis. All rights reserved.
//

#import "SortDetailViewController.h"
#import "CalenderView.h"

@implementation SortDetailViewController
@synthesize toolBar;
@synthesize rvController;
@synthesize popoverController;

@synthesize calendarButton, flexButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [calendarButton release];
    [popoverController release];
    [rvController release];
    [flexButton release];
    [toolBar release];
    [super dealloc];
}

#pragma mark - CalendarView show method

-(IBAction)calenderButtonClick:(id)sender{
    UIViewController *vc = [[CalenderView alloc] init];
    UIPopoverController *controls = [[UIPopoverController alloc]
                                     initWithContentViewController:vc]; 
    //controls.popoverContentSize = vc.view.frame.size;
    [controls presentPopoverFromBarButtonItem:sender 
                     permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}


#pragma mark - SplitViewController delegate methods

-(void) splitViewController:(UISplitViewController *)svc 
     willHideViewController:(UIViewController *)aViewController 
          withBarButtonItem:(UIBarButtonItem *)barButtonItem 
       forPopoverController:(UIPopoverController *)pc{
    
    barButtonItem.title = aViewController.title;  // set the title for the button
    NSMutableArray *items = [[self.toolBar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [self.toolBar setItems:items // setup bar button item for toolbar
                  animated:YES]; 
    self.popoverController = pc;

    
}

-(void) splitViewController:(UISplitViewController *)svc 
     willShowViewController:(UIViewController *)aViewController 
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem{
    
    NSMutableArray *items = [[toolBar items] mutableCopy];
    [items removeObjectAtIndex:0];
    [toolBar setItems:items animated:YES];
    [items release];
    self.popoverController = nil;

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
    [super viewDidLoad];    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
