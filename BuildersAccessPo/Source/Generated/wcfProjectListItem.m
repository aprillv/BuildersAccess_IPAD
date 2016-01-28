/*
	wcfProjectListItem.h
	The implementation of properties and methods for the wcfProjectListItem object.
	Generated by SudzC.com
*/
#import "wcfProjectListItem.h"

@implementation wcfProjectListItem
	@synthesize IDNumber = _IDNumber;
	@synthesize Idcia = _Idcia;
	@synthesize Idfloorplan = _Idfloorplan;
	@synthesize Ncia = _Ncia;
	@synthesize PlanName = _PlanName;
	@synthesize ProjectName = _ProjectName;
	@synthesize StageItem = _StageItem;
	@synthesize Status = _Status;
	@synthesize TotalPage = _TotalPage;

	- (id) init
	{
		if(self = [super init])
		{
			self.IDNumber = nil;
			self.Idcia = nil;
			self.Idfloorplan = nil;
			self.Ncia = nil;
			self.PlanName = nil;
			self.ProjectName = nil;
			self.Status = nil;

		}
		return self;
	}

	+ (wcfProjectListItem*) newWithNode: (CXMLNode*) node
	{
		if(node == nil) { return nil; }
		return (wcfProjectListItem*)[[[wcfProjectListItem alloc] initWithNode: node] autorelease];
	}

	- (id) initWithNode: (CXMLNode*) node {
		if(self = [super initWithNode: node])
		{
			self.IDNumber = [Soap getNodeValue: node withName: @"IDNumber"];
			self.Idcia = [Soap getNodeValue: node withName: @"Idcia"];
			self.Idfloorplan = [Soap getNodeValue: node withName: @"Idfloorplan"];
			self.Ncia = [Soap getNodeValue: node withName: @"Ncia"];
			self.PlanName = [Soap getNodeValue: node withName: @"PlanName"];
			self.ProjectName = [Soap getNodeValue: node withName: @"ProjectName"];
			self.StageItem = [[Soap getNodeValue: node withName: @"StageItem"] intValue];
			self.Status = [Soap getNodeValue: node withName: @"Status"];
			self.TotalPage = [[Soap getNodeValue: node withName: @"TotalPage"] intValue];
		}
		return self;
	}

	- (NSMutableString*) serialize
	{
		return [self serialize: @"ProjectListItem"];
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
		if (self.IDNumber != nil) [s appendFormat: @"<IDNumber>%@</IDNumber>", [[self.IDNumber stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Idcia != nil) [s appendFormat: @"<Idcia>%@</Idcia>", [[self.Idcia stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Idfloorplan != nil) [s appendFormat: @"<Idfloorplan>%@</Idfloorplan>", [[self.Idfloorplan stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Ncia != nil) [s appendFormat: @"<Ncia>%@</Ncia>", [[self.Ncia stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.PlanName != nil) [s appendFormat: @"<PlanName>%@</PlanName>", [[self.PlanName stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.ProjectName != nil) [s appendFormat: @"<ProjectName>%@</ProjectName>", [[self.ProjectName stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		[s appendFormat: @"<StageItem>%@</StageItem>", [NSString stringWithFormat: @"%i", self.StageItem]];
		if (self.Status != nil) [s appendFormat: @"<Status>%@</Status>", [[self.Status stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		[s appendFormat: @"<TotalPage>%@</TotalPage>", [NSString stringWithFormat: @"%i", self.TotalPage]];

		return s;
	}
	
	- (NSMutableString*) serializeAttributes
	{
		NSMutableString* s = [super serializeAttributes];

		return s;
	}
	
	-(BOOL)isEqual:(id)object{
		if(object != nil && [object isKindOfClass:[wcfProjectListItem class]]) {
			return [[self serialize] isEqualToString:[object serialize]];
		}
		return NO;
	}
	
	-(NSUInteger)hash{
		return [Soap generateHash:self];

	}
	
	- (void) dealloc
	{
		if(self.IDNumber != nil) { [self.IDNumber release]; }
		if(self.Idcia != nil) { [self.Idcia release]; }
		if(self.Idfloorplan != nil) { [self.Idfloorplan release]; }
		if(self.Ncia != nil) { [self.Ncia release]; }
		if(self.PlanName != nil) { [self.PlanName release]; }
		if(self.ProjectName != nil) { [self.ProjectName release]; }
		if(self.Status != nil) { [self.Status release]; }
		[super dealloc];
	}

@end
