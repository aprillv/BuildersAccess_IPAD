/*
	wcfCODetail.h
	The implementation of properties and methods for the wcfCODetail object.
	Generated by SudzC.com
*/
#import "wcfCODetail.h"

#import "wcfArrayOfCOOrderDetail.h"
@implementation wcfCODetail
	@synthesize Acknowledge = _Acknowledge;
	@synthesize ApproveOrder = _ApproveOrder;
	@synthesize Asking = _Asking;
	@synthesize Baths = _Baths;
	@synthesize Bedrooms = _Bedrooms;
	@synthesize Buyer = _Buyer;
	@synthesize Disapprove = _Disapprove;
	@synthesize Garage = _Garage;
	@synthesize IDFloorplan = _IDFloorplan;
	@synthesize Iddoc = _Iddoc;
	@synthesize Idnumber = _Idnumber;
	@synthesize Increase = _Increase;
	@synthesize Newprice = _Newprice;
	@synthesize Nproject = _Nproject;
	@synthesize OrderDetailList = _OrderDetailList;
	@synthesize PM1 = _PM1;
	@synthesize PlanName = _PlanName;
	@synthesize ProjectStatus = _ProjectStatus;
	@synthesize Repeated = _Repeated;
	@synthesize RequestPMAcknowledge = _RequestPMAcknowledge;
	@synthesize Reverseyn = _Reverseyn;
	@synthesize Sales1 = _Sales1;
	@synthesize Stage = _Stage;
	@synthesize Status = _Status;
	@synthesize idproject = _idproject;

	- (id) init
	{
		if(self = [super init])
		{
			self.Acknowledge = nil;
			self.ApproveOrder = nil;
			self.Asking = nil;
			self.Baths = nil;
			self.Bedrooms = nil;
			self.Buyer = nil;
			self.Disapprove = nil;
			self.Garage = nil;
			self.IDFloorplan = nil;
			self.Iddoc = nil;
			self.Idnumber = nil;
			self.Increase = nil;
			self.Newprice = nil;
			self.Nproject = nil;
			self.OrderDetailList = [[[NSMutableArray alloc] init] autorelease];
			self.PM1 = nil;
			self.PlanName = nil;
			self.ProjectStatus = nil;
			self.RequestPMAcknowledge = nil;
			self.Sales1 = nil;
			self.Stage = nil;
			self.Status = nil;
			self.idproject = nil;

		}
		return self;
	}

	+ (wcfCODetail*) newWithNode: (CXMLNode*) node
	{
		if(node == nil) { return nil; }
		return (wcfCODetail*)[[[wcfCODetail alloc] initWithNode: node] autorelease];
	}

	- (id) initWithNode: (CXMLNode*) node {
		if(self = [super initWithNode: node])
		{
			self.Acknowledge = [Soap getNodeValue: node withName: @"Acknowledge"];
			self.ApproveOrder = [Soap getNodeValue: node withName: @"ApproveOrder"];
			self.Asking = [Soap getNodeValue: node withName: @"Asking"];
			self.Baths = [Soap getNodeValue: node withName: @"Baths"];
			self.Bedrooms = [Soap getNodeValue: node withName: @"Bedrooms"];
			self.Buyer = [Soap getNodeValue: node withName: @"Buyer"];
			self.Disapprove = [Soap getNodeValue: node withName: @"Disapprove"];
			self.Garage = [Soap getNodeValue: node withName: @"Garage"];
			self.IDFloorplan = [Soap getNodeValue: node withName: @"IDFloorplan"];
			self.Iddoc = [Soap getNodeValue: node withName: @"Iddoc"];
			self.Idnumber = [Soap getNodeValue: node withName: @"Idnumber"];
			self.Increase = [Soap getNodeValue: node withName: @"Increase"];
			self.Newprice = [Soap getNodeValue: node withName: @"Newprice"];
			self.Nproject = [Soap getNodeValue: node withName: @"Nproject"];
			self.OrderDetailList = [[wcfArrayOfCOOrderDetail newWithNode: [Soap getNode: node withName: @"OrderDetailList"]] object];
			self.PM1 = [Soap getNodeValue: node withName: @"PM1"];
			self.PlanName = [Soap getNodeValue: node withName: @"PlanName"];
			self.ProjectStatus = [Soap getNodeValue: node withName: @"ProjectStatus"];
			self.Repeated = [[Soap getNodeValue: node withName: @"Repeated"] boolValue];
			self.RequestPMAcknowledge = [Soap getNodeValue: node withName: @"RequestPMAcknowledge"];
			self.Reverseyn = [[Soap getNodeValue: node withName: @"Reverseyn"] boolValue];
			self.Sales1 = [Soap getNodeValue: node withName: @"Sales1"];
			self.Stage = [Soap getNodeValue: node withName: @"Stage"];
			self.Status = [Soap getNodeValue: node withName: @"Status"];
			self.idproject = [Soap getNodeValue: node withName: @"idproject"];
		}
		return self;
	}

	- (NSMutableString*) serialize
	{
		return [self serialize: @"CODetail"];
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
		if (self.Acknowledge != nil) [s appendFormat: @"<Acknowledge>%@</Acknowledge>", [[self.Acknowledge stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.ApproveOrder != nil) [s appendFormat: @"<ApproveOrder>%@</ApproveOrder>", [[self.ApproveOrder stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Asking != nil) [s appendFormat: @"<Asking>%@</Asking>", [[self.Asking stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Baths != nil) [s appendFormat: @"<Baths>%@</Baths>", [[self.Baths stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Bedrooms != nil) [s appendFormat: @"<Bedrooms>%@</Bedrooms>", [[self.Bedrooms stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Buyer != nil) [s appendFormat: @"<Buyer>%@</Buyer>", [[self.Buyer stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Disapprove != nil) [s appendFormat: @"<Disapprove>%@</Disapprove>", [[self.Disapprove stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Garage != nil) [s appendFormat: @"<Garage>%@</Garage>", [[self.Garage stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.IDFloorplan != nil) [s appendFormat: @"<IDFloorplan>%@</IDFloorplan>", [[self.IDFloorplan stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Iddoc != nil) [s appendFormat: @"<Iddoc>%@</Iddoc>", [[self.Iddoc stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Idnumber != nil) [s appendFormat: @"<Idnumber>%@</Idnumber>", [[self.Idnumber stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Increase != nil) [s appendFormat: @"<Increase>%@</Increase>", [[self.Increase stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Newprice != nil) [s appendFormat: @"<Newprice>%@</Newprice>", [[self.Newprice stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Nproject != nil) [s appendFormat: @"<Nproject>%@</Nproject>", [[self.Nproject stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.OrderDetailList != nil && self.OrderDetailList.count > 0) {
			[s appendFormat: @"<OrderDetailList>%@</OrderDetailList>", [wcfArrayOfCOOrderDetail serialize: self.OrderDetailList]];
		} else {
			[s appendString: @"<OrderDetailList/>"];
		}
		if (self.PM1 != nil) [s appendFormat: @"<PM1>%@</PM1>", [[self.PM1 stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.PlanName != nil) [s appendFormat: @"<PlanName>%@</PlanName>", [[self.PlanName stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.ProjectStatus != nil) [s appendFormat: @"<ProjectStatus>%@</ProjectStatus>", [[self.ProjectStatus stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		[s appendFormat: @"<Repeated>%@</Repeated>", (self.Repeated)?@"true":@"false"];
		if (self.RequestPMAcknowledge != nil) [s appendFormat: @"<RequestPMAcknowledge>%@</RequestPMAcknowledge>", [[self.RequestPMAcknowledge stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		[s appendFormat: @"<Reverseyn>%@</Reverseyn>", (self.Reverseyn)?@"true":@"false"];
		if (self.Sales1 != nil) [s appendFormat: @"<Sales1>%@</Sales1>", [[self.Sales1 stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Stage != nil) [s appendFormat: @"<Stage>%@</Stage>", [[self.Stage stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.Status != nil) [s appendFormat: @"<Status>%@</Status>", [[self.Status stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];
		if (self.idproject != nil) [s appendFormat: @"<idproject>%@</idproject>", [[self.idproject stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"] stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]];

		return s;
	}
	
	- (NSMutableString*) serializeAttributes
	{
		NSMutableString* s = [super serializeAttributes];

		return s;
	}
	
	-(BOOL)isEqual:(id)object{
		if(object != nil && [object isKindOfClass:[wcfCODetail class]]) {
			return [[self serialize] isEqualToString:[object serialize]];
		}
		return NO;
	}
	
	-(NSUInteger)hash{
		return [Soap generateHash:self];

	}
	
	- (void) dealloc
	{
		if(self.Acknowledge != nil) { [self.Acknowledge release]; }
		if(self.ApproveOrder != nil) { [self.ApproveOrder release]; }
		if(self.Asking != nil) { [self.Asking release]; }
		if(self.Baths != nil) { [self.Baths release]; }
		if(self.Bedrooms != nil) { [self.Bedrooms release]; }
		if(self.Buyer != nil) { [self.Buyer release]; }
		if(self.Disapprove != nil) { [self.Disapprove release]; }
		if(self.Garage != nil) { [self.Garage release]; }
		if(self.IDFloorplan != nil) { [self.IDFloorplan release]; }
		if(self.Iddoc != nil) { [self.Iddoc release]; }
		if(self.Idnumber != nil) { [self.Idnumber release]; }
		if(self.Increase != nil) { [self.Increase release]; }
		if(self.Newprice != nil) { [self.Newprice release]; }
		if(self.Nproject != nil) { [self.Nproject release]; }
		if(self.OrderDetailList != nil) { [self.OrderDetailList release]; }
		if(self.PM1 != nil) { [self.PM1 release]; }
		if(self.PlanName != nil) { [self.PlanName release]; }
		if(self.ProjectStatus != nil) { [self.ProjectStatus release]; }
		if(self.RequestPMAcknowledge != nil) { [self.RequestPMAcknowledge release]; }
		if(self.Sales1 != nil) { [self.Sales1 release]; }
		if(self.Stage != nil) { [self.Stage release]; }
		if(self.Status != nil) { [self.Status release]; }
		if(self.idproject != nil) { [self.idproject release]; }
		[super dealloc];
	}

@end
