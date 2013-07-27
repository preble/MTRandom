// MTRandom - Objective-C Mersenne Twister
//  Objective-C interface by Adam Preble - adampreble.net - 8/6/12

#import <Foundation/Foundation.h>

@interface MTRandom64 : NSObject <NSCoding, NSCopying>

// Initialize with a given seed value.  This is the designated initializer
- (id) initWithSeed:(uint64_t)seed;

// Seed the generator with the current time.
- (id) init;

// generates a random number on [0,0xffffffffffffffff] interval
- (uint64_t) randomUInt64;

// generates a random number on [0,1]-real-interval
- (double) randomDouble;

// generates a random number on [0,1)-real-interval
- (double) randomDouble0To1Exclusive;

@end

@interface MTRandom64 (Extras)

- (BOOL) randomBool;

- (uint64_t) randomUInt64From:(uint64_t)start to:(uint64_t)stop;

- (double) randomDoubleFrom:(double)start to:(double)stop;

@end

@interface NSArray (MTRandom64)

- (id) mt_randomObjectWithRandom:(MTRandom64 *)r;

@end
