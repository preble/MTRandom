// MTRandom - Objective-C Mersenne Twister
//  Objective-C interface by Adam Preble - adampreble.net - 8/6/12

#import <Foundation/Foundation.h>

@interface MTRandom : NSObject <NSCoding, NSCopying>

// Initialize with a given seed value.  This is the designated initializer
- (id)initWithSeed:(uint32_t)seed;

// Seed the generator with the current time.
- (id)init;


// generates a random number on [0,0xffffffff]-interval
- (uint32_t)randomUInt32;

// generates a random number on [0,1]-real-interval
- (double)randomDouble;

// generates a random number on [0,1)-real-interval
- (double)randomDouble0To1Exclusive;

@end


@interface MTRandom (Extras)

- (BOOL)randomBool;

- (uint32_t)randomUInt32From:(uint32_t)start to:(uint32_t)stop;

- (double)randomDoubleFrom:(double)start to:(double)stop;

@end


@interface NSArray (MTRandom)

- (id)mt_randomObjectWithRandom:(MTRandom *)r;

@end
