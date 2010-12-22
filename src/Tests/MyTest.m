#import <GHUnit/GHUnit.h>

@interface MyTest : GHTestCase { }
@end

@implementation MyTest

//- (BOOL)shouldRunOnMainThread {
//	// By default NO, but if you have a UI test or test dependent on running on the main thread return YES
//}

- (void)setUpClass {
	// Run at start of all tests in the class
}

- (void)tearDownClass {
	// Run at end of all tests in the class
}

- (void)setUp {
	// Run before each test method
}

- (void)tearDown {
	// Run after each test method
}  

- (void)testShouldPass {
	NSObject *a = [[NSObject alloc] init];
	GHAssertNotNULL(a, nil);
	[a release];	
}

- (void)testShouldFail {
	NSDate *minDate = [NSDate distantPast];
	NSDate *maxDate = [NSDate distantFuture];	
	GHAssertEqualObjects(minDate, maxDate, @"%@ should be equal to %@. Something bad happened", minDate, maxDate);
}

@end
