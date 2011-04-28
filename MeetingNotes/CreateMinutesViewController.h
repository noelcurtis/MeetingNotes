//
//  CreateMinutesViewController.h
//  Notes
//
//  Created by Scott Penrose on 8/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CreateMinutesModalViewControllerDelegate;

@interface CreateMinutesViewController : UIViewController <UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource> {
	id<CreateMinutesModalViewControllerDelegate> delegate;
	
	UITextField *titleTextField;
	UITextField *locationTextField;
	
	UITableViewCell *titleCell;
	UITableViewCell *locationCell;
	UITableViewCell *startsEndsCell;
}

@property (nonatomic, assign) id<CreateMinutesModalViewControllerDelegate> delegate;

@property (nonatomic, retain) IBOutlet UITextField *titleTextField;
@property (nonatomic, retain) IBOutlet UITextField *locationTextField;
@property (nonatomic, retain) IBOutlet UITableViewCell *titleCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *locationCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *startsEndsCell;

- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;

@end

@protocol CreateMinutesModalViewControllerDelegate
- (void)didDismissModalView;
- (void)insertMinuteWithTitle:(NSString *)title place:(NSString *)place;
@end