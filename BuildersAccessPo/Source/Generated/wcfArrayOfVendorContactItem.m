/*
	wcfArrayOfVendorContactItem.h
	The implementation of properties and methods for the wcfArrayOfVendorContactItem array.
	Generated by SudzC.com
*/
#import "wcfArrayOfVendorContactItem.h"

#import "wcfVendorContactItem.h"
@implementation wcfArrayOfVendorContactItem

	+ (id) newWithNode: (CXMLNode*) node
	{
		return [[[wcfArrayOfVendorContactItem alloc] initWithNode: node] autorelease];
	}

	- (id) initWithNode: (CXMLNode*) node
	{
		if(self = [self init]) {
			for(CXMLElement* child in [node children])
			{
				wcfVendorContactItem* value = [[wcfVendorContactItem newWithNode: child] object];
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
			[s appendString: [item serialize: @"VendorContactItem"]];
		}
		return s;
	}
@end
