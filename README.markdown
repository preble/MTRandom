# MTRandom

An Objective-C wrapper for [Mersenne Twister][], a pseudorandom number generator developed in 1997 by Makoto Matsumoto and Takuji Nishimura.

This Objective-C wrapper was written by [Adam Preble][] in 2012.


# Usage

This repo contains `MTRandom`, an Objective-C class encapsulating the Mersenne Twister generator.

    MTRandom *random = [[MTRandom alloc] init];       // Seed the generator with the current time.
	uint32_t q = [random randomUInt32];               // [0, 0xFFFFFFFF]
	uint32_t r = [random randomUInt32From:5 to:10];   // [5, 10]
	double   s = [random randomDouble];               // [0.0, 1.0]
	double   t = [random randomDouble0To1Exclusive];  // [0.0, 1.0)
	double   u = [random randomDoubleFrom:0 to:M_PI]; // [0, 3.14159...]

`MTRandom` conforms to `NSCoding` and `NSCopying` so you can archive it and copy it.

The repo also contains an Xcode project with a single target, MTRandomTests, which is a set of basic unit tests.  You can run those tests by opening the Product menu and selecting Test.


# License

The wrapper itself is BSD licensed, as is the [version][] of Mersenne Twister itself that it is based on.  If you use MTRandom, send me a note.


[Mersenne Twister]: http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/emt.html
[Adam Preble]: http://adampreble.net/
[version]: http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/MT2002/emt19937ar.html
