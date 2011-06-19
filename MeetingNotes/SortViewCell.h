//
//  SortViewCell.h
//  MeetingNotes
//
//  Created by Noel Curtis on 6/11/11.
//  Copyright 2011 EMC Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Category.h"

@interface SortViewCell : UITableViewCell {
    
}
@property (nonatomic, retain) IBOutlet UILabel *categoryLabel;
@property (nonatomic, retain) IBOutlet UILabel *categoryCountLabel;

-(void) setupCellWithCategory:(Category*) category;
-(void) setupCellWithString:(NSString*) string;
@end
