/*
	wcfProjectItem.h
	The implementation of properties and methods for the wcfProjectItem object.
	Generated by SudzC.com
*/
#import "wcfProjectItem.h"

@implementation wcfProjectItem
	@synthesize ActiveUnits = _ActiveUnits;
	@synthesize AddPMNotes = _AddPMNotes;
	@synthesize AddPhoto = _AddPhoto;
	@synthesize ArchiveYN = _ArchiveYN;
	@synthesize Asking = _Asking;
	@synthesize Askingyn = _Askingyn;
	@synthesize BasePlanyn = _BasePlanyn;
	@synthesize Baths = _Baths;
	@synthesize Bedrooms = _Bedrooms;
	@synthesize Block = _Block;
	@synthesize Brochure = _Brochure;
	@synthesize BrochureLength = _BrochureLength;
	@synthesize City = _City;
	@synthesize ClosedUnits = _ClosedUnits;
	@synthesize Elovecia = _Elovecia;
	@synthesize ForPermitting = _ForPermitting;
	@synthesize Garage = _Garage;
	@synthesize HasVendorYN = _HasVendorYN;
	@synthesize IDFloorplan = _IDFloorplan;
	@synthesize IdContract = _IdContract;
	@synthesize IdQaInspection = _IdQaInspection;
	@synthesize Lot = _Lot;
	@synthesize Name = _Name;
	@synthesize PM1 = _PM1;
	@synthesize PM1Email = _PM1Email;
	@synthesize PM2 = _PM2;
	@synthesize PM2Email = _PM2Email;
	@synthesize PM3 = _PM3;
	@synthesize PM3Email = _PM3Email;
	@synthesize PM4 = _PM4;
	@synthesize PM4Email = _PM4Email;
	@synthesize Permit = _Permit;
	@synthesize PlanName = _PlanName;
	@synthesize Repeated = _Repeated;
	@synthesize Reverseyn = _Reverseyn;
	@synthesize Revision = _Revision;
	@synthesize Sales1 = _Sales1;
	@synthesize Sales1Email = _Sales1Email;
	@synthesize Sales2 = _Sales2;
	@synthesize Sales2Email = _Sales2Email;
	@synthesize Section = _Section;
	@synthesize SiteMapyn = _SiteMapyn;
	@synthesize Sold = _Sold;
	@synthesize SoldUnits = _SoldUnits;
	@synthesize SpecsUnits = _SpecsUnits;
	@synthesize Stage = _Stage;
	@synthesize Status = _Status;
	@synthesize TotalUnits = _TotalUnits;
	@synthesize UnderRevision = _UnderRevision;
	@synthesize coyn = _coyn;
	@synthesize mastercia = _mastercia;
	@synthesize poyn = _poyn;
	@synthesize requestvpo = _requestvpo;
	@synthesize sqft = _sqft;

	- (id) init
	{
		if(self = [super init])
		{
			self.AddPMNotes = nil;
			self.AddPhoto = nil;
			self.Asking = nil;
			self.Baths = nil;
			self.Bedrooms = nil;
			self.Block = nil;
			self.BrochureLength = nil;
			self.City = nil;
			self.Elovecia = nil;
			self.Garage = nil;
			self.IDFloorplan = nil;
			self.IdContract = nil;
			self.IdQaInspection = nil;
			self.Lot = nil;
			self.Name = nil;
			self.PM1 = nil;
			self.PM1Email = nil;
			self.PM2 = nil;
			self.PM2Email = nil;
			self.PM3 = nil;
			self.PM3Email = nil;
			self.PM4 = nil;
			self.PM4Email = nil;
			self.Permit = nil;
			self.PlanName = nil;
			self.Sales1 = nil;
			self.Sales1Email = nil;
			self.Sales2 = nil;
			self.Sales2Email = nil;
			self.Section = nil;
			self.Sold = nil;
			self.Stage = nil;
			self.Status = nil;
			self.mastercia = nil;
			self.requestvpo = nil;
			self.sqft = nil;

		}
		return self;
	}

	+ (wcfProjectItem*) newWithNode: (CXMLNode*) node
	{
		if(node == nil) { return nil; }
		return (wcfProjectItem*)[[[wcfProjectItem alloc] initWithNode: node] autorelease];
	}

	- (id) initWithNode: (CXMLNode*) node {
		if(self = [super initWithNode: node])
		{
			self.ActiveUnits = [[Soap getNodeValue: node withName: @"ActiveUnits"] intValue];
			self.AddPMNotes = [Soap getNodeValue: node withName: @"AddPMNotes"];
			self.AddPhoto = [Soap getNodeValue: node withName: @"AddPhoto"];
			self.ArchiveYN = [[Soap getNodeValue: node withName: @"ArchiveYN"] boolValue];
			self.Asking = [Soap getNodeValue: node withName: @"Asking"];
			self.Askingyn = [[Soap getNodeValue: node withName: @"Askingyn"] boolValue];
			self.BasePlanyn = [[Soap getNodeValue: node withName: @"BasePlanyn"] boolValue];
			self.Baths = [Soap getNodeValue: node withName: @"Baths"];
			self.Bedrooms = [Soap getNodeValue: node withName: @"Bedrooms"];
			self.Block = [Soap getNodeValue: node withName: @"Block"];
			self.Brochure = [[Soap getNodeValue: node withName: @"Brochure"] boolValue];
			self.BrochureLength = [Soap getNodeValue: node withName: @"BrochureLength"];
			self.City = [Soap getNodeValue: node withName: @"City"];
			self.ClosedUnits = [[Soap getNodeValue: node withName: @"ClosedUnits"] intValue];
			self.Elovecia = [Soap getNodeValue: node withName: @"Elovecia"];
			self.ForPermitting = [[Soap getNodeValue: node withName: @"ForPermitting"] boolValue];
			self.Garage = [Soap getNodeValue: node withName: @"Garage"];
			self.HasVendorYN = [[Soap getNodeValue: node withName: @"HasVendorYN"] boolValue];
			self.IDFloorplan = [Soap getNodeValue: node withName: @"IDFloorplan"];
			self.IdContract = [Soap getNodeValue: node withName: @"IdContract"];
			self.IdQaInspection = [Soap getNodeValue: node withName: @"IdQaInspection"];
			self.Lot = [Soap getNodeValue: node withName: @"Lot"];
			self.Name = [Soap getNodeValue: node withName: @"Name"];
			self.PM1 = [Soap getNodeValue: node withName: @"PM1"];
			self.PM1Email = [Soap getNodeValue: node withName: @"PM1Email"];
			self.PM2 = [Soap getNodeValue: node withName: @"PM2"];
			self.PM2Email = [Soap getNodeValue: node withName: @"PM2Email"];
			self.PM3 = [Soap getNodeValue: node withName: @"PM3"];
			self.PM3Email = [Soap getNodeValue: node withName: @"PM3Email"];
			self.PM4 = [Soap getNodeValue: node withName: @"PM4"];
			self.PM4Email = [Soap getNodeValue: node withName: @"PM4Email"];
			self.Permit = [Soap getNodeValue: node withName: @"Permit"];
			self.PlanName = [Soap getNodeValue: node withName: @"PlanName"];
			self.Repeated = [[Soap getNodeValue: node withName: @"Repeated"] boolValue];
			self.Reverseyn = [[Soap getNodeValue: node withName: @"Reverseyn"] boolValue];
			self.Revision = [[Soap getNodeValue: node withName: @"Revision"] intValue];
			self.Sales1 = [Soap getNodeValue: node withName: @"Sales1"];
			self.Sales1Email = [Soap getNodeValue: node withName: @"Sales1Email"];
			self.Sales2 = [Soap getNodeValue: node withName: @"Sales2"];
			self.Sales2Email = [Soap getNodeValue: node withName: @"Sales2Email"];
			self.Section = [Soap getNodeValue: node withName: @"Section"];
			self.SiteMapyn = [[Soap getNodeValue: node withName: @"SiteMapyn"] boolValue];
			self.Sold = [Soap getNodeValue: node withName: @"Sold"];
			self.SoldUnits = [[Soap getNodeValue: node withName: @"SoldUnits"] intValue];
			self.SpecsUnits = [[Soap getNodeValue: node withName: @"SpecsUnits"] intValue];
			self.Stage = [Soap getNodeValue: node withName: @"Stage"];
			self.Status = [Soap getNodeValue: node withName: @"Status"];
			self.TotalUnits = [[Soap getNodeValue: node withName: @"TotalUnits"] intValue];
			self.UnderRevision = [[Soap getNodeValue: node withName: @"UnderRevision"] boolValue];
			self.coyn = [[Soap getNodeValue: node withName: @"coyn"] boolValue];
			self.mastercia = [Soap getNodeValue: node withName: @"mastercia"];
			self.poyn = [[Soap getNodeValue: node withName: @"poyn"] boolValue];
			self.requestvpo = [Soap getNodeValue: node withName: @"requestvpo"];
			self.sqft = [Soap getNodeValue: node withName: @"sqft"];
		}
		return self;
	}

	- (NSMutableString*) serialize
	{
		return [self serialize: @"ProjectItem"];
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
		[s appendFormat: @"<ActiveUnits>%@</ActiveUnits>", [NSString stringWithFormat: @"%i", self.ActiveUnits]];
		if (self.AddPMNotes != nil) [s appendFormat: @"<AddPMNotes>%@</AddPMNotes>", [[self.AddPMNotes stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.AddPhoto != nil) [s appendFormat: @"<AddPhoto>%@</AddPhoto>", [[self.AddPhoto stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		[s appendFormat: @"<ArchiveYN>%@</ArchiveYN>", (self.ArchiveYN)?@"true":@"false"];
		if (self.Asking != nil) [s appendFormat: @"<Asking>%@</Asking>", [[self.Asking stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		[s appendFormat: @"<Askingyn>%@</Askingyn>", (self.Askingyn)?@"true":@"false"];
		[s appendFormat: @"<BasePlanyn>%@</BasePlanyn>", (self.BasePlanyn)?@"true":@"false"];
		if (self.Baths != nil) [s appendFormat: @"<Baths>%@</Baths>", [[self.Baths stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Bedrooms != nil) [s appendFormat: @"<Bedrooms>%@</Bedrooms>", [[self.Bedrooms stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Block != nil) [s appendFormat: @"<Block>%@</Block>", [[self.Block stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		[s appendFormat: @"<Brochure>%@</Brochure>", (self.Brochure)?@"true":@"false"];
		if (self.BrochureLength != nil) [s appendFormat: @"<BrochureLength>%@</BrochureLength>", [[self.BrochureLength stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.City != nil) [s appendFormat: @"<City>%@</City>", [[self.City stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		[s appendFormat: @"<ClosedUnits>%@</ClosedUnits>", [NSString stringWithFormat: @"%i", self.ClosedUnits]];
		if (self.Elovecia != nil) [s appendFormat: @"<Elovecia>%@</Elovecia>", [[self.Elovecia stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		[s appendFormat: @"<ForPermitting>%@</ForPermitting>", (self.ForPermitting)?@"true":@"false"];
		if (self.Garage != nil) [s appendFormat: @"<Garage>%@</Garage>", [[self.Garage stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		[s appendFormat: @"<HasVendorYN>%@</HasVendorYN>", (self.HasVendorYN)?@"true":@"false"];
		if (self.IDFloorplan != nil) [s appendFormat: @"<IDFloorplan>%@</IDFloorplan>", [[self.IDFloorplan stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.IdContract != nil) [s appendFormat: @"<IdContract>%@</IdContract>", [[self.IdContract stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.IdQaInspection != nil) [s appendFormat: @"<IdQaInspection>%@</IdQaInspection>", [[self.IdQaInspection stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Lot != nil) [s appendFormat: @"<Lot>%@</Lot>", [[self.Lot stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Name != nil) [s appendFormat: @"<Name>%@</Name>", [[self.Name stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.PM1 != nil) [s appendFormat: @"<PM1>%@</PM1>", [[self.PM1 stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.PM1Email != nil) [s appendFormat: @"<PM1Email>%@</PM1Email>", [[self.PM1Email stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.PM2 != nil) [s appendFormat: @"<PM2>%@</PM2>", [[self.PM2 stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.PM2Email != nil) [s appendFormat: @"<PM2Email>%@</PM2Email>", [[self.PM2Email stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.PM3 != nil) [s appendFormat: @"<PM3>%@</PM3>", [[self.PM3 stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.PM3Email != nil) [s appendFormat: @"<PM3Email>%@</PM3Email>", [[self.PM3Email stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.PM4 != nil) [s appendFormat: @"<PM4>%@</PM4>", [[self.PM4 stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.PM4Email != nil) [s appendFormat: @"<PM4Email>%@</PM4Email>", [[self.PM4Email stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Permit != nil) [s appendFormat: @"<Permit>%@</Permit>", [[self.Permit stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.PlanName != nil) [s appendFormat: @"<PlanName>%@</PlanName>", [[self.PlanName stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		[s appendFormat: @"<Repeated>%@</Repeated>", (self.Repeated)?@"true":@"false"];
		[s appendFormat: @"<Reverseyn>%@</Reverseyn>", (self.Reverseyn)?@"true":@"false"];
		[s appendFormat: @"<Revision>%@</Revision>", [NSString stringWithFormat: @"%i", self.Revision]];
		if (self.Sales1 != nil) [s appendFormat: @"<Sales1>%@</Sales1>", [[self.Sales1 stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Sales1Email != nil) [s appendFormat: @"<Sales1Email>%@</Sales1Email>", [[self.Sales1Email stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Sales2 != nil) [s appendFormat: @"<Sales2>%@</Sales2>", [[self.Sales2 stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Sales2Email != nil) [s appendFormat: @"<Sales2Email>%@</Sales2Email>", [[self.Sales2Email stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Section != nil) [s appendFormat: @"<Section>%@</Section>", [[self.Section stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		[s appendFormat: @"<SiteMapyn>%@</SiteMapyn>", (self.SiteMapyn)?@"true":@"false"];
		if (self.Sold != nil) [s appendFormat: @"<Sold>%@</Sold>", [[self.Sold stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		[s appendFormat: @"<SoldUnits>%@</SoldUnits>", [NSString stringWithFormat: @"%i", self.SoldUnits]];
		[s appendFormat: @"<SpecsUnits>%@</SpecsUnits>", [NSString stringWithFormat: @"%i", self.SpecsUnits]];
		if (self.Stage != nil) [s appendFormat: @"<Stage>%@</Stage>", [[self.Stage stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Status != nil) [s appendFormat: @"<Status>%@</Status>", [[self.Status stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		[s appendFormat: @"<TotalUnits>%@</TotalUnits>", [NSString stringWithFormat: @"%i", self.TotalUnits]];
		[s appendFormat: @"<UnderRevision>%@</UnderRevision>", (self.UnderRevision)?@"true":@"false"];
		[s appendFormat: @"<coyn>%@</coyn>", (self.coyn)?@"true":@"false"];
		if (self.mastercia != nil) [s appendFormat: @"<mastercia>%@</mastercia>", [[self.mastercia stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		[s appendFormat: @"<poyn>%@</poyn>", (self.poyn)?@"true":@"false"];
		if (self.requestvpo != nil) [s appendFormat: @"<requestvpo>%@</requestvpo>", [[self.requestvpo stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.sqft != nil) [s appendFormat: @"<sqft>%@</sqft>", [[self.sqft stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];

		return s;
	}
	
	- (NSMutableString*) serializeAttributes
	{
		NSMutableString* s = [super serializeAttributes];

		return s;
	}
	
	-(BOOL)isEqual:(id)object{
		if(object != nil && [object isKindOfClass:[wcfProjectItem class]]) {
			return [[self serialize] isEqualToString:[object serialize]];
		}
		return NO;
	}
	
	-(NSUInteger)hash{
		return [Soap generateHash:self];

	}
	
	- (void) dealloc
	{
		if(self.AddPMNotes != nil) { [self.AddPMNotes release]; }
		if(self.AddPhoto != nil) { [self.AddPhoto release]; }
		if(self.Asking != nil) { [self.Asking release]; }
		if(self.Baths != nil) { [self.Baths release]; }
		if(self.Bedrooms != nil) { [self.Bedrooms release]; }
		if(self.Block != nil) { [self.Block release]; }
		if(self.BrochureLength != nil) { [self.BrochureLength release]; }
		if(self.City != nil) { [self.City release]; }
		if(self.Elovecia != nil) { [self.Elovecia release]; }
		if(self.Garage != nil) { [self.Garage release]; }
		if(self.IDFloorplan != nil) { [self.IDFloorplan release]; }
		if(self.IdContract != nil) { [self.IdContract release]; }
		if(self.IdQaInspection != nil) { [self.IdQaInspection release]; }
		if(self.Lot != nil) { [self.Lot release]; }
		if(self.Name != nil) { [self.Name release]; }
		if(self.PM1 != nil) { [self.PM1 release]; }
		if(self.PM1Email != nil) { [self.PM1Email release]; }
		if(self.PM2 != nil) { [self.PM2 release]; }
		if(self.PM2Email != nil) { [self.PM2Email release]; }
		if(self.PM3 != nil) { [self.PM3 release]; }
		if(self.PM3Email != nil) { [self.PM3Email release]; }
		if(self.PM4 != nil) { [self.PM4 release]; }
		if(self.PM4Email != nil) { [self.PM4Email release]; }
		if(self.Permit != nil) { [self.Permit release]; }
		if(self.PlanName != nil) { [self.PlanName release]; }
		if(self.Sales1 != nil) { [self.Sales1 release]; }
		if(self.Sales1Email != nil) { [self.Sales1Email release]; }
		if(self.Sales2 != nil) { [self.Sales2 release]; }
		if(self.Sales2Email != nil) { [self.Sales2Email release]; }
		if(self.Section != nil) { [self.Section release]; }
		if(self.Sold != nil) { [self.Sold release]; }
		if(self.Stage != nil) { [self.Stage release]; }
		if(self.Status != nil) { [self.Status release]; }
		if(self.mastercia != nil) { [self.mastercia release]; }
		if(self.requestvpo != nil) { [self.requestvpo release]; }
		if(self.sqft != nil) { [self.sqft release]; }
		[super dealloc];
	}

@end