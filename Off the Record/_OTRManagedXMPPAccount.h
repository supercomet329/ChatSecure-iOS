// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to OTRManagedXMPPAccount.h instead.

#import <CoreData/CoreData.h>
#import "OTRManagedAccount.h"

extern const struct OTRManagedXMPPAccountAttributes {
	__unsafe_unretained NSString *allowSSLHostNameMismatch;
	__unsafe_unretained NSString *allowSelfSignedSSL;
	__unsafe_unretained NSString *domain;
	__unsafe_unretained NSString *port;
	__unsafe_unretained NSString *sendDeliveryReceipts;
	__unsafe_unretained NSString *sendTypingNotifications;
} OTRManagedXMPPAccountAttributes;

extern const struct OTRManagedXMPPAccountRelationships {
} OTRManagedXMPPAccountRelationships;

extern const struct OTRManagedXMPPAccountFetchedProperties {
} OTRManagedXMPPAccountFetchedProperties;









@interface OTRManagedXMPPAccountID : NSManagedObjectID {}
@end

@interface _OTRManagedXMPPAccount : OTRManagedAccount {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (OTRManagedXMPPAccountID*)objectID;





@property (nonatomic, strong) NSNumber* allowSSLHostNameMismatch;



@property BOOL allowSSLHostNameMismatchValue;
- (BOOL)allowSSLHostNameMismatchValue;
- (void)setAllowSSLHostNameMismatchValue:(BOOL)value_;

//- (BOOL)validateAllowSSLHostNameMismatch:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* allowSelfSignedSSL;



@property BOOL allowSelfSignedSSLValue;
- (BOOL)allowSelfSignedSSLValue;
- (void)setAllowSelfSignedSSLValue:(BOOL)value_;

//- (BOOL)validateAllowSelfSignedSSL:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* domain;



//- (BOOL)validateDomain:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* port;



@property int16_t portValue;
- (int16_t)portValue;
- (void)setPortValue:(int16_t)value_;

//- (BOOL)validatePort:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* sendDeliveryReceipts;



@property BOOL sendDeliveryReceiptsValue;
- (BOOL)sendDeliveryReceiptsValue;
- (void)setSendDeliveryReceiptsValue:(BOOL)value_;

//- (BOOL)validateSendDeliveryReceipts:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* sendTypingNotifications;



@property BOOL sendTypingNotificationsValue;
- (BOOL)sendTypingNotificationsValue;
- (void)setSendTypingNotificationsValue:(BOOL)value_;

//- (BOOL)validateSendTypingNotifications:(id*)value_ error:(NSError**)error_;






@end

@interface _OTRManagedXMPPAccount (CoreDataGeneratedAccessors)

@end

@interface _OTRManagedXMPPAccount (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveAllowSSLHostNameMismatch;
- (void)setPrimitiveAllowSSLHostNameMismatch:(NSNumber*)value;

- (BOOL)primitiveAllowSSLHostNameMismatchValue;
- (void)setPrimitiveAllowSSLHostNameMismatchValue:(BOOL)value_;




- (NSNumber*)primitiveAllowSelfSignedSSL;
- (void)setPrimitiveAllowSelfSignedSSL:(NSNumber*)value;

- (BOOL)primitiveAllowSelfSignedSSLValue;
- (void)setPrimitiveAllowSelfSignedSSLValue:(BOOL)value_;




- (NSString*)primitiveDomain;
- (void)setPrimitiveDomain:(NSString*)value;




- (NSNumber*)primitivePort;
- (void)setPrimitivePort:(NSNumber*)value;

- (int16_t)primitivePortValue;
- (void)setPrimitivePortValue:(int16_t)value_;




- (NSNumber*)primitiveSendDeliveryReceipts;
- (void)setPrimitiveSendDeliveryReceipts:(NSNumber*)value;

- (BOOL)primitiveSendDeliveryReceiptsValue;
- (void)setPrimitiveSendDeliveryReceiptsValue:(BOOL)value_;




- (NSNumber*)primitiveSendTypingNotifications;
- (void)setPrimitiveSendTypingNotifications:(NSNumber*)value;

- (BOOL)primitiveSendTypingNotificationsValue;
- (void)setPrimitiveSendTypingNotificationsValue:(BOOL)value_;




@end
