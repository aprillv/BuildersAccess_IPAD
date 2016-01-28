/*
	wcfCalendarQA.h
	The implementation of properties and methods for the wcfCalendarQA object.
	Generated by SudzC.com
*/
#import "wcfCalendarQA.h"

@implementation wcfCalendarQA
	@synthesize AssignTo = _AssignTo;
	@synthesize ContactNm = _ContactNm;
	@synthesize DateT = _DateT;
	@synthesize Email = _Email;
	@synthesize EndTime = _EndTime;
	@synthesize Mobile = _Mobile;
	@synthesize Notes = _Notes;
	@synthesize Nproject = _Nproject;
	@synthesize Phone = _Phone;
	@synthesize StartTime = _StartTime;
	@synthesize Status = _Status;

	- (id) init
	{
		if(self = [super init])
		{
			self.AssignTo = nil;
			self.ContactNm = nil;
			self.DateT = nil;
			self.Email = nil;
			self.EndTime = nil;
			self.Mobile = nil;
			self.Notes = nil;
			self.Nproject = nil;
			self.Phone = nil;
			self.StartTime = nil;
			self.Status = nil;

		}
		return self;
	}

	+ (wcfCalendarQA*) newWithNode: (CXMLNode*) node
	{
		if(node == nil) { return nil; }
		return (wcfCalendarQA*)[[[wcfCalendarQA alloc] initWithNode: node] autorelease];
	}

	- (id) initWithNode: (CXMLNode*) node {
		if(self = [super initWithNode: node])
		{
			self.AssignTo = [Soap getNodeValue: node withName: @"AssignTo"];
			self.ContactNm = [Soap getNodeValue: node withName: @"ContactNm"];
			self.DateT = [Soap getNodeValue: node withName: @"DateT"];
			self.Email = [Soap getNodeValue: node withName: @"Email"];
			self.EndTime = [Soap getNodeValue: node withName: @"EndTime"];
			self.Mobile = [Soap getNodeValue: node withName: @"Mobile"];
			self.Notes = [Soap getNodeValue: node withName: @"Notes"];
			self.Nproject = [Soap getNodeValue: node withName: @"Nproject"];
			self.Phone = [Soap getNodeValue: node withName: @"Phone"];
			self.StartTime = [Soap getNodeValue: node withName: @"StartTime"];
			self.Status = [Soap getNodeValue: node withName: @"Status"];
		}
		return self;
	}

	- (NSMutableString*) serialize
	{
		return [self serialize: @"CalendarQA"];
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
		if (self.AssignTo != nil) [s appendFormat: @"<AssignTo>%@</AssignTo>", [[self.AssignTo stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.ContactNm != nil) [s appendFormat: @"<ContactNm>%@</ContactNm>", [[self.ContactNm stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.DateT != nil) [s appendFormat: @"<DateT>%@</DateT>", [[self.DateT stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Email != nil) [s appendFormat: @"<Email>%@</Email>", [[self.Email stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.EndTime != nil) [s appendFormat: @"<EndTime>%@</EndTime>", [[self.EndTime stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Mobile != nil) [s appendFormat: @"<Mobile>%@</Mobile>", [[self.Mobile stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Notes != nil) [s appendFormat: @"<Notes>%@</Notes>", [[self.Notes stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Nproject != nil) [s appendFormat: @"<Nproject>%@</Nproject>", [[self.Nproject stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Phone != nil) [s appendFormat: @"<Phone>%@</Phone>", [[self.Phone stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.StartTime != nil) [s appendFormat: @"<StartTime>%@</StartTime>", [[self.StartTime stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Status != nil) [s appendFormat: @"<Status>%@</Status>", [[self.Status stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];

		return s;
	}
	
	- (NSMutableString*) serializeAttributes
	{
		NSMutableString* s = [super serializeAttributes];

		return s;
	}
	
	-(BOOL)isEqual:(id)object{
		if(object != nil && [object isKindOfClass:[wcfCalendarQA class]]) {
			return [[self serialize] isEqualToString:[object serialize]];
		}
		return NO;
	}
	
	-(NSUInteger)hash{
		return [Soap generateHash:self];

	}
	
	- (void) dealloc
	{
		if(self.AssignTo != nil) { [self.AssignTo release]; }
		if(self.ContactNm != nil) { [self.ContactNm release]; }
		if(self.DateT != nil) { [self.DateT release]; }
		if(self.Email != nil) { [self.Email release]; }
		if(self.EndTime != nil) { [self.EndTime release]; }
		if(self.Mobile != nil) { [self.Mobile release]; }
		if(self.Notes != nil) { [self.Notes release]; }
		if(self.Nproject != nil) { [self.Nproject release]; }
		if(self.Phone != nil) { [self.Phone release]; }
		if(self.StartTime != nil) { [self.StartTime release]; }
		if(self.Status != nil) { [self.Status release]; }
		[super dealloc];
	}

@end