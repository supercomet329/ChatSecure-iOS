// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to OTRManagedBuddy.h instead.

#import <CoreData/CoreData.h>


extern const struct OTRManagedBuddyAttributes {
	__unsafe_unretained NSString *accountName;
	__unsafe_unretained NSString *chatState;
	__unsafe_unretained NSString *composingMessageString;
	__unsafe_unretained NSString *displayName;
	__unsafe_unretained NSString *encryptionStatus;
	__unsafe_unretained NSString *groupName;
	__unsafe_unretained NSString *lastMessageDisconnected;
	__unsafe_unretained NSString *lastSentChatState;
	__unsafe_unretained NSString *status;
} OTRManagedBuddyAttributes;

extern const struct OTRManagedBuddyRelationships {
	__unsafe_unretained NSString *account;
	__unsafe_unretained NSString *messages;
} OTRManagedBuddyRelationships;

extern const struct OTRManagedBuddyFetchedProperties {
} OTRManagedBuddyFetchedProperties;

@class OTRManagedAccount;
@class OTRManagedMessage;











@interface OTRManagedBuddyID : NSManagedObjectID {}
@end

@interface _OTRManagedBuddy : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (OTRManagedBuddyID*)objectID;





@property (nonatomic, strong) NSString* accountName;



//- (BOOL)validateAccountName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* chatState;



@property int16_t chatStateValue;
- (int16_t)chatStateValue;
- (void)setChatStateValue:(int16_t)value_;

//- (BOOL)validateChatState:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* composingMessageString;



//- (BOOL)validateComposingMessageString:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* displayName;



//- (BOOL)validateDisplayName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* encryptionStatus;



@property int16_t encryptionStatusValue;
- (int16_t)encryptionStatusValue;
- (void)setEncryptionStatusValue:(int16_t)value_;

//- (BOOL)validateEncryptionStatus:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* groupName;



//- (BOOL)validateGroupName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* lastMessageDisconnected;



@property BOOL lastMessageDisconnectedValue;
- (BOOL)lastMessageDisconnectedValue;
- (void)setLastMessageDisconnectedValue:(BOOL)value_;

//- (BOOL)validateLastMessageDisconnected:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* lastSentChatState;



@property int16_t lastSentChatStateValue;
- (int16_t)lastSentChatStateValue;
- (void)setLastSentChatStateValue:(int16_t)value_;

//- (BOOL)validateLastSentChatState:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* status;



@property int16_t statusValue;
- (int16_t)statusValue;
- (void)setStatusValue:(int16_t)value_;

//- (BOOL)validateStatus:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) OTRManagedAccount *account;

//- (BOOL)validateAccount:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSSet *messages;

- (NSMutableSet*)messagesSet;





@end

@interface _OTRManagedBuddy (CoreDataGeneratedAccessors)

- (void)addMessages:(NSSet*)value_;
- (void)removeMessages:(NSSet*)value_;
- (void)addMessagesObject:(OTRManagedMessage*)value_;
- (void)removeMessagesObject:(OTRManagedMessage*)value_;

@end

@interface _OTRManagedBuddy (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveAccountName;
- (void)setPrimitiveAccountName:(NSString*)value;




- (NSNumber*)primitiveChatState;
- (void)setPrimitiveChatState:(NSNumber*)value;

- (int16_t)primitiveChatStateValue;
- (void)setPrimitiveChatStateValue:(int16_t)value_;




- (NSString*)primitiveComposingMessageString;
- (void)setPrimitiveComposingMessageString:(NSString*)value;




- (NSString*)primitiveDisplayName;
- (void)setPrimitiveDisplayName:(NSString*)value;




- (NSNumber*)primitiveEncryptionStatus;
- (void)setPrimitiveEncryptionStatus:(NSNumber*)value;

- (int16_t)primitiveEncryptionStatusValue;
- (void)setPrimitiveEncryptionStatusValue:(int16_t)value_;




- (NSString*)primitiveGroupName;
- (void)setPrimitiveGroupName:(NSString*)value;




- (NSNumber*)primitiveLastMessageDisconnected;
- (void)setPrimitiveLastMessageDisconnected:(NSNumber*)value;

- (BOOL)primitiveLastMessageDisconnectedValue;
- (void)setPrimitiveLastMessageDisconnectedValue:(BOOL)value_;




- (NSNumber*)primitiveLastSentChatState;
- (void)setPrimitiveLastSentChatState:(NSNumber*)value;

- (int16_t)primitiveLastSentChatStateValue;
- (void)setPrimitiveLastSentChatStateValue:(int16_t)value_;




- (NSNumber*)primitiveStatus;
- (void)setPrimitiveStatus:(NSNumber*)value;

- (int16_t)primitiveStatusValue;
- (void)setPrimitiveStatusValue:(int16_t)value_;





- (OTRManagedAccount*)primitiveAccount;
- (void)setPrimitiveAccount:(OTRManagedAccount*)value;



- (NSMutableSet*)primitiveMessages;
- (void)setPrimitiveMessages:(NSMutableSet*)value;


@end
