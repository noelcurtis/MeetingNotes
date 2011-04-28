//
//  StartsEndsViewController.h
//  Notes
//
//  Created by Scott Penrose on 8/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface StartsEndsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	UILabel *startsDateTimeLabel;
	UILabel *endsDateTimeLabel;
	
	UITableViewCell *startsCell;
	UITableViewCell *endsCell;
}

@property (nonatomic, retain) IBOutlet UILabel *startsDateTimeLabel;
@property (nonatomic, retain) IBOutlet UILabel *endsDateTimeLabel;
@property (nonatomic, retain) IBOutlet UITableViewCell *startsCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *endsCell;

- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;

@end
