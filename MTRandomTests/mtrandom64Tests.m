//
//  mtrandom64Tests.m
//  mtrandom64Tests
//
//  Created by Ali Moeeny on 7/19/13.
//  Copyright (c) 2013 Ali Moeeny. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MTRandom64.h"

@interface mtrandom64Tests : XCTestCase

@property (strong) MTRandom64 * engine64;

@end

@implementation mtrandom64Tests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void) testTheBasics_randomUInt64
{
    _engine64 = [[MTRandom64 alloc] init];
    uint64_t r = 0;
    for (int i=0; i < 1000; i++) {
        r = [_engine64 randomUInt64];
        XCTAssertTrue(r>0);
        XCTAssertTrue(r<UINT64_MAX);
    }
}

- (void) testTheBasics_randomDouble
{
    _engine64 = [[MTRandom64 alloc] init];
    double r = 0;
    for (int i=0; i < 1000; i++) {
        r = [_engine64 randomDouble];
        XCTAssertTrue(r>0);
        XCTAssertTrue(r<1);
    }
}


@end
