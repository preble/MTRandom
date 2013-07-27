// MTRandom - Objective-C Mersenne Twister
//   Objective-C interface by Adam Preble - adampreble.net
//   Based on mt19937ar.c; license is included directly below this comment block.
//     http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/MT2002/CODES/mt19937ar.c
//   Portions adapted from code by MrFusion: http://forums.macrumors.com/showthread.php?t=1083103

/*
   A C-program for MT19937, with initialization improved 2002/1/26.
   Coded by Takuji Nishimura and Makoto Matsumoto.

   Before using, initialize the state by using init_genrand(seed)
   or init_by_array(init_key, key_length).

   Copyright (C) 1997 - 2002, Makoto Matsumoto and Takuji Nishimura,
   All rights reserved.

   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions
   are met:

   1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.

   2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.

   3. The names of its contributors may not be used to endorse or promote
   products derived from this software without specific prior written
   permission.

   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
   "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
   A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
   CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
   EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
   PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
   PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
   LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
   NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
   SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


   Any feedback is very welcome.
   http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/emt.html
   email: m-mat @ math.sci.hiroshima-u.ac.jp (remove space)
 */

/* Period parameters */
#define N 312
#define M 156
#define MATRIX_A 0xB5026F5AA96619E9ULL   /* constant vector a */
#define UPPER_MASK 0xFFFFFFFF80000000ULL /* most significant w-r bits */
#define LOWER_MASK 0x7FFFFFFFULL /* least significant r bits */

#import "MTRandom64.h"

@interface MTRandom64 () {
    uint64_t mt[N];
    uint64_t mti;
}

@end

@implementation MTRandom64

#pragma mark -
#pragma mark init

- (id) init
{
    uint64_t seed = (uint64_t)[NSDate timeIntervalSinceReferenceDate];
    return [self initWithSeed:seed];
}


- (id) initWithSeed:(uint64_t)seed
{
    self = [super init];
    if (self != nil)
    {
        [self seed:seed];
    }

    return self;
}


#pragma mark - NSCoding

- (id) initWithCoder:(NSCoder *)coder
{
    if ( (self = [super init]) )
    {
        mti = (uint64_t)[coder decodeIntegerForKey : @"mti"];

        NSArray *arr = [coder decodeObjectForKey:@"mt"];
        if (!arr)
        {
            [NSException raise:@"MTRandom" format:@"No array in archive?"];
        }

        if (arr.count != N)
        {
            [NSException raise:@"MTRandom" format:@"Coded value has different N size."];
        }

        [arr enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
             mt[idx] = (uint64_t)[obj unsignedIntegerValue];
         }


        ];
    }

    return self;
}


- (void) encodeWithCoder:(NSCoder *)coder
{
    [coder encodeInteger:mti forKey:@"mti"];

    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:N];
    for (int i = 0; i < N; i++)
    {
        [arr addObject:@(mt[i])];
    }

    [coder encodeObject:arr forKey:@"mt"];
}


#pragma mark - NSCopying

- (id) copyWithZone:(NSZone *)zone
{
    MTRandom64 *r = [[[self class] allocWithZone:zone] init];
    r->mti = mti;
    memcpy(r->mt, mt, sizeof(uint64_t) * N);
    return r;
}


#pragma mark - Mersenne Twister

- (void) seed:(uint64_t)s
{
    mt[0] = s & 0xffffffffUL;
    for (mti = 1; mti < N; mti++)
    {
        mt[mti] =
            (1812433253UL * ( mt[mti - 1] ^ (mt[mti - 1] >> 30) ) + mti);
        /*
           See Knuth TAOCP Vol2. 3rd Ed. P.106 for multiplier.
           In the previous versions, MSBs of the seed affect
           only MSBs of the array mt[].
           2002/01/09 modified by Makoto Matsumoto
         */
        mt[mti] &= 0xffffffffffffffffUL;
        /* for >64 bit machines */
    }
}


// generates a random number on [0,0xffffffff]-interval
- (uint64_t) randomUInt64
{
    uint64_t y;
    static uint64_t mag01[2] = {0x0UL, MATRIX_A};
    /* mag01[x] = x * MATRIX_A  for x=0,1 */

    if (mti >= N)   /* generate N words at one time */
    {
        int kk;

        if (mti == N + 1)   /* if init_genrand() has not been called, */
        {
            [self seed:5489]; /* a default initial seed is used */
        }

        for (kk = 0; kk < N - M; kk++)
        {
            y = (mt[kk] & UPPER_MASK) | (mt[kk + 1] & LOWER_MASK);
            mt[kk] = mt[kk + M] ^ (y >> 1) ^ mag01[y & 0x1UL];
        }

        for (; kk < N - 1; kk++)
        {
            y = (mt[kk] & UPPER_MASK) | (mt[kk + 1] & LOWER_MASK);
            mt[kk] = mt[kk + (M - N)] ^ (y >> 1) ^ mag01[y & 0x1UL];
        }

        y = (mt[N - 1] & UPPER_MASK) | (mt[0] & LOWER_MASK);
        mt[N - 1] = mt[M - 1] ^ (y >> 1) ^ mag01[y & 0x1UL];

        mti = 0;
    }

    y = mt[mti++];

    /* Tempering */
    y ^= (y >> 11);
    y ^= (y << 7) & 0x9d2c5680UL;
    y ^= (y << 15) & 0xefc60000UL;
    y ^= (y >> 18);

    return y;
}


#pragma mark - Auxiliary Methods

/* generates a random number on [0,1]-real-interval */
- (double) randomDouble
{
    return [self randomUInt64] * (1.0 / 18446744073709551615.0);
    /* divided by 2^64-1 */
}


/* generates a random number on [0,1)-real-interval */
- (double) randomDouble0To1Exclusive
{
    return [self randomUInt64] * (1.0 / 18446744073709551616.0);
    /* divided by 2^64 */
}


@end

#pragma mark -

@implementation MTRandom64 (Extras)

- (BOOL) randomBool
{
    return ([self randomUInt64] / 2) < 2147483648;
//	return [self randomUInt64] < 18446744073709551616;// <-64 | 32-> 2147483648;
}


- (uint64_t) randomUInt64From:(uint64_t)start to:(uint64_t)stop
{
    NSUInteger width = 1 + stop - start;

    return start + ( floor([self randomDouble0To1Exclusive] * (double)width) );
}


- (double) randomDoubleFrom:(double)start to:(double)stop
{
    double range = stop - start;
    double randomDouble = [self randomDouble];
    return start + randomDouble * range;
}


@end

#pragma mark -

@implementation NSArray (MTRandom)

- (id) mt_randomObjectWithRandom:(MTRandom64 *)r
{
    return [self objectAtIndex:[r randomUInt64From:0 to:(uint64_t)self.count - 1]];
}


@end
