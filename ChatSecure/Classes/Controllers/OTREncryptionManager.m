//
//  OTREncryptionManager.m
//  Off the Record
//
//  Created by Chris Ballinger on 9/4/11.
//  Copyright (c) 2011 Chris Ballinger. All rights reserved.
//
//  This file is part of ChatSecure.
//
//  ChatSecure is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  ChatSecure is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with ChatSecure.  If not, see <http://www.gnu.org/licenses/>.

#import "OTREncryptionManager.h"
#import "OTRMessage.h"
#import "OTRBuddy.h"
#import "OTRAccount.h"
#import "OTRProtocolManager.h"
#import "OTRDatabaseManager.h"
#import "OTRUtilities.h"
#import "Strings.h"
#import "OTRAppDelegate.h"
#import "OTRMessagesViewController.h"
#import "UIViewController+ChatSecure.h"
#import "OTRImageItem.h"
#import "OTRAudioItem.h"
#import "OTRVideoItem.h"
#import "OTRMediaFileManager.h"
#import "OTRMediaServer.h"

#import "OTRLog.h"

@import AVFoundation;

NSString *const OTRMessageStateDidChangeNotification = @"OTREncryptionManagerMessageStateDidChangeNotification";
NSString *const OTRWillStartGeneratingPrivateKeyNotification = @"OTREncryptionManagerWillStartGeneratingPrivateKeyNotification";
NSString *const OTRDidFinishGeneratingPrivateKeyNotification = @"OTREncryptionManagerdidFinishGeneratingPrivateKeyNotification";
NSString *const OTRMessageStateKey = @"OTREncryptionManagerMessageStateKey";

@interface OTREncryptionManager ()
@property (nonatomic, strong) OTRKit *otrKit;
@end

@implementation OTREncryptionManager


- (id) init {
    if (self = [super init]) {
        self.otrKit = [OTRKit sharedInstance];
        [self.otrKit setupWithDataPath:nil];
        self.otrKit.delegate = self;
        _dataHandler = [[OTRDataHandler alloc] initWithOTRKit:self.otrKit delegate:self];
        NSArray *protectPaths = @[self.otrKit.privateKeyPath, self.otrKit.fingerprintsPath, self.otrKit.instanceTagsPath];
        for (NSString *path in protectPaths) {
            if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
                [@"" writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
            }
            [OTREncryptionManager setFileProtection:NSFileProtectionCompleteUntilFirstUserAuthentication path:path];
            [OTREncryptionManager addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:path]];
        }
    }
    return self;
}

- (OTRProtocolType)prototcolTypeForString:(NSString *)typeString
{
    if ([typeString isEqualToString:kOTRProtocolTypeXMPP])
    {
        return OTRProtocolTypeXMPP;
    }
    else {
        return OTRProtocolTypeNone;
    }
}


#pragma mark OTRKitDelegate methods

- (void)otrKit:(OTRKit *)otrKit injectMessage:(NSString *)text username:(NSString *)username accountName:(NSString *)accountName protocol:(NSString *)protocol tag:(id)tag
{
    //only otrproltocol
    OTRMessage *message = [[OTRMessage alloc] init];
    message.text =text;
    message.incoming = NO;
    
    __block OTRBuddy *buddy = nil;
    [[OTRDatabaseManager sharedInstance].readWriteDatabaseConnection asyncReadWithBlock:^(YapDatabaseReadTransaction *transaction) {
        buddy = [OTRBuddy fetchBuddyForUsername:username accountName:accountName transaction:transaction];
    } completionBlock:^{
        message.buddyUniqueId = buddy.uniqueId;
        
        [[OTRProtocolManager sharedInstance] sendMessage:message];
    }];
}

- (void)otrKit:(OTRKit *)otrKit encodedMessage:(NSString *)encodedMessage wasEncrypted:(BOOL)wasEncrypted username:(NSString *)username accountName:(NSString *)accountName protocol:(NSString *)protocol tag:(id)tag error:(NSError *)error
{
    if (error) {
        DDLogError(@"Encode Error: %@",error);
    }
    
    __block OTRMessage *message = nil;
    //
    if ([tag isKindOfClass:[OTRMessage class]]) {
        message = [tag copy];
        
        // When replying to OTRDATA requests, we pass along the tag
        // of the original incoming message. We don't want to actually show these messages in the chat
        // so if we detect an incoming message in the encodedMessage callback we should just send the encoded data.
        if (message.isIncoming) {
            OTRMessage *otrDataMessage = [[OTRMessage alloc] init];
            otrDataMessage.incoming = NO;
            otrDataMessage.buddyUniqueId = message.buddyUniqueId;
            otrDataMessage.text = encodedMessage;
            [[OTRProtocolManager sharedInstance] sendMessage:otrDataMessage];
            return;
        }
        
        if (error) {
            [[OTRDatabaseManager sharedInstance].readWriteDatabaseConnection asyncReadWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
                message.error = error;
                [message saveWithTransaction:transaction];
            }];
        }
        else if ([encodedMessage length]) {
            if (wasEncrypted) {
                message.transportedSecurely = YES;
            }
            [[OTRDatabaseManager sharedInstance].readWriteDatabaseConnection asyncReadWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
                [message saveWithTransaction:transaction];
            } completionBlock:^{
                OTRMessage *newEncodedMessage = [message copy];
                newEncodedMessage.text = encodedMessage;
                [[OTRProtocolManager sharedInstance] sendMessage:newEncodedMessage];
            }];
        }
    }
    else if ([encodedMessage length]) {
        
        [[OTRDatabaseManager sharedInstance].readWriteDatabaseConnection asyncReadWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
            message = [[OTRMessage alloc] init];
            message.incoming = NO;
            message.text = encodedMessage;
            OTRBuddy *buddy = [OTRBuddy fetchBuddyForUsername:username accountName:accountName transaction:transaction];
            message.buddyUniqueId = buddy.uniqueId;
            
        } completionBlock:^{
            [[OTRProtocolManager sharedInstance] sendMessage:message];
        }];
    }
    
    
}

- (void)otrKit:(OTRKit *)otrKit decodedMessage:(NSString *)decodedMessage wasEncrypted:(BOOL)wasEncrypted tlvs:(NSArray *)tlvs username:(NSString *)username accountName:(NSString *)accountName protocol:(NSString *)protocol tag:(id)tag
{
    //decodedMessage can be nil if just TLV
    OTRMessage *originalMessage = nil;
    if ([tag isKindOfClass:[OTRMessage class]]) {
        originalMessage = [tag copy];
    }
    NSParameterAssert(originalMessage);
    
    decodedMessage = [OTRUtilities stripHTML:decodedMessage];
    
    if ([decodedMessage length]) {
        if ([[OTRAppDelegate appDelegate].messagesViewController otr_isVisible] && [[OTRAppDelegate appDelegate].messagesViewController.buddy.uniqueId isEqualToString:originalMessage.buddyUniqueId])
        {
            originalMessage.read = YES;
        }
        
        originalMessage.text = decodedMessage;
        
        if (wasEncrypted) {
            originalMessage.transportedSecurely = YES;
        }
        [[OTRDatabaseManager sharedInstance].readWriteDatabaseConnection asyncReadWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
            [originalMessage saveWithTransaction:transaction];
            //Update lastMessageDate for sorting and grouping
            OTRBuddy *buddy = [OTRBuddy fetchObjectWithUniqueID:originalMessage.buddyUniqueId transaction:transaction];
            buddy.lastMessageDate = originalMessage.date;
            [buddy saveWithTransaction:transaction];
        } completionBlock:^{
            [OTRMessage showLocalNotificationForMessage:originalMessage];
        }];
    }
    
    if ([tlvs count]) {
        DDLogVerbose(@"Found TLVS: %@",tlvs);
    }
}

- (void)otrKit:(OTRKit *)otrKit updateMessageState:(OTRKitMessageState)messageState username:(NSString *)username accountName:(NSString *)accountName protocol:(NSString *)protocol
{
    __block OTRBuddy *buddy = nil;
    [[OTRDatabaseManager sharedInstance].readWriteDatabaseConnection asyncReadWithBlock:^(YapDatabaseReadTransaction *transaction) {
        buddy = [OTRBuddy fetchBuddyForUsername:username accountName:accountName transaction:transaction];
    } completionBlock:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:OTRMessageStateDidChangeNotification object:buddy userInfo:@{OTRMessageStateKey:@(messageState)}];
    }];
}

- (BOOL)       otrKit:(OTRKit*)otrKit
   isUsernameLoggedIn:(NSString*)username
          accountName:(NSString*)accountName
             protocol:(NSString*)protocol {
    
    __block OTRBuddy *buddy = nil;
    [[OTRDatabaseManager sharedInstance].readWriteDatabaseConnection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
        buddy = [OTRBuddy fetchBuddyForUsername:username accountName:accountName transaction:transaction];
    }];
    
    if(!buddy || buddy.status == OTRBuddyStatusOffline) {
        return NO;
    }
    else {
        return YES;
    }
}

- (void)                           otrKit:(OTRKit*)otrKit
  showFingerprintConfirmationForTheirHash:(NSString*)theirHash
                                  ourHash:(NSString*)ourHash
                                 username:(NSString*)username
                              accountName:(NSString*)accountName
                                 protocol:(NSString*)protocol
{
    //changed user fingerprint
}

- (void) otrKit:(OTRKit*)otrKit
 handleSMPEvent:(OTRKitSMPEvent)event
       progress:(double)progress
       question:(NSString*)question
       username:(NSString*)username
    accountName:(NSString*)accountName
       protocol:(NSString*)protocol
{
    
}

- (void) otrKit:(OTRKit *)otrKit handleMessageEvent:(OTRKitMessageEvent)event message:(NSString *)message username:(NSString *)username accountName:(NSString *)accountName protocol:(NSString *)protocol tag:(id)tag error:(NSError *)error {
    //incoming and outgoing errors and other events
    DDLogWarn(@"Message Event: %d Error:%@",(int)event,error);
    
    if ([tag isKindOfClass:[OTRMessage class]]) {
        __block NSError *error = nil;
        
        // These are the errors caught and 
        switch (event) {
            case OTRKitMessageEventEncryptionError:
            case OTRKitMessageEventReceivedMessageNotInPrivate:
            case OTRKitMessageEventReceivedMessageUnreadable:
            case OTRKitMessageEventReceivedMessageMalformed:
            case OTRKitMessageEventReceivedMessageGeneralError:
            case OTRKitMessageEventReceivedMessageUnrecognized:
                error = [OTREncryptionManager errorForMessageEvent:event];
                break;
            default:
                break;
        }
        if (error) {
            [[OTRDatabaseManager sharedInstance].readWriteDatabaseConnection asyncReadWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
                OTRMessage *message = (OTRMessage *)tag;
                message.error = error;
                [message saveWithTransaction:transaction];
            }];
        }
    }
}

- (void)        otrKit:(OTRKit*)otrKit
  receivedSymmetricKey:(NSData*)symmetricKey
                forUse:(NSUInteger)use
               useData:(NSData*)useData
              username:(NSString*)username
           accountName:(NSString*)accountName
              protocol:(NSString*)protocol
{
    DDLogVerbose(@"Received Symetric Key");
}

 ////// Optional //////

- (void)otrKit:(OTRKit *)otrKit willStartGeneratingPrivateKeyForAccountName:(NSString *)accountName protocol:(NSString *)protocol
{
    __block OTRAccount *account = nil;
    [[OTRDatabaseManager sharedInstance].readWriteDatabaseConnection asyncReadWithBlock:^(YapDatabaseReadTransaction *transaction) {
        
        account = [[OTRAccount allAccountsWithUsername:accountName transaction:transaction] firstObject];
    } completionBlock:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:OTRWillStartGeneratingPrivateKeyNotification object:account];
    }];
    
    
}

- (void)otrKit:(OTRKit *)otrKit didFinishGeneratingPrivateKeyForAccountName:(NSString *)accountName protocol:(NSString *)protocol error:(NSError *)error
{
    __block OTRAccount *account = nil;
    [[OTRDatabaseManager sharedInstance].readWriteDatabaseConnection asyncReadWithBlock:^(YapDatabaseReadTransaction *transaction) {
        account = [[OTRAccount allAccountsWithUsername:accountName transaction:transaction] firstObject];;
    } completionBlock:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:OTRDidFinishGeneratingPrivateKeyNotification object:account];
    }];
}

#pragma - mark Class Methods

+ (NSError *)errorForMessageEvent:(OTRKitMessageEvent)event
{
    
    NSString *eventString = [OTREncryptionManager stringForEvent:event];
    
    NSInteger code = 200 + event;
    NSMutableDictionary *userInfo = [@{NSLocalizedDescriptionKey:ENCRYPTION_ERROR_STRING} mutableCopy];
    if ([eventString length]) {
        [userInfo setObject:eventString forKey:NSLocalizedFailureReasonErrorKey];
    }
    NSError *error = [NSError errorWithDomain:kOTRErrorDomain code:code userInfo:userInfo];
    
    
    return error;
}

+ (NSString *)stringForEvent:(OTRKitMessageEvent)event
{
    NSString *string = nil;
    switch (event) {
        case OTRKitMessageEventEncryptionRequired:
            string = OTRL_MSGEVENT_ENCRYPTION_REQUIRED_STRING;
            break;
        case OTRKitMessageEventEncryptionError:
            string = OTRL_MSGEVENT_ENCRYPTION_ERROR_STRING;
            break;
        case OTRKitMessageEventConnectionEnded:
            string = OTRL_MSGEVENT_CONNECTION_ENDED_STRING;
            break;
        case OTRKitMessageEventSetupError:
            string = OTRL_MSGEVENT_SETUP_ERROR_STRING;
            break;
        case OTRKitMessageEventMessageReflected:
            string = OTRL_MSGEVENT_MSG_REFLECTED_STRING;
            break;
        case OTRKitMessageEventMessageResent:
            string = OTRL_MSGEVENT_MSG_RESENT_STRING;
            break;
        case OTRKitMessageEventReceivedMessageNotInPrivate:
            string = OTRL_MSGEVENT_RCVDMSG_NOT_IN_PRIVATE_STRING;
            break;
        case OTRKitMessageEventReceivedMessageUnreadable:
            string = OTRL_MSGEVENT_RCVDMSG_UNREADABLE_STRING;
            break;
        case OTRKitMessageEventReceivedMessageMalformed:
            string = OTRL_MSGEVENT_RCVDMSG_MALFORMED_STRING;
            break;
        case OTRKitMessageEventLogHeartbeatReceived:
            string = OTRL_MSGEVENT_LOG_HEARTBEAT_RCVD_STRING;
            break;
        case OTRKitMessageEventLogHeartbeatSent:
            string = OTRL_MSGEVENT_LOG_HEARTBEAT_SENT_STRING;
            break;
        case OTRKitMessageEventReceivedMessageGeneralError:
            string = OTRL_MSGEVENT_RCVDMSG_GENERAL_ERR_STRING;
            break;
        case OTRKitMessageEventReceivedMessageUnencrypted:
            string = OTRL_MSGEVENT_RCVDMSG_UNENCRYPTED_STRING;
            break;
        case OTRKitMessageEventReceivedMessageUnrecognized:
            string = OTRL_MSGEVENT_RCVDMSG_UNRECOGNIZED_STRING;
            break;
        case OTRKitMessageEventReceivedMessageForOtherInstance:
            string = OTRL_MSGEVENT_RCVDMSG_FOR_OTHER_INSTANCE_STRING;
            break;
        default:
            break;
    }
    return string;
}

+ (BOOL) setFileProtection:(NSString*)fileProtection path:(NSString*)path {
    NSDictionary *fileAttributes = [NSDictionary dictionaryWithObject:fileProtection forKey:NSFileProtectionKey];
    NSError * error = nil;
    BOOL success = [[NSFileManager defaultManager] setAttributes:fileAttributes ofItemAtPath:path error:&error];
    if (!success)
    {
        DDLogError(@"error encrypting store: %@", error.userInfo);
    }
    return success;
}

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        DDLogError(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

#pragma mark OTRDataHandlerDelegate methods

- (void)dataHandler:(OTRDataHandler*)dataHandler
           transfer:(OTRDataTransfer*)transfer
              error:(NSError*)error {
    DDLogError(@"error with file transfer: %@ %@", transfer, error);
}

- (void)dataHandler:(OTRDataHandler*)dataHandler
    offeredTransfer:(OTRDataIncomingTransfer*)transfer {
    DDLogInfo(@"offered file transfer: %@", transfer);
    
    // for now, just accept all incoming files
#warning auto-accept of all incoming files
    [dataHandler startIncomingTransfer:transfer];
}

- (void)dataHandler:(OTRDataHandler*)dataHandler
           transfer:(OTRDataTransfer*)transfer
           progress:(float)progress {
    DDLogInfo(@"[OTRDATA]file transfer %@ progress: %f", transfer.transferId, progress);
    
}

- (void)dataHandler:(OTRDataHandler*)dataHandler
   transferComplete:(OTRDataTransfer*)transfer {
    DDLogInfo(@"transfer complete: %@", transfer);
    if ([transfer isKindOfClass:[OTRDataIncomingTransfer class]]) {
        NSRange imageRange = [transfer.mimeType rangeOfString:@"image"];
        NSRange audioRange = [transfer.mimeType rangeOfString:@"audio"];
        NSRange videoRange = [transfer.mimeType rangeOfString:@"video"];
        
        OTRMessage *parentMessage = transfer.tag;
        
        OTRMessage *message = [[OTRMessage alloc] init];
        message.incoming = YES;
        message.buddyUniqueId = parentMessage.buddyUniqueId;
        message.transportedSecurely = YES;
        
        if (imageRange.location != NSNotFound) {
            
            UIImage *tempImage = [UIImage imageWithData:transfer.fileData];
            OTRImageItem *imageItem = [[OTRImageItem alloc] init];
            imageItem.width = tempImage.size.width;
            imageItem.height = tempImage.size.height;
            imageItem.isIncoming = YES;
            imageItem.filename = transfer.fileName;
            
            message.mediaItemUniqueId = imageItem.uniqueId;
            
            [[OTRDatabaseManager sharedInstance].readWriteDatabaseConnection asyncReadWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
                [message saveWithTransaction:transaction];
                [imageItem saveWithTransaction:transaction];
            } completionBlock:^{
                [[OTRMediaFileManager sharedInstance] setData:transfer.fileData forItem:imageItem buddyUniqueId:parentMessage.buddyUniqueId completion:^(NSInteger bytesWritten, NSError *error) {
                    [imageItem touchParentMessage];
                } completionQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
            }];
        }
        else if (audioRange.location != NSNotFound) {
            
            OTRAudioItem *audioItem = [[OTRAudioItem alloc] init];
            audioItem.filename = transfer.fileName;
            audioItem.isIncoming = YES;
            
            message.mediaItemUniqueId = audioItem.uniqueId;
            
            [[OTRMediaFileManager sharedInstance] setData:transfer.fileData forItem:audioItem buddyUniqueId:parentMessage.buddyUniqueId completion:^(NSInteger bytesWritten, NSError *error) {
                
                NSURL *url = [[OTRMediaServer sharedInstance] urlForMediaItem:audioItem buddyUniqueId:parentMessage.buddyUniqueId];
                AVURLAsset *audioAsset = [AVURLAsset assetWithURL:url];
                audioItem.timeLength = CMTimeGetSeconds(audioAsset.duration);
                
                [[OTRDatabaseManager sharedInstance].readWriteDatabaseConnection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
                    [audioItem saveWithTransaction:transaction];
                    [message saveWithTransaction:transaction];
                }];
                
                
            } completionQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
            
        }
        else if (videoRange.location != NSNotFound) {
            OTRVideoItem *videoItem  =[[OTRVideoItem alloc] init];
            videoItem.filename = transfer.fileName;
            videoItem.isIncoming = YES;
            
            message.mediaItemUniqueId = videoItem.uniqueId;
            
            [[OTRMediaFileManager sharedInstance] setData:transfer.fileData forItem:videoItem buddyUniqueId:parentMessage.buddyUniqueId completion:^(NSInteger bytesWritten, NSError *error) {
                
                [[OTRDatabaseManager sharedInstance].readWriteDatabaseConnection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
                    [videoItem saveWithTransaction:transaction];
                    [message saveWithTransaction:transaction];
                }];
                
            } completionQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
        }
    }
}


@end
