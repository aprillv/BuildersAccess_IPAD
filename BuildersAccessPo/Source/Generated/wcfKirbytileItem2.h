/*
	wcfKirbytileItem2.h
	The interface definition of properties and methods for the wcfKirbytileItem2 object.
	Generated by SudzC.com
*/

#import "Soap.h"
	

@interface wcfKirbytileItem2 : SoapObject
{
	NSString* _Color;
	NSString* _Idnumber;
	NSString* _MDate;
	NSString* _Name;
	
}
		
	@property (retain, nonatomic) NSString* Color;
	@property (retain, nonatomic) NSString* Idnumber;
	@property (retain, nonatomic) NSString* MDate;
	@property (retain, nonatomic) NSString* Name;

	+ (wcfKirbytileItem2*) newWithNode: (CXMLNode*) node;
	- (id) initWithNode: (CXMLNode*) node;
	- (NSMutableString*) serialize;
	- (NSMutableString*) serialize: (NSString*) nodeName;
	- (NSMutableString*) serializeAttributes;
	- (NSMutableString*) serializeElements;

@end
