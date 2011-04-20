//
//  CalenderView.h
//  NotesMainView
//
//  Created by Noel Curtis on 4/10/11.
//  Copyright 2011 Noel Curtis. All rights reserved.
//

#import <TapkuLibrary/TapkuLibrary.h>
#import <UIKit/UIKit.h>



@interface CalenderView : TKCalendarMonthTableViewController {
    NSMutableArray *dataArray; 
	NSMutableDictionary *dataDictionary;

}
@property (retain,nonatomic) NSMutableArray *dataArray;
@property (retain,nonatomic) NSMutableDictionary *dataDictionary;

- (void) generateRandomDataForStartDate:(NSDate*)start endDate:(NSDate*)end;

@end
