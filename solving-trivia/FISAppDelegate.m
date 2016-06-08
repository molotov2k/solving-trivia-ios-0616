//  FISAppDelegate.m

#import "FISAppDelegate.h"

@implementation FISAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog (@"%@", [self solveTrivia]);
    return YES;
}

- (NSString *)solveTrivia {
    NSDictionary *statesAndCapitals;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.json-generator.com/api/json/get/chbPSVaZFe?indent=2"]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSError *error = nil;
    id object = [NSJSONSerialization JSONObjectWithData:response options:0 error:&error];
    if ([object isKindOfClass:[NSDictionary class]]) {
        statesAndCapitals = object;
    }
    
    for (NSString *state in statesAndCapitals) {
        NSMutableArray *stateLetters = [[NSMutableArray alloc] init];
        NSMutableArray *capitalLetters = [[NSMutableArray alloc] init];
        NSString *lowercaseStateName = [statesAndCapitals[state][@"name"] lowercaseString];
        NSString *lowercaseCapitalName = [statesAndCapitals[state][@"capital"] lowercaseString];
        
        for (NSUInteger i = 0; i < lowercaseStateName.length; i++) {
            [stateLetters addObject:[lowercaseStateName substringWithRange:NSMakeRange(i, 1)]];
        }
        for (NSUInteger i = 0; i < lowercaseCapitalName.length; i++) {
            [capitalLetters addObject:[lowercaseCapitalName substringWithRange:NSMakeRange(i, 1)]];
        }
        
        NSMutableSet *stateLettersSet = [NSMutableSet setWithArray:stateLetters];
        NSSet *capitalLettersSet = [NSSet setWithArray:capitalLetters];
        [stateLettersSet intersectSet:capitalLettersSet];
        NSArray *result = [stateLettersSet allObjects];
        
        if (result.count == 0) {
            return statesAndCapitals[state][@"name"];
        }
        
    }
    return nil;
}

@end
