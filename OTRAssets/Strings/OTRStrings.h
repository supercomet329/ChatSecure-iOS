// DO NOT EDIT THIS FILE. EDIT strings.json then run python StringsConverter.py

@import Foundation;
NS_ASSUME_NONNULL_BEGIN
/** "We could not find any trusted devices for this contact.", Error message for not finding any devices */
FOUNDATION_EXPORT NSString* NO_DEVICES_BUDDY_ERROR_STRING();
/** "Server", server selection section title */
FOUNDATION_EXPORT NSString* Server_String();
/** "Underlying cryptographic error", SSL error message */
FOUNDATION_EXPORT NSString* errSSLCryptoString();
/** "Offline", Label in buddy list for users that are offline */
FOUNDATION_EXPORT NSString* OFFLINE_STRING();
/** "Error", Title of error message pop-up box */
FOUNDATION_EXPORT NSString* ERROR_STRING();
/** "Log Out", log out from account */
FOUNDATION_EXPORT NSString* LOGOUT_STRING();
/** "Auto-delete", Title for automatic conversation deletion setting */
FOUNDATION_EXPORT NSString* DELETE_CONVERSATIONS_ON_DISCONNECT_TITLE_STRING();
/** "Done", Title for button to press when user is finished */
FOUNDATION_EXPORT NSString* DONE_STRING();
/** "Basic Setup", username section */
FOUNDATION_EXPORT NSString* Basic_Setup();
/** "ChatSecure Push", Title for ChatSecure Push (this probably doesnt need to be translated) */
FOUNDATION_EXPORT NSString* CHATSECURE_PUSH_STRING();
/** "Waiting", Label text for when a transfer has not started yet */
FOUNDATION_EXPORT NSString* WAITING_STRING();
/** "Release to delete", Label for instruction to delete current recording */
FOUNDATION_EXPORT NSString* RELEASE_TO_DELETE_STRING();
/** "Peer cert is valid, or was ignored if verification disabled", SSL error message */
FOUNDATION_EXPORT NSString* errSSLPeerAuthCompletedString();
/** "Password", Label text for password field on login screen */
FOUNDATION_EXPORT NSString* PASSWORD_STRING();
/** "Advanced", String to describe advanced set of settings */
FOUNDATION_EXPORT NSString* ADVANCED_STRING();
/** "Could not decrypt database. If the app is not working properly, you may need to delete and reinstall.",  */
FOUNDATION_EXPORT NSString* Could_Not_Decrypt_Database();
/** "Unrecognized Invite Format", shown when invite QR code doesnt work */
FOUNDATION_EXPORT NSString* Unrecognized_Invite_Format();
/** "Resend", Label for button to resend message. */
FOUNDATION_EXPORT NSString* RESEND_STRING();
/** "Our policy requires encryption but we are trying to send an unencrypted message out.", Error string for OTR message string */
FOUNDATION_EXPORT NSString* OTRL_MSGEVENT_ENCRYPTION_REQUIRED_STRING();
/** "Version", when displaying version numbers such as 1.0.0 */
FOUNDATION_EXPORT NSString* VERSION_STRING();
/** "Enter a group name", The placeholder text for the text field to enter a group chat name or label */
FOUNDATION_EXPORT NSString* ENTER_GROUP_NAME_STRING();
/** "Connect", String for button to connect connect */
FOUNDATION_EXPORT NSString* CONNECT_STRING();
/** "Required", String to let user know a certain field like a password is required to create an account */
FOUNDATION_EXPORT NSString* REQUIRED_STRING();
/** "Invalid Email", title label for invalid email */
FOUNDATION_EXPORT NSString* INVALID_EMAIL_TITLE_STRING();
/** "Sending", Label text for when a transfer is in progress (normally followed by a percent value 34%) */
FOUNDATION_EXPORT NSString* SENDING_STRING();
/** "Crash Detected",  */
FOUNDATION_EXPORT NSString* Crash_Detected_Title();
/** "Resend Message", Ttitle for alert view to resend a message */
FOUNDATION_EXPORT NSString* RESEND_MESSAGE_TITLE();
/** "Send plaintext message", The placeholder text in the chat view where the message should go */
FOUNDATION_EXPORT NSString* SEND_PLAINTEXT_STRING();
/** "Message has not been sent because our buddy has ended the private conversation. We should either close the connection, or refresh it.", Error string for OTR message string */
FOUNDATION_EXPORT NSString* OTRL_MSGEVENT_CONNECTION_ENDED_STRING();
/** "Received and discarded a message intended for another instance.", Error string for OTR message string */
FOUNDATION_EXPORT NSString* OTRL_MSGEVENT_RCVDMSG_FOR_OTHER_INSTANCE_STRING();
/** "Verify Fingerprint", Title of the dialog for fingerprint verification */
FOUNDATION_EXPORT NSString* VERIFY_FINGERPRINT_STRING();
/** "Open in Twitter", Label for button to open link in twitter app */
FOUNDATION_EXPORT NSString* OPEN_IN_TWITTER_STRING();
/** "Twitter", Name of the popular social tweeting site */
FOUNDATION_EXPORT NSString* TWITTER_STRING();
/** "Microphone Disabled", microphone permission is disabled */
FOUNDATION_EXPORT NSString* Microphone_Disabled();
/** "Connected", Whether or not account is logged in */
FOUNDATION_EXPORT NSString* CONNECTED_STRING();
/** "Tor is an experimental feature, please use with caution.", Message for warning about using tor network */
FOUNDATION_EXPORT NSString* TOR_WARNING_MESSAGE_STRING();
/** "Choose from our list of trusted servers, or use your own.", server selection footer */
FOUNDATION_EXPORT NSString* Server_String_Hint();
/** "Extended Away", Default message when a user status is set to extended away */
FOUNDATION_EXPORT NSString* EXTENDED_AWAY_STRING();
/** "Received our own OTR messages.", Error string for OTR message string */
FOUNDATION_EXPORT NSString* OTRL_MSGEVENT_MSG_REFLECTED_STRING();
/** "Server closed session with no notification", SSL error message */
FOUNDATION_EXPORT NSString* errSSLClosedNoNotifyString();
/** "Could not retrieve public key from certificate", Error message when cannot get public key from SSL certificate */
FOUNDATION_EXPORT NSString* PUBLIC_KEY_ERROR_STRING();
/** "Received an encrypted message but cannot read it because no private connection is established yet.", Error string for OTR message string */
FOUNDATION_EXPORT NSString* OTRL_MSGEVENT_RCVDMSG_NOT_IN_PRIVATE_STRING();
/** "New SSL Certificate", Title for alert when a new SSL certificate is encountered */
FOUNDATION_EXPORT NSString* NEW_CERTIFICATE_STRING();
/** "Open in Chrome", Label to open link in the chrome web browser */
FOUNDATION_EXPORT NSString* OPEN_IN_CHROME();
/** "Cancel", Cancel an alert window */
FOUNDATION_EXPORT NSString* CANCEL_STRING();
/** "Login Automatically", Label for account setting that autologins on launch */
FOUNDATION_EXPORT NSString* LOGIN_AUTOMATICALLY_STRING();
/** "Untrusted Device", Title for error message */
FOUNDATION_EXPORT NSString* UNTRUSTED_DEVICE_STRING();
/** "Decoding error", SSL error message */
FOUNDATION_EXPORT NSString* errSSLPeerDecodeErrorString();
/** "Record overflow", SSL error message */
FOUNDATION_EXPORT NSString* errSSLRecordOverflowString();
/** "Decryption failure", SSL error message */
FOUNDATION_EXPORT NSString* errSSLDecryptionFailString();
/** "Add", Button title to add someone as a buddy */
FOUNDATION_EXPORT NSString* ADD_STRING();
/** "GitHub", Name of popular web based hosting service */
FOUNDATION_EXPORT NSString* GITHUB_STRING();
/** "Removed By Server",  */
FOUNDATION_EXPORT NSString* Removed_By_Server();
/** "Open in Facebook", Label for button to open link in facebook app */
FOUNDATION_EXPORT NSString* OPEN_IN_FACEBOOK_STRING();
/** "Show Advanced Encryption Settings",  */
FOUNDATION_EXPORT NSString* Show_Advanced_Encryption_Settings();
/** "Peer host name mismatch", SSL error message */
FOUNDATION_EXPORT NSString* errSSLHostNameMismatchString();
/** "Pinned Certificates", Button Lable to show all pinned SSL certificates */
FOUNDATION_EXPORT NSString* PINNED_CERTIFICATES_STRING();
/** "Permanently delete", Ask user if they want to delete the stored account information */
FOUNDATION_EXPORT NSString* DELETE_ACCOUNT_MESSAGE_STRING();
/** "Received a general OTR error.", Error string for OTR message string */
FOUNDATION_EXPORT NSString* OTRL_MSGEVENT_RCVDMSG_GENERAL_ERR_STRING();
/** "Created by", Start of sentence that will be followed by names */
FOUNDATION_EXPORT NSString* CREATED_BY_STRING();
/** "Module attach failure", SSL error message */
FOUNDATION_EXPORT NSString* errSSLModuleAttachString();
/** "Save", Title for button for saving a setting */
FOUNDATION_EXPORT NSString* SAVE_STRING();
/** "Cert chain not verified by root", SSL error message */
FOUNDATION_EXPORT NSString* errSSLNoRootCertString();
/** "Accounts", Title for the accounts tab */
FOUNDATION_EXPORT NSString* ACCOUNTS_STRING();
/** "Pending Approval", String for XMPP buddies when adding buddy is pending */
FOUNDATION_EXPORT NSString* PENDING_APPROVAL_STRING();
/** "Decryption failed", SSL error message */
FOUNDATION_EXPORT NSString* errSSLPeerDecryptionFailString();
/** "Jabber (XMPP)", the name for jabber, also include (XMPP) at the end */
FOUNDATION_EXPORT NSString* JABBER_STRING();
/** "Verify", Shown when verifying fingerprints */
FOUNDATION_EXPORT NSString* VERIFY_STRING();
/** "Chain had an expired cert", SSL error message */
FOUNDATION_EXPORT NSString* errSSLCertExpiredString();
/** "Configuration error", SSL error message */
FOUNDATION_EXPORT NSString* errSSLBadConfigurationString();
/** "Add Buddy", The title for the view to add a buddy */
FOUNDATION_EXPORT NSString* ADD_BUDDY_STRING();
/** "Server has requested a client cert", SSL error message */
FOUNDATION_EXPORT NSString* errSSLClientCertRequestedString();
/** "XMPP + Tor", Title for xmpp accounts that connect through the Tor network */
FOUNDATION_EXPORT NSString* XMPP_TOR_STRING();
/** "Cannot read the received message.", Error string for OTR message string */
FOUNDATION_EXPORT NSString* OTRL_MSGEVENT_RCVDMSG_UNREADABLE_STRING();
/** "Bad protocol version", SSL error message */
FOUNDATION_EXPORT NSString* errSSLPeerProtocolVersionString();
/** "Recent", Title for header of Buddy list view with Recent Buddies */
FOUNDATION_EXPORT NSString* RECENT_STRING();
/** "Insufficient buffer provided", SSL error message */
FOUNDATION_EXPORT NSString* errSSLBufferOverflowString();
/** "Copy", Copy string to clipboard as in copy and paste */
FOUNDATION_EXPORT NSString* COPY_STRING();
/** "Incoming", Label for incoming data transfers */
FOUNDATION_EXPORT NSString* INCOMING_STRING();
/** "Unlock", Label for button to unlock app */
FOUNDATION_EXPORT NSString* UNLOCK_STRING();
/** "Your donation will help fund the continued development of ChatSecure.", Message shown when about to donate */
FOUNDATION_EXPORT NSString* DONATE_MESSAGE_STRING();
/** "Donate", Title for donation link */
FOUNDATION_EXPORT NSString* DONATE_STRING();
/** "Illegal parameter", SSL error message */
FOUNDATION_EXPORT NSString* errSSLIllegalParamString();
/** "Create", Title for button to create account */
FOUNDATION_EXPORT NSString* CREATE_STRING();
/** "Resource", Label for text input for XMPP resource */
FOUNDATION_EXPORT NSString* RESOURCE_STRING();
/** "The app crashed last time it was launched. Send a crash report?",  */
FOUNDATION_EXPORT NSString* Crash_Detected_Message();
/** "Access denied", SSL error message */
FOUNDATION_EXPORT NSString* errSSLPeerAccessDeniedString();
/** "Internal error", SSL error message */
FOUNDATION_EXPORT NSString* errSSLPeerInternalErrorString();
/** "An error occured while encrypting a message and the message was not sent.", Error string for OTR message string */
FOUNDATION_EXPORT NSString* OTRL_MSGEVENT_ENCRYPTION_ERROR_STRING();
/** "Photo Library", Label for button to open up photo library and choose photo */
FOUNDATION_EXPORT NSString* PHOTO_LIBRARY_STRING();
/** "Forgot Passphrase?", Label for button when you've forgotten the passphrase */
FOUNDATION_EXPORT NSString* FORGOT_PASSPHRASE_STRING();
/** "Bad MAC", SSL error message */
FOUNDATION_EXPORT NSString* errSSLPeerBadRecordMacString();
/** "New Account", Title for New Account View */
FOUNDATION_EXPORT NSString* NEW_ACCOUNT_STRING();
/** "View profile to review contact's devices or change encryption settings.", Describe how to change a contact's device settings */
FOUNDATION_EXPORT NSString* VIEW_PROFILE_DESCRIPTION_STRING();
/** "Reject", Button title to reject a request such as a buddy request */
FOUNDATION_EXPORT NSString* REJECT_STRING();
/** "QR code", Label for qr code image */
FOUNDATION_EXPORT NSString* QR_CODE_STRING();
/** "Away", Label in buddy list for users that are away */
FOUNDATION_EXPORT NSString* AWAY_STRING();
/** "Hostname", Label text for hostname field on login scree */
FOUNDATION_EXPORT NSString* HOSTNAME_STRING();
/** "Insufficient security", SSL error message */
FOUNDATION_EXPORT NSString* errSSLPeerInsufficientSecurityString();
/** "Custom", Place holder label for custom domains */
FOUNDATION_EXPORT NSString* CUSTOM_STRING();
/** "Skip", Label for button to skip this step */
FOUNDATION_EXPORT NSString* SKIP_STRING();
/** "Search", Label for text field where you search for a buddy */
FOUNDATION_EXPORT NSString* SEARCH_STRING();
/** "The previous message was resent.", Error string for OTR message string */
FOUNDATION_EXPORT NSString* OTRL_MSGEVENT_MSG_RESENT_STRING();
/** "You're ready to use", String used when onboarding works */
FOUNDATION_EXPORT NSString* ONBOARDING_SUCCESS_STRING();
/** "This device doesn't seem to be configured to make payments.", Error message when trying to make a purchase but payments haven't been set up yet */
FOUNDATION_EXPORT NSString* PAYMENTS_SETUP_ERROR_STRING();
/** "Record overflow", SSL error message */
FOUNDATION_EXPORT NSString* errSSLPeerRecordOverflowString();
/** "Knock Sent", Text for label after knock is sent. Like knocking on a door */
FOUNDATION_EXPORT NSString* KNOCK_SENT_STRING();
/** "Security", Title heading in settings */
FOUNDATION_EXPORT NSString* SECURITY_STRING();
/** "Plaintext (Opportunistic OTR)",  */
FOUNDATION_EXPORT NSString* Plaintext_Opportunistic_OTR();
/** "Unable to Send Message", Title for error message */
FOUNDATION_EXPORT NSString* UNABLE_TO_SEND_STRING();
/** "Unknown certificate", SSL error message */
FOUNDATION_EXPORT NSString* errSSLPeerCertUnknownString();
/** "Error Creating Account", title label for error when creating account */
FOUNDATION_EXPORT NSString* ERROR_CREATING_ACCOUNT_STRING();
/** "No Error", SSL error message */
FOUNDATION_EXPORT NSString* noErrString();
/** "Certificate expired", SSL error message */
FOUNDATION_EXPORT NSString* errSSLPeerCertExpiredString();
/** "Send %@ encrypted message", The placeholder text in the chat view where the message should go */
FOUNDATION_EXPORT NSString* SEND_ENCRYPTED_STRING();
/** "A private conversation could not be set up.", Error string for OTR message string */
FOUNDATION_EXPORT NSString* OTRL_MSGEVENT_SETUP_ERROR_STRING();
/** "Unknown Error", Describes an error without a known cause */
FOUNDATION_EXPORT NSString* UNKNOWN_ERROR_STRING();
/** "Cipher Suite negotiation failure", SSL error message */
FOUNDATION_EXPORT NSString* errSSLNegotiationString();
/** "Export restriction", SSL error message */
FOUNDATION_EXPORT NSString* errSSLPeerExportRestrictionString();
/** "Handshake failure", SSL error message */
FOUNDATION_EXPORT NSString* errSSLPeerHandshakeFailString();
/** "Google Talk", the name for Google talk */
FOUNDATION_EXPORT NSString* GOOGLE_TALK_STRING();
/** "Fatal alert", SSL error message */
FOUNDATION_EXPORT NSString* errSSLFatalAlertString();
/** "View Profile", The label for a button to view the buddy profile */
FOUNDATION_EXPORT NSString* VIEW_PROFILE_STRING();
/** "Username", Label text for username field on login screen */
FOUNDATION_EXPORT NSString* USERNAME_STRING();
/** "Advanced Encryption Settings",  */
FOUNDATION_EXPORT NSString* Advanced_Encryption_Settings();
/** "Your password will be stored in the iOS Keychain of this device only, and is only as safe as your device passphrase or pin. However, it will not persist during a device backup/restore via iTunes, so please don't forget it, or you may lose your conversation history.", Text that describes what remembering your passphrase does */
FOUNDATION_EXPORT NSString* REMEMBER_PASSPHRASE_INFO_STRING();
/** "Group Name", The title for the view to enter a group chat name or label */
FOUNDATION_EXPORT NSString* GROUP_NAME_STRING();
/** "Share", Title for sharing a link to the app */
FOUNDATION_EXPORT NSString* SHARE_STRING();
/** "Think of a unique nickname that you don't use anywhere else and doesn't contain personal information.", basic setup selection footer */
FOUNDATION_EXPORT NSString* Basic_Setup_Hint();
/** "Database Error",  */
FOUNDATION_EXPORT NSString* Database_Error_String();
/** "Name", The string describing a buddy's display name */
FOUNDATION_EXPORT NSString* NAME_STRING();
/** "Block", The String for a button to block a buddy */
FOUNDATION_EXPORT NSString* BLOCK_STRING();
/** "OK", Accept the dialog */
FOUNDATION_EXPORT NSString* OK_STRING();
/** "wants to chat.", This string follows a user's dislplay name or username ex Bob wants to chat. */
FOUNDATION_EXPORT NSString* WANTS_TO_CHAT_STRING();
/** "Port", Label for port number field for connecting to service */
FOUNDATION_EXPORT NSString* PORT_STRING();
/** "Connection closed via error", SSL error message */
FOUNDATION_EXPORT NSString* errSSLClosedAbortString();
/** "Nickname", for choosing your XMPP vCard display name */
FOUNDATION_EXPORT NSString* Nickname_String();
/** "This message was received from an untrusted device.", Error message description */
FOUNDATION_EXPORT NSString* UNTRUSTED_DEVICE_REVEIVED_STRING();
/** "Delete Account?", Ask user if they want to delete the stored account information */
FOUNDATION_EXPORT NSString* DELETE_ACCOUNT_TITLE_STRING();
/** "Me",  */
FOUNDATION_EXPORT NSString* Me_String();
/** "Decompression failure", SSL error message */
FOUNDATION_EXPORT NSString* errSSLPeerDecompressFailString();
/** "Bad unsupported cert format", SSL error message */
FOUNDATION_EXPORT NSString* errSSLPeerUnsupportedCertString();
/** "Received an unencrypted message.", Error string for OTR message string */
FOUNDATION_EXPORT NSString* OTRL_MSGEVENT_RCVDMSG_UNENCRYPTED_STRING();
/** "Unknown Cert Authority", SSL error message */
FOUNDATION_EXPORT NSString* errSSLPeerUnknownCAString();
/** "Bad SSLCipherSuite", SSL error message */
FOUNDATION_EXPORT NSString* errSSLBadCipherSuiteString();
/** "My QR Code", Your QR code */
FOUNDATION_EXPORT NSString* MY_QR_CODE();
/** "No renegotiation allowed", SSL error message */
FOUNDATION_EXPORT NSString* errSSLPeerNoRenegotiationString();
/** "plaintext", Label for messages that are not encrypted */
FOUNDATION_EXPORT NSString* UNENCRYPTED_STRING();
/** "Send Feedback", String on button to email feedback */
FOUNDATION_EXPORT NSString* SEND_FEEDBACK_STRING();
/** "Enable Tor",  */
FOUNDATION_EXPORT NSString* Enable_Tor_String();
/** "Show Advanced Options", toggle switch for show advanced */
FOUNDATION_EXPORT NSString* Show_Advanced_Options();
/** "Resending this message will use %@.", Describe what resending will do the %@ will be replaced withe the method OTR/OMEMO/Plaintext */
FOUNDATION_EXPORT NSString* RESEND_DESCRIPTION_STRING();
/** "Internal error", SSL error message */
FOUNDATION_EXPORT NSString* errSSLInternalString();
/** "Enable Push", button for enabling push messages */
FOUNDATION_EXPORT NSString* ENABLE_PUSH_STRING();
/** "Facebook", the name for facebook */
FOUNDATION_EXPORT NSString* FACEBOOK_STRING();
/** "Push", Title for push-messaging related settings */
FOUNDATION_EXPORT NSString* PUSH_TITLE_STRING();
/** "Account", The string describing a buddy's account */
FOUNDATION_EXPORT NSString* ACCOUNT_STRING();
/** "I/O would block (not fatal)", SSL error message */
FOUNDATION_EXPORT NSString* errSSLWouldBlockString();
/** "Connecting to Tor", Message shown when connecting to the Tor network */
FOUNDATION_EXPORT NSString* CONNECTING_TO_TOR_STRING();
/** "Chat", Title for chat view */
FOUNDATION_EXPORT NSString* CHAT_STRING();
/** "Received a heartbeat.", Error string for OTR message string */
FOUNDATION_EXPORT NSString* OTRL_MSGEVENT_LOG_HEARTBEAT_RCVD_STRING();
/** "Do Not Disturb", Default message when a user status is set to do not disturb */
FOUNDATION_EXPORT NSString* DO_NOT_DISTURB_STRING();
/** "SSL protocol error", SSL error message */
FOUNDATION_EXPORT NSString* errSSLProtocolString();
/** "Chat with me securely", Body of SMS or email when sharing a link to the app */
FOUNDATION_EXPORT NSString* SHARE_MESSAGE_STRING();
/** "Sent a heartbeat.", Error string for OTR message string */
FOUNDATION_EXPORT NSString* OTRL_MSGEVENT_LOG_HEARTBEAT_SENT_STRING();
/** "We could not find any trusted devices for this account.", Error message for not finding any devices */
FOUNDATION_EXPORT NSString* NO_DEVICES_ACCOUNT_ERROR_STRING();
/** "To use this feature you must re-enable microphone permissions.", microphone permission is disabled */
FOUNDATION_EXPORT NSString* Microphone_Reenable_Please();
/** "Valid certificate", shown to show that the certificate was valid to the system */
FOUNDATION_EXPORT NSString* VALID_CERTIFICATE_STRING();
/** "Unexpected message received", SSL error message */
FOUNDATION_EXPORT NSString* errSSLPeerUnexpectedMsgString();
/** "Delete chats on disconnect", Description for automatic conversation deletion */
FOUNDATION_EXPORT NSString* DELETE_CONVERSATIONS_ON_DISCONNECT_DESCRIPTION_STRING();
/** "Chats", Title for chats view */
FOUNDATION_EXPORT NSString* CHATS_STRING();
/** "Help Translate", Label for button to open link to translate app */
FOUNDATION_EXPORT NSString* HELP_TRANSLATE_STRING();
/** "Decryption error", SSL error message */
FOUNDATION_EXPORT NSString* errSSLPeerDecryptErrorString();
/** "Bad certificate format", SSL error message */
FOUNDATION_EXPORT NSString* errSSLBadCertString();
/** "Peer dropped connection before responding", SSL error message */
FOUNDATION_EXPORT NSString* errSSLConnectionRefusedString();
/** "Security Warning", Title of alert box warning about security issues */
FOUNDATION_EXPORT NSString* SECURITY_WARNING_STRING();
/** "Verified", To let the user know the fingerprint as been checked */
FOUNDATION_EXPORT NSString* VERIFIED_STRING();
/** "Buddy Info", The title for the view that shows detailed buddy info */
FOUNDATION_EXPORT NSString* BUDDY_INFO_STRING();
/** "Connecting", String to state if an account is progress of creating a connection */
FOUNDATION_EXPORT NSString* CONNECTING_STRING();
/** "Knock", Label for button after to send push notification knock. Like knocking on a door */
FOUNDATION_EXPORT NSString* KNOCK_STRING();
/** "Check out the source here on Github", let users know source is on Github */
FOUNDATION_EXPORT NSString* SOURCE_STRING();
/** "Remember password", label for switch for whether or not we should save their password between launches */
FOUNDATION_EXPORT NSString* REMEMBER_PASSWORD_STRING();
/** "We can automatically generate you a secure password. If you choose your own, make sure it's a unique password you don't use anywhere else.", help text for password generator */
FOUNDATION_EXPORT NSString* Generate_Secure_Password_Hint();
/** "Enable Push in Settings", button for enabling push messages in iOS system settings */
FOUNDATION_EXPORT NSString* ENABLE_PUSH_IN_SETTINGS_STRING();
/** "Best Available",  */
FOUNDATION_EXPORT NSString* Best_Available();
/** "Settings", Title for the Settings screen */
FOUNDATION_EXPORT NSString* SETTINGS_STRING();
/** "Encryption Error", Generic title for encryption errors */
FOUNDATION_EXPORT NSString* ENCRYPTION_ERROR_STRING();
/** "Sign Up", title label for signing up for a new account */
FOUNDATION_EXPORT NSString* SIGN_UP_STRING();
/** "Remember Passphrase", Label for switch to save passphrase */
FOUNDATION_EXPORT NSString* REMEMBER_PASSPHRASE_STRING();
/** "Manage ChatSecure Push account", Title for button to manage ChatSecure Push account */
FOUNDATION_EXPORT NSString* MANAGE_CHATSECURE_PUSH_ACCOUNT_STRING();
/** "Miscellaneous bad certificate", SSL error message */
FOUNDATION_EXPORT NSString* errSSLPeerBadCertString();
/** "Add Existing Account", Label for button to create account by logging into an existing account */
FOUNDATION_EXPORT NSString* ADD_EXISTING_STRING();
/** "Generate Secure Password", whether or not we should generate a strong password for them */
FOUNDATION_EXPORT NSString* Generate_Secure_Password();
/** "Old", For an old settings value */
FOUNDATION_EXPORT NSString* OLD_STRING();
/** "Because the database contents is encrypted with your passphrase, you've lost access to your data and will need to delete and reinstall ChatSecure to continue. Password managers like 1Password or MiniKeePass can be helpful for generating and storing strong passwords.", Text describing what happens when the user has forgotten the passphrase */
FOUNDATION_EXPORT NSString* FORGOT_PASSPHRASE_INFO_STRING();
/** "Choose Server", title for server selection screen */
FOUNDATION_EXPORT NSString* Choose_Server_String();
/** "Attempt to restore an unknown session", SSL error message */
FOUNDATION_EXPORT NSString* errSSLSessionNotFoundString();
/** "Info", Short for information, button title to get more information */
FOUNDATION_EXPORT NSString* INFO_STRING();
/** "Other", Title for other miscellaneous settings group */
FOUNDATION_EXPORT NSString* OTHER_STRING();
/** "Reply", Reply to an incoming message */
FOUNDATION_EXPORT NSString* REPLY_STRING();
/** "The XMPP server does not support in-band registration", Error message for when in band registration is not supported */
FOUNDATION_EXPORT NSString* IN_BAND_ERROR_STRING();
/** "Available", Label in buddy list for users that are available */
FOUNDATION_EXPORT NSString* AVAILABLE_STRING();
/** "Create New Account", Label for button to create a new account via in band registration */
FOUNDATION_EXPORT NSString* CREATE_NEW_ACCOUNT_STRING();
/** "Optional", Hint text for domain field telling user this field is not required */
FOUNDATION_EXPORT NSString* OPTIONAL_STRING();
/** "Plaintext Only",  */
FOUNDATION_EXPORT NSString* Plaintext_Only();
/** "Chain had a cert not yet valid", SSL error message */
FOUNDATION_EXPORT NSString* errSSLCertNotYetValidString();
/** "User canceled", SSL error message */
FOUNDATION_EXPORT NSString* errSSLPeerUserCancelledString();
/** "Delivered", Shows in the chat view when a message has been delivered */
FOUNDATION_EXPORT NSString* DELIVERED_STRING();
/** "About", Title for the about page */
FOUNDATION_EXPORT NSString* ABOUT_STRING();
/** "Please choose a valid email address", detail title label for invalid email */
FOUNDATION_EXPORT NSString* INVALID_EMAIL_DETAIL_STRING();
/** "Share Invite", Label for inviting friends via URL */
FOUNDATION_EXPORT NSString* INVITE_LINK_STRING();
/** "Compose", Label for text field where you compose a new message */
FOUNDATION_EXPORT NSString* COMPOSE_STRING();
/** "This message was sent to an untrusted device.", Error message description */
FOUNDATION_EXPORT NSString* UNTRUSTED_DEVICE_SENT_STRING();
/** "New", For a new settings value */
FOUNDATION_EXPORT NSString* NEW_STRING();
/** "Next", Label for button to go to next step */
FOUNDATION_EXPORT NSString* NEXT_STRING();
/** "Enable", enable permission */
FOUNDATION_EXPORT NSString* Enable_String();
/** "Scan QR", Label for sharing via QR Code */
FOUNDATION_EXPORT NSString* SCAN_QR_STRING();
/** "Basic", string to describe basic set of settings */
FOUNDATION_EXPORT NSString* BASIC_STRING();
/** "Language", string to bring up language selector */
FOUNDATION_EXPORT NSString* LANGUAGE_STRING();
/** "Valid cert chain, untrusted root", SSL error message */
FOUNDATION_EXPORT NSString* errSSLUnknownRootCertString();
/** "The message received contains malformed data.", Error string for OTR message string */
FOUNDATION_EXPORT NSString* OTRL_MSGEVENT_RCVDMSG_MALFORMED_STRING();
/** "Saved Certificates", Title for listing the user saved SSL certificates */
FOUNDATION_EXPORT NSString* SAVED_CERTIFICATES_STRING();
/** "Block & Remove", The String for a buddy to block and remove a buddy from the buddy list */
FOUNDATION_EXPORT NSString* BLOCK_AND_REMOVE_STRING();
/** "Creating Account", Title for progress of creating a new account */
FOUNDATION_EXPORT NSString* CREATING_ACCOUNT_STRING();
/** "Hold to talk", Label for button to hold to record audio */
FOUNDATION_EXPORT NSString* HOLD_TO_TALK_STRING();
/** "Bad MAC", SSL error message */
FOUNDATION_EXPORT NSString* errSSLBadRecordMacString();
/** "Someone", A placeholder for a buddy's username like Someone wants to chat. */
FOUNDATION_EXPORT NSString* SOMEONE_STRING();
/** "Profile", title for contacts profile view */
FOUNDATION_EXPORT NSString* Profile_String();
/** "Unexpected (skipped) record in DTLS", SSL error message */
FOUNDATION_EXPORT NSString* errSSLUnexpectedRecordString();
/** "Certificate revoked", SSL error message */
FOUNDATION_EXPORT NSString* errSSLPeerCertRevokedString();
/** "Failed to connect to XMPP server. Please check your login credentials and internet connection and try again.", Message when cannot connect to XMPP server */
FOUNDATION_EXPORT NSString* XMPP_FAIL_STRING();
/** "Cannot recognize the type of OTR message received.", Error string for OTR message string */
FOUNDATION_EXPORT NSString* OTRL_MSGEVENT_RCVDMSG_UNRECOGNIZED_STRING();
/** "Don't change these unless you really know what you're doing. By default we will always select the best available encryption method.",  */
FOUNDATION_EXPORT NSString* Advanced_Crypto_Warning();
/** "Release to send", Label for instruction to send current audio */
FOUNDATION_EXPORT NSString* RELEASE_TO_SEND_STRING();
/** "Invalid certificate chain", SSL error message */
FOUNDATION_EXPORT NSString* errSSLXCertChainInvalidString();
/** "Email", The string describing account name or email address for a buddy */
FOUNDATION_EXPORT NSString* EMAIL_STRING();
/** "user@example.com", Example of a username using the words user and example */
FOUNDATION_EXPORT NSString* XMPP_USERNAME_EXAMPLE_STRING();
/** "Log In", log in to account */
FOUNDATION_EXPORT NSString* LOGIN_STRING();
/** "Would you like to connect to UserVoice to send feedback?", actionsheet for showing uservoice feedback service */
FOUNDATION_EXPORT NSString* SHOW_USERVOICE_STRING();
/** "About This Version", Label for button to show version numbers and licenses */
FOUNDATION_EXPORT NSString* ABOUT_VERSION_STRING();
/** "Take Photo", Label for button to take a photo from camera */
FOUNDATION_EXPORT NSString* USE_CAMERA_STRING();
/** "Connection closed gracefully", SSL error message */
FOUNDATION_EXPORT NSString* errSSLClosedGracefulString();
/** "Manage saved SSL certificates", subtitle for the certificate pinned setting */
FOUNDATION_EXPORT NSString* PINNED_CERTIFICATES_DESCRIPTION_STRING();
/** "Customize Username", if you want to change your username */
FOUNDATION_EXPORT NSString* Customize_Username();
/** "Remove", The String for a button to remove a buddy from the buddy list */
FOUNDATION_EXPORT NSString* REMOVE_STRING();
/** "Default", default string to revert to normal language behaviour */
FOUNDATION_EXPORT NSString* DEFAULT_LANGUAGE_STRING();
NS_ASSUME_NONNULL_END
