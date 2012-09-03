//
//  MTRandomTests.m
//  MTRandomTests
//
//  Created by Adam Preble on 9/2/12.
//  Copyright (c) 2012 Adam Preble. All rights reserved.
//

#import "MTRandomTests.h"
#import "MTRandom.h"

@interface MTRandomTests () {
	MTRandom *random;
}

@end

@implementation MTRandomTests

- (void)setUp
{
    [super setUp];
    
	random = [[MTRandom alloc] init];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testSeed
{
	uint32_t seed = 5;
	MTRandom *randomA = [[MTRandom alloc] initWithSeed:seed];
	MTRandom *randomB = [[MTRandom alloc] initWithSeed:seed];
	for (int i = 0; i < 1000; i++)
	{
		double a = [randomA randomDouble];
		double b = [randomB randomDouble];
		// Strange that they don't line up exactly. Usually off on one or two iterations.
		STAssertEquals(a, b, @"Mismatch on iteration %d", i);
	}
}

- (void)testInt
{

	for (int i = 0; i < 1000; i++)
	{
		NSUInteger n = [random randomUInt32From:0 to:10];
		STAssertTrue(n >= 0, @"n below range");
		STAssertTrue(n <= 10, @"n above range");
	}
}

- (void)testInt2
{
	int n;
	n = [random randomUInt32From:0 to:0];
	STAssertEquals(n, 0, @"Fails with equal min/max");
	n = [random randomUInt32From:5000 to:5000];
	STAssertEquals(n, 5000, @"Fails with equal min/max");
}

- (void)testBoolDistribution
{
	int values[2] = {0, 0};
	const int reps = 10000000;
	const int accuracy = reps * 0.01; // appears that 1% is a reasonable level to expect
	
	for (int i = 0; i < reps; i++)
	{
		int index = ([random randomBool]) ? 1 : 0;
		values[index] += 1;
	}
	
	STAssertEqualsWithAccuracy(values[0], reps/2, accuracy, @"Not enough NO");
	STAssertEqualsWithAccuracy(values[1], reps/2, accuracy, @"Not enough YES");
}

- (void)testIntDistribution
{
	int start = 40;
	int stop = 51;
	
	if (stop < start)
		return;
	
	int range = stop - start;
	
	int histogram[range];
	for (int i = 0; i <= range; i++)
	{
		histogram[i] = 0;
	}
	
	const int reps = 1000000;
	for (int i = 0; i < reps; i++)
	{
		int index = [random randomUInt32From:start to:stop];
		histogram[index-start] = histogram[index-start] + 1;
	}
	
	NSLog(@"Frequency distribution");
	for (int i = 0; i <= range; i++)
	{
		NSLog(@"%i, %i",start+i,histogram[i]);
		STAssertEqualsWithAccuracy(histogram[i], reps/range, 0.10 * reps/range, @"Uneven distribution");
	}
}

- (void)testArchiving
{
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:random];
	
	MTRandom *unarchived = [NSKeyedUnarchiver unarchiveObjectWithData:data];
	
	for (int i = 0; i < 1000; i++)
	{
		double a = [random randomDouble];
		double b = [unarchived randomDouble];
		// Strange that they don't line up exactly. Usually off on one or two iterations.
		STAssertEquals(a, b, @"Mismatch on iteration %d", i);
	}
}

- (void)testCopying
{
	MTRandom *copy = [random copy];
	
	for (int i = 0; i < 1000; i++)
	{
		double a = [random randomDouble];
		double b = [copy randomDouble];
		// Strange that they don't line up exactly. Usually off on one or two iterations.
		STAssertEquals(a, b, @"Mismatch on iteration %d", i);
	}
}

@end
