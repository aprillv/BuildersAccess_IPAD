/*
	wcfArrayOfstring.h
	The implementation of properties and methods for the wcfArrayOfstring array.
	Generated by SudzC.com
*/
#import "wcfArrayOfstring.h"

@implementation wcfArrayOfstring

	+ (id) newWithNode: (CXMLNode*) node
	{
		return [[[wcfArrayOfstring alloc] initWithNode: node] autorelease];
	}

	- (id) initWithNode: (CXMLNode*) node
	{
		if(self = [self init]) {
			for(CXMLElement* child in [node children])
			{
				NSString* value = [child stringValue];
				[self addObject: value];
			}
		}
		return self;
	}
	
	+ (NSMutableString*) serialize: (NSArray*) array
	{
		NSMutableString* s = [NSMutableString string];
		for(id item in array) {
			[s appendString: [[item stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		}
		return s;
	}

- (NSMutableArray*) toMutableArray
{
    NSMutableArray* s = [[NSMutableArray alloc]init];
    for(NSString *item in self) {
        [s addObject:item];
    }
    return s;
}

@end
