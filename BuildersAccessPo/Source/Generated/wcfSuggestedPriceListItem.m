/*
	wcfSuggestedPriceListItem.h
	The implementation of properties and methods for the wcfSuggestedPriceListItem object.
	Generated by SudzC.com
*/
#import "wcfSuggestedPriceListItem.h"

@implementation wcfSuggestedPriceListItem
	@synthesize Cianame = _Cianame;
	@synthesize Comment = _Comment;
	@synthesize FormulaPrice = _FormulaPrice;
	@synthesize Idcia = _Idcia;
	@synthesize Idnumber = _Idnumber;
	@synthesize Idproject = _Idproject;
	@synthesize Nproject = _Nproject;
	@synthesize SQFT = _SQFT;
	@synthesize Suggested = _Suggested;
	@synthesize TotalPage = _TotalPage;

	- (id) init
	{
		if(self = [super init])
		{
			self.Cianame = nil;
			self.Comment = nil;
			self.FormulaPrice = nil;
			self.Idcia = nil;
			self.Idnumber = nil;
			self.Idproject = nil;
			self.Nproject = nil;
			self.SQFT = nil;
			self.Suggested = nil;
			self.TotalPage = nil;

		}
		return self;
	}

	+ (wcfSuggestedPriceListItem*) newWithNode: (CXMLNode*) node
	{
		if(node == nil) { return nil; }
		return (wcfSuggestedPriceListItem*)[[[wcfSuggestedPriceListItem alloc] initWithNode: node] autorelease];
	}

	- (id) initWithNode: (CXMLNode*) node {
		if(self = [super initWithNode: node])
		{
			self.Cianame = [Soap getNodeValue: node withName: @"Cianame"];
			self.Comment = [Soap getNodeValue: node withName: @"Comment"];
			self.FormulaPrice = [Soap getNodeValue: node withName: @"FormulaPrice"];
			self.Idcia = [Soap getNodeValue: node withName: @"Idcia"];
			self.Idnumber = [Soap getNodeValue: node withName: @"Idnumber"];
			self.Idproject = [Soap getNodeValue: node withName: @"Idproject"];
			self.Nproject = [Soap getNodeValue: node withName: @"Nproject"];
			self.SQFT = [Soap getNodeValue: node withName: @"SQFT"];
			self.Suggested = [Soap getNodeValue: node withName: @"Suggested"];
			self.TotalPage = [Soap getNodeValue: node withName: @"TotalPage"];
		}
		return self;
	}

	- (NSMutableString*) serialize
	{
		return [self serialize: @"SuggestedPriceListItem"];
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
		if (self.Cianame != nil) [s appendFormat: @"<Cianame>%@</Cianame>", [[self.Cianame stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Comment != nil) [s appendFormat: @"<Comment>%@</Comment>", [[self.Comment stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.FormulaPrice != nil) [s appendFormat: @"<FormulaPrice>%@</FormulaPrice>", [[self.FormulaPrice stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Idcia != nil) [s appendFormat: @"<Idcia>%@</Idcia>", [[self.Idcia stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Idnumber != nil) [s appendFormat: @"<Idnumber>%@</Idnumber>", [[self.Idnumber stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Idproject != nil) [s appendFormat: @"<Idproject>%@</Idproject>", [[self.Idproject stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Nproject != nil) [s appendFormat: @"<Nproject>%@</Nproject>", [[self.Nproject stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.SQFT != nil) [s appendFormat: @"<SQFT>%@</SQFT>", [[self.SQFT stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Suggested != nil) [s appendFormat: @"<Suggested>%@</Suggested>", [[self.Suggested stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.TotalPage != nil) [s appendFormat: @"<TotalPage>%@</TotalPage>", [[self.TotalPage stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];

		return s;
	}
	
	- (NSMutableString*) serializeAttributes
	{
		NSMutableString* s = [super serializeAttributes];

		return s;
	}
	
	-(BOOL)isEqual:(id)object{
		if(object != nil && [object isKindOfClass:[wcfSuggestedPriceListItem class]]) {
			return [[self serialize] isEqualToString:[object serialize]];
		}
		return NO;
	}
	
	-(NSUInteger)hash{
		return [Soap generateHash:self];

	}
	
	- (void) dealloc
	{
		if(self.Cianame != nil) { [self.Cianame release]; }
		if(self.Comment != nil) { [self.Comment release]; }
		if(self.FormulaPrice != nil) { [self.FormulaPrice release]; }
		if(self.Idcia != nil) { [self.Idcia release]; }
		if(self.Idnumber != nil) { [self.Idnumber release]; }
		if(self.Idproject != nil) { [self.Idproject release]; }
		if(self.Nproject != nil) { [self.Nproject release]; }
		if(self.SQFT != nil) { [self.SQFT release]; }
		if(self.Suggested != nil) { [self.Suggested release]; }
		if(self.TotalPage != nil) { [self.TotalPage release]; }
		[super dealloc];
	}

@end