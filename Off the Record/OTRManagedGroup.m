#import "OTRManagedGroup.h"


@interface OTRManagedGroup ()

// Private interface goes here.

@end


@implementation OTRManagedGroup

+(OTRManagedGroup *)fetchOrCreateWithName:(NSString *)name
{
    OTRManagedGroup * group = nil;
    
    group = [OTRManagedGroup MR_findFirstByAttribute:OTRManagedGroupAttributes.name withValue:name];
    
    if (!group) {
        group = [OTRManagedGroup MR_createEntity];
        group.name = name;
        
    }
    
    return group;
}
+(OTRManagedGroup *)fetchOrCreateWithName:(NSString *)name inContext:(NSManagedObjectContext *)context
{
    OTRManagedGroup * group = nil;
    
    group = [OTRManagedGroup MR_findFirstByAttribute:OTRManagedGroupAttributes.name withValue:name inContext:context];
    
    if (!group) {
        group = [OTRManagedGroup MR_createInContext:context];
        [context obtainPermanentIDsForObjects:@[group] error:nil];
        group.name = name;
        
    }
    
    return group;
}

@end
