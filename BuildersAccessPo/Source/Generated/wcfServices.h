/*
	wcfServices.h
	Creates a list of the services available with the wcf prefix.
	Generated by SudzC.com
*/
#import "wcfService.h"

@interface wcfServices : NSObject {
	BOOL logging;
	NSString* server;
	NSString* defaultServer;
wcfService* service;

}

-(id)initWithServer:(NSString*)serverName;
-(void)updateService:(SoapService*)service;
-(void)updateServices;
+(wcfServices*)service;
+(wcfServices*)serviceWithServer:(NSString*)serverName;

@property (nonatomic) BOOL logging;
@property (nonatomic, retain) NSString* server;
@property (nonatomic, retain) NSString* defaultServer;

@property (nonatomic, retain, readonly) wcfService* service;

@end
			