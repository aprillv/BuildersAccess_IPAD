/*
	wcfStartPackItem.h
	The interface definition of properties and methods for the wcfStartPackItem object.
	Generated by SudzC.com
*/

#import "Soap.h"
	

@interface wcfStartPackItem : SoapObject
{
	NSString* _By;
	NSString* _IDNumber;
	NSString* _Item;
	NSString* _MValue;
	NSString* _StartPack;
	NSString* _Type;
	NSString* _Upd;
	NSString* _Updated;
	NSString* _idproject;
	NSString* _nproject;
	
}
		
	@property (retain, nonatomic) NSString* By;
	@property (retain, nonatomic) NSString* IDNumber;
	@property (retain, nonatomic) NSString* Item;
	@property (retain, nonatomic) NSString* MValue;
	@property (retain, nonatomic) NSString* StartPack;
	@property (retain, nonatomic) NSString* Type;
	@property (retain, nonatomic) NSString* Upd;
	@property (retain, nonatomic) NSString* Updated;
	@property (retain, nonatomic) NSString* idproject;
	@property (retain, nonatomic) NSString* nproject;

	+ (wcfStartPackItem*) newWithNode: (CXMLNode*) node;
	- (id) initWithNode: (CXMLNode*) node;
	- (NSMutableString*) serialize;
	- (NSMutableString*) serialize: (NSString*) nodeName;
	- (NSMutableString*) serializeAttributes;
	- (NSMutableString*) serializeElements;

@end
