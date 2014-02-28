#import "OTRvCard.h"

#import "OTRvCardTemp.h"
#import "OTRvCardAvatar.h"

#import "NSData+XMPP.h"


@interface OTRvCard ()

// Private interface goes here.

@end


@implementation OTRvCard

+(OTRvCard *)fetchOrCreateWithJidString:(NSString *)jidString inContext:(NSManagedObjectContext *)context{
    
    OTRvCard * vCard = nil;
    NSPredicate * searchPredicate = [NSPredicate predicateWithFormat:@"%K == %@",OTRvCardAttributes.jidString,jidString];
    NSArray * allvCardsArray = [OTRvCard MR_findAllWithPredicate:searchPredicate inContext:context];
    
    if ([allvCardsArray count]) {
        vCard = [allvCardsArray lastObject];
    }
    else {
        vCard = [OTRvCard MR_createInContext:context];
        vCard.jidString = jidString;
    }
    return vCard;
}

-(void)setVCardTemp:(XMPPvCardTemp *)vCardTemp {
    if (!vCardTemp && self.vCardAvatarRelationship) {
        [self.vCardTempRelationship MR_deleteEntity];
    }
    else {
        
        OTRvCardTemp * newvCardTemp = [OTRvCardTemp MR_createEntity];
        newvCardTemp.vCardTemp = vCardTemp;
        self.vCardTempRelationship = newvCardTemp;
    }
    [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreAndWait];
    
}

-(XMPPvCardTemp *)vCardTemp {
    
    return self.vCardTempRelationship.vCardTemp;
}

-(void)setPhotoData:(NSData *)photoData
{
    NSManagedObjectContext * context = [self managedObjectContext];
    if (!photoData && self.vCardAvatarRelationship) {
        [self.vCardAvatarRelationship MR_deleteInContext:context];
        self.photoHash = nil;
    }
    else {
        OTRvCardAvatar * vCardAvatar = [OTRvCardAvatar MR_createInContext:context];
        vCardAvatar.photoData = photoData;
        self.vCardAvatarRelationship = vCardAvatar;
        
        self.photoHash = [[photoData xmpp_sha1Digest] xmpp_hexStringValue];
    }
}

-(NSData *)photoData {
    return self.vCardAvatarRelationship.photoData;
}

@end
