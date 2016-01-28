/*
	wcfProjectSchedule.h
	The interface definition of properties and methods for the wcfProjectSchedule object.
	Generated by SudzC.com
*/

#import "Soap.h"
	

@interface wcfProjectSchedule : SoapObject
{
	NSString* _Dcomplete;
	BOOL _DcompleteYN;
	NSString* _Dstart;
	NSString* _Item;
	NSString* _MilestoneDstart;
	NSString* _Name;
	NSString* _Notes;
	BOOL _canEdit;
	
}
		
	@property (retain, nonatomic) NSString* Dcomplete;
	@property BOOL DcompleteYN;
	@property (retain, nonatomic) NSString* Dstart;
	@property (retain, nonatomic) NSString* Item;
	@property (retain, nonatomic) NSString* MilestoneDstart;
	@property (retain, nonatomic) NSString* Name;
	@property (retain, nonatomic) NSString* Notes;
@property  BOOL DcompleteYN2;
@property (retain, nonatomic) NSString*DcompleteNew;


	@property BOOL canEdit;

	+ (wcfProjectSchedule*) newWithNode: (CXMLNode*) node;
	- (id) initWithNode: (CXMLNode*) node;
	- (NSMutableString*) serialize;
	- (NSMutableString*) serialize: (NSString*) nodeName;
	- (NSMutableString*) serializeAttributes;
	- (NSMutableString*) serializeElements;

@end
