//
//  TestSpec.m
//  MeetingNotes
//
//  Created by Noel Curtis on 6/10/11.
//  Copyright 2011 EMC Corporation. All rights reserved.
//

// TestSpec.m

#import "Kiwi.h"

SPEC_BEGIN(TestSpec)

describe(@"A simple test", ^{
    it(@"works", ^{
        // Try changing should to shouldNot, and vice-versa to see
        // failures in action.
        NSLog(@"Hello");
        id anArray = [NSArray arrayWithObject:@"Foo"];
        [[anArray should] contain:@"Foo"];
        [[anArray shouldNot] contain:@"Bar"];
        
        [[theValue(42) should] beGreaterThan:theValue(10.0f)];
        [[theValue(42) shouldNot] beLessThan:theValue(20)];
        
        id scannerMock = [NSScanner mock];
        [[scannerMock should] receive:@selector(setScanLocation:)];
        [scannerMock setScanLocation:10];
        
        [scannerMock stub:@selector(string) andReturn:@"Unicorns"];
        [[[scannerMock string] should] equal:@"Unicorns"];
        
        [[theBlock(^{
            [NSException raise:NSInternalInconsistencyException format:@"oh-oh"];
        }) should] raise];
    });
});

SPEC_END