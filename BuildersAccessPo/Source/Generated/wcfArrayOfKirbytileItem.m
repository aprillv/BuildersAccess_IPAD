/*
	wcfArrayOfKirbytileItem.h
	The implementation of properties and methods for the wcfArrayOfKirbytileItem array.
	Generated by SudzC.com
*/
#import "wcfArrayOfKirbytileItem.h"

#import "wcfKirbytileItem.h"
@implementation wcfArrayOfKirbytileItem

	+ (id) newWithNode: (CXMLNode*) node
	{
		return [[[wcfArrayOfKirbytileItem alloc] initWithNode: node] autorelease];
	}

	- (id) initWithNode: (CXMLNode*) node
	{
		if(self = [self init]) {
			for(CXMLElement* child in [node children])
			{
				wcfKirbytileItem* value = [[wcfKirbytileItem newWithNode: child] object];
				if(value != nil) {
					[self addObject: value];
				}
			}
		}
		return self;
	}
	
	+ (NSMutableString*) serialize: (NSArray*) array
	{
		NSMutableString* s = [NSMutableString string];
		for(id item in array) {
			[s appendString: [item serialize: @"KirbytileItem"]];
		}
		return s;
	}
@end
