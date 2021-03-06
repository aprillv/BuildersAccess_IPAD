/*
	wcfProjectScheduleComplete.h
	The implementation of properties and methods for the wcfProjectScheduleComplete object.
	Generated by SudzC.com
*/
#import "wcfProjectScheduleComplete.h"

#import "wcfArrayOfProjectSchedule.h"
@implementation wcfProjectScheduleComplete
	@synthesize Flag = _Flag;
	@synthesize ScheduleList = _ScheduleList;

	- (id) init
	{
		if(self = [super init])
		{
			self.Flag = nil;
			self.ScheduleList = [[[NSMutableArray alloc] init] autorelease];

		}
		return self;
	}

	+ (wcfProjectScheduleComplete*) newWithNode: (CXMLNode*) node
	{
		if(node == nil) { return nil; }
		return (wcfProjectScheduleComplete*)[[[wcfProjectScheduleComplete alloc] initWithNode: node] autorelease];
	}

	- (id) initWithNode: (CXMLNode*) node {
		if(self = [super initWithNode: node])
		{
			self.Flag = [Soap getNodeValue: node withName: @"Flag"];
			self.ScheduleList = [[wcfArrayOfProjectSchedule newWithNode: [Soap getNode: node withName: @"ScheduleList"]] object];
		}
		return self;
	}

	- (NSMutableString*) serialize
	{
		return [self serialize: @"ProjectScheduleComplete"];
	}
  
	- (NSMutableString*) serialize: (NSString*) nodeName
	{
		NSMutableString* s = [NSMutableString string];
		[s appendFormat: @"<%@", nodeName];
		[s appendString: [self serializeAttributes]];
		[s appendString: @">"];
		[s appendString: [self serializeElements]];
		[s appendFormat: @"</%@>", nodeName];
		return s;
	}
	
	- (NSMutableString*) serializeElements
	{
		NSMutableString* s = [super serializeElements];
		if (self.Flag != nil) [s appendFormat: @"<Flag>%@</Flag>", [[self.Flag stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.ScheduleList != nil && self.ScheduleList.count > 0) {
			[s appendFormat: @"<ScheduleList>%@</ScheduleList>", [wcfArrayOfProjectSchedule serialize: self.ScheduleList]];
		} else {
			[s appendString: @"<ScheduleList/>"];
		}

		return s;
	}
	
	- (NSMutableString*) serializeAttributes
	{
		NSMutableString* s = [super serializeAttributes];

		return s;
	}
	
	-(BOOL)isEqual:(id)object{
		if(object != nil && [object isKindOfClass:[wcfProjectScheduleComplete class]]) {
			return [[self serialize] isEqualToString:[object serialize]];
		}
		return NO;
	}
	
	-(NSUInteger)hash{
		return [Soap generateHash:self];

	}
	
	- (void) dealloc
	{
		if(self.Flag != nil) { [self.Flag release]; }
		if(self.ScheduleList != nil) { [self.ScheduleList release]; }
		[super dealloc];
	}

@end
