/*
	wcfCalendarQAb.h
	The implementation of properties and methods for the wcfCalendarQAb object.
	Generated by SudzC.com
*/
#import "wcfCalendarQAb.h"

#import "wcfArrayOfCalendarQAbItem.h"
@implementation wcfCalendarQAb
	@synthesize AssignTo = _AssignTo;
	@synthesize BtnAdd = _BtnAdd;
	@synthesize BtnFail = _BtnFail;
	@synthesize BtnFinish = _BtnFinish;
	@synthesize BtnSubmit = _BtnSubmit;
	@synthesize Dlist = _Dlist;
	@synthesize Inspection = _Inspection;
	@synthesize Nproject = _Nproject;
	@synthesize Penalty = _Penalty;
	@synthesize Points = _Points;
	@synthesize Remark = _Remark;
	@synthesize Status = _Status;
	@synthesize Walk = _Walk;

	- (id) init
	{
		if(self = [super init])
		{
			self.AssignTo = nil;
			self.BtnAdd = nil;
			self.BtnFail = nil;
			self.BtnFinish = nil;
			self.BtnSubmit = nil;
			self.Dlist = [[[NSMutableArray alloc] init] autorelease];
			self.Inspection = nil;
			self.Nproject = nil;
			self.Penalty = nil;
			self.Points = nil;
			self.Remark = nil;
			self.Status = nil;
			self.Walk = nil;

		}
		return self;
	}

	+ (wcfCalendarQAb*) newWithNode: (CXMLNode*) node
	{
		if(node == nil) { return nil; }
		return (wcfCalendarQAb*)[[[wcfCalendarQAb alloc] initWithNode: node] autorelease];
	}

	- (id) initWithNode: (CXMLNode*) node {
		if(self = [super initWithNode: node])
		{
			self.AssignTo = [Soap getNodeValue: node withName: @"AssignTo"];
			self.BtnAdd = [Soap getNodeValue: node withName: @"BtnAdd"];
			self.BtnFail = [Soap getNodeValue: node withName: @"BtnFail"];
			self.BtnFinish = [Soap getNodeValue: node withName: @"BtnFinish"];
			self.BtnSubmit = [Soap getNodeValue: node withName: @"BtnSubmit"];
			self.Dlist = [[wcfArrayOfCalendarQAbItem newWithNode: [Soap getNode: node withName: @"Dlist"]] object];
			self.Inspection = [Soap getNodeValue: node withName: @"Inspection"];
			self.Nproject = [Soap getNodeValue: node withName: @"Nproject"];
			self.Penalty = [Soap getNodeValue: node withName: @"Penalty"];
			self.Points = [Soap getNodeValue: node withName: @"Points"];
			self.Remark = [Soap getNodeValue: node withName: @"Remark"];
			self.Status = [Soap getNodeValue: node withName: @"Status"];
			self.Walk = [Soap getNodeValue: node withName: @"Walk"];
		}
		return self;
	}

	- (NSMutableString*) serialize
	{
		return [self serialize: @"CalendarQAb"];
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
		if (self.BtnAdd != nil) [s appendFormat: @"<BtnAdd>%@</BtnAdd>", [[self.BtnAdd stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.BtnFail != nil) [s appendFormat: @"<BtnFail>%@</BtnFail>", [[self.BtnFail stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.BtnFinish != nil) [s appendFormat: @"<BtnFinish>%@</BtnFinish>", [[self.BtnFinish stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.BtnSubmit != nil) [s appendFormat: @"<BtnSubmit>%@</BtnSubmit>", [[self.BtnSubmit stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Dlist != nil && self.Dlist.count > 0) {
			[s appendFormat: @"<Dlist>%@</Dlist>", [wcfArrayOfCalendarQAbItem serialize: self.Dlist]];
		} else {
			[s appendString: @"<Dlist/>"];
		}
		if (self.Inspection != nil) [s appendFormat: @"<Inspection>%@</Inspection>", [[self.Inspection stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Nproject != nil) [s appendFormat: @"<Nproject>%@</Nproject>", [[self.Nproject stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Penalty != nil) [s appendFormat: @"<Penalty>%@</Penalty>", [[self.Penalty stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Points != nil) [s appendFormat: @"<Points>%@</Points>", [[self.Points stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Remark != nil) [s appendFormat: @"<Remark>%@</Remark>", [[self.Remark stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Status != nil) [s appendFormat: @"<Status>%@</Status>", [[self.Status stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Walk != nil) [s appendFormat: @"<Walk>%@</Walk>", [[self.Walk stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];

		return s;
	}
	
	- (NSMutableString*) serializeAttributes
	{
		NSMutableString* s = [super serializeAttributes];

		return s;
	}
	
	-(BOOL)isEqual:(id)object{
		if(object != nil && [object isKindOfClass:[wcfCalendarQAb class]]) {
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
		if(self.BtnAdd != nil) { [self.BtnAdd release]; }
		if(self.BtnFail != nil) { [self.BtnFail release]; }
		if(self.BtnFinish != nil) { [self.BtnFinish release]; }
		if(self.BtnSubmit != nil) { [self.BtnSubmit release]; }
		if(self.Dlist != nil) { [self.Dlist release]; }
		if(self.Inspection != nil) { [self.Inspection release]; }
		if(self.Nproject != nil) { [self.Nproject release]; }
		if(self.Penalty != nil) { [self.Penalty release]; }
		if(self.Points != nil) { [self.Points release]; }
		if(self.Remark != nil) { [self.Remark release]; }
		if(self.Status != nil) { [self.Status release]; }
		if(self.Walk != nil) { [self.Walk release]; }
		[super dealloc];
	}

@end
