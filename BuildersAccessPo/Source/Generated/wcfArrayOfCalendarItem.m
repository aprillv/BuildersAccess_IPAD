/*
	wcfArrayOfCalendarItem.h
	The implementation of properties and methods for the wcfArrayOfCalendarItem array.
	Generated by SudzC.com
*/
#import "wcfArrayOfCalendarItem.h"

#import "wcfCalendarItem.h"
@implementation wcfArrayOfCalendarItem

	+ (id) newWithNode: (CXMLNode*) node
	{
		return [[[wcfArrayOfCalendarItem alloc] initWithNode: node] autorelease];
	}

	- (id) initWithNode: (CXMLNode*) node
	{
		if(self = [self init]) {
			for(CXMLElement* child in [node children])
			{
				wcfCalendarItem* value = [[wcfCalendarItem newWithNode: child] object];
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
			[s appendString: [item serialize: @"CalendarItem"]];
		}
		return s;
	}

- (NSMutableArray*) toMutableArray
{
    NSMutableArray* s = [[NSMutableArray alloc]init];
    for(wcfCalendarItem *item in self) {
        [s addObject:item];
    }
    return s;
}

@end