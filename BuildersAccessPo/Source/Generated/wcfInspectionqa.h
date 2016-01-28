/*
	wcfInspectionqa.h
	The interface definition of properties and methods for the wcfInspectionqa object.
	Generated by SudzC.com
*/

#import "Soap.h"
	

@interface wcfInspectionqa : SoapObject
{
	NSString* _AssignTo;
	NSString* _Inspection;
	NSString* _NotReady;
	NSString* _Notes;
	NSString* _Nproejct;
	NSString* _Ready;
	
}
		
	@property (retain, nonatomic) NSString* AssignTo;
	@property (retain, nonatomic) NSString* Inspection;
	@property (retain, nonatomic) NSString* NotReady;
	@property (retain, nonatomic) NSString* Notes;
	@property (retain, nonatomic) NSString* Nproejct;
	@property (retain, nonatomic) NSString* Ready;

	+ (wcfInspectionqa*) newWithNode: (CXMLNode*) node;
	- (id) initWithNode: (CXMLNode*) node;
	- (NSMutableString*) serialize;
	- (NSMutableString*) serialize: (NSString*) nodeName;
	- (NSMutableString*) serializeAttributes;
	- (NSMutableString*) serializeElements;

@end