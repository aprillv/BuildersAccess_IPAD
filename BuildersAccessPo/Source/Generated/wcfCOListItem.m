/*
	wcfCOListItem.h
	The implementation of properties and methods for the wcfCOListItem object.
	Generated by SudzC.com
*/
#import "wcfCOListItem.h"

@implementation wcfCOListItem
	@synthesize Doc = _Doc;
	@synthesize IDCia = _IDCia;
	@synthesize Idnumber = _Idnumber;
	@synthesize Nproject = _Nproject;
	@synthesize Sales1 = _Sales1;
	@synthesize Status = _Status;
	@synthesize Total = _Total;
	@synthesize codate = _codate;

	- (id) init
	{
		if(self = [super init])
		{
			self.Doc = nil;
			self.IDCia = nil;
			self.Idnumber = nil;
			self.Nproject = nil;
			self.Sales1 = nil;
			self.Status = nil;
			self.Total = nil;
			self.codate = nil;

		}
		return self;
	}

	+ (wcfCOListItem*) newWithNode: (CXMLNode*) node
	{
		if(node == nil) { return nil; }
		return (wcfCOListItem*)[[[wcfCOListItem alloc] initWithNode: node] autorelease];
	}

	- (id) initWithNode: (CXMLNode*) node {
		if(self = [super initWithNode: node])
		{
			self.Doc = [Soap getNodeValue: node withName: @"Doc"];
			self.IDCia = [Soap getNodeValue: node withName: @"IDCia"];
			self.Idnumber = [Soap getNodeValue: node withName: @"Idnumber"];
			self.Nproject = [Soap getNodeValue: node withName: @"Nproject"];
			self.Sales1 = [Soap getNodeValue: node withName: @"Sales1"];
			self.Status = [Soap getNodeValue: node withName: @"Status"];
			self.Total = [Soap getNodeValue: node withName: @"Total"];
			self.codate = [Soap getNodeValue: node withName: @"codate"];
		}
		return self;
	}

	- (NSMutableString*) serialize
	{
		return [self serialize: @"COListItem"];
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
		if (self.Doc != nil) [s appendFormat: @"<Doc>%@</Doc>", [[self.Doc stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.IDCia != nil) [s appendFormat: @"<IDCia>%@</IDCia>", [[self.IDCia stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Idnumber != nil) [s appendFormat: @"<Idnumber>%@</Idnumber>", [[self.Idnumber stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Nproject != nil) [s appendFormat: @"<Nproject>%@</Nproject>", [[self.Nproject stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Sales1 != nil) [s appendFormat: @"<Sales1>%@</Sales1>", [[self.Sales1 stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Status != nil) [s appendFormat: @"<Status>%@</Status>", [[self.Status stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Total != nil) [s appendFormat: @"<Total>%@</Total>", [[self.Total stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.codate != nil) [s appendFormat: @"<codate>%@</codate>", [[self.codate stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];

		return s;
	}
	
	- (NSMutableString*) serializeAttributes
	{
		NSMutableString* s = [super serializeAttributes];

		return s;
	}
	
	-(BOOL)isEqual:(id)object{
		if(object != nil && [object isKindOfClass:[wcfCOListItem class]]) {
			return [[self serialize] isEqualToString:[object serialize]];
		}
		return NO;
	}
	
	-(NSUInteger)hash{
		return [Soap generateHash:self];

	}
	
	- (void) dealloc
	{
		if(self.Doc != nil) { [self.Doc release]; }
		if(self.IDCia != nil) { [self.IDCia release]; }
		if(self.Idnumber != nil) { [self.Idnumber release]; }
		if(self.Nproject != nil) { [self.Nproject release]; }
		if(self.Sales1 != nil) { [self.Sales1 release]; }
		if(self.Status != nil) { [self.Status release]; }
		if(self.Total != nil) { [self.Total release]; }
		if(self.codate != nil) { [self.codate release]; }
		[super dealloc];
	}

@end