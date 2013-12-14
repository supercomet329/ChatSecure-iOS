#import "OTRLanguageManager.h"

// DO NOT EDIT THIS FILE. EDIT strings.json then run python StringsConverter.py

#define errSSLCryptoString [OTRLanguageManager translatedString: @"Underlying cryptographic error"]
#define OFFLINE_STRING [OTRLanguageManager translatedString: @"Offline"]
#define ERROR_STRING [OTRLanguageManager translatedString: @"Error!"]
#define LOGOUT_STRING [OTRLanguageManager translatedString: @"Log Out"]
#define DELETE_CONVERSATIONS_ON_DISCONNECT_TITLE_STRING [OTRLanguageManager translatedString: @"Auto-delete"]
#define DONE_STRING [OTRLanguageManager translatedString: @"Done"]
#define errSSLPeerCertExpiredString [OTRLanguageManager translatedString: @"Certificate expired"]
#define CONVERSATION_NO_LONGER_SECURE_STRING [OTRLanguageManager translatedString: @"The conversation with %@ is no longer secure."]
#define USER_PASS_BLANK_STRING [OTRLanguageManager translatedString: @"You must enter a username and a password to login."]
#define THEIR_FINGERPRINT_STRING [OTRLanguageManager translatedString: @"Purported fingerprint for"]
#define errSSLPeerAuthCompletedString [OTRLanguageManager translatedString: @"Peer cert is valid, or was ignored if verification disabled"]
#define YOUR_STATUS_MESSAGE [OTRLanguageManager translatedString: @"You are: %@"]
#define PASSWORD_STRING [OTRLanguageManager translatedString: @"Password"]
#define ADVANCED_STRING [OTRLanguageManager translatedString: @"Advanced"]
#define ATTRIBUTION_STRING [OTRLanguageManager translatedString: @"ChatSecure is brought to you by many open source projects"]
#define CHAT_STATE_GONE_STRING [OTRLanguageManager translatedString: @"Gone"]
#define VERSION_STRING [OTRLanguageManager translatedString: @"Version"]
#define errSSLPeerCertUnknownString [OTRLanguageManager translatedString: @"Unknown certificate"]
#define INITIATE_ENCRYPTED_CHAT_STRING [OTRLanguageManager translatedString: @"Initiate Encrypted Chat"]
#define SEND_DELIVERY_RECEIPT_STRING [OTRLanguageManager translatedString: @"Send Delivery Receipts"]
#define REQUIRE_TLS_STRING [OTRLanguageManager translatedString: @"Require TLS"]
#define SEND_TYPING_NOTIFICATION_STRING [OTRLanguageManager translatedString: @"Send Typing Notification"]
#define CONNECTED_STRING [OTRLanguageManager translatedString: @"Connected"]
#define errSSLClientCertRequestedString [OTRLanguageManager translatedString: @"Server has requested a client cert"]
#define CHAT_STATE_INACTVIE_STRING [OTRLanguageManager translatedString: @"Inactive"]
#define NO_ACCOUNT_SAVED_STRING [OTRLanguageManager translatedString: @"No Saved Accounts"]
#define errSSLClosedNoNotifyString [OTRLanguageManager translatedString: @"Server closed session with no notification"]
#define GROUPS_STRING [OTRLanguageManager translatedString: @"Groups"]
#define NEW_CERTIFICATE_STRING [OTRLanguageManager translatedString: @"New SSL Certificate"]
#define LOGIN_STRING [OTRLanguageManager translatedString: @"Log In"]
#define CHAT_STATE_PAUSED_STRING [OTRLanguageManager translatedString: @"Entered Text"]
#define REMOVE_STRING [OTRLanguageManager translatedString: @"Remove"]
#define errSSLPeerDecodeErrorString [OTRLanguageManager translatedString: @"Decoding error"]
#define errSSLRecordOverflowString [OTRLanguageManager translatedString: @"Record overflow"]
#define errSSLDecryptionFailString [OTRLanguageManager translatedString: @"Decryption failure"]
#define ADD_STRING [OTRLanguageManager translatedString: @"Add"]
#define CRITTERCISM_TITLE_STRING [OTRLanguageManager translatedString: @"Send Crash Reports"]
#define CONVERSATION_SECURE_WARNING_STRING [OTRLanguageManager translatedString: @"This chat is secured"]
#define CHAT_INSTRUCTIONS_LABEL_STRING [OTRLanguageManager translatedString: @"Log in on the Settings page (found on top right corner of buddy list) and then select a buddy from the Buddy List to start chatting."]
#define DELETE_ACCOUNT_MESSAGE_STRING [OTRLanguageManager translatedString: @"Permanently delete"]
#define GROUP_STRING [OTRLanguageManager translatedString: @"Group"]
#define REMEMBER_USERNAME_STRING [OTRLanguageManager translatedString: @"Remember username"]
#define CONNECT_ANYWAY_STRING [OTRLanguageManager translatedString: @"Connect anyway"]
#define SAVE_STRING [OTRLanguageManager translatedString: @"Save"]
#define errSSLNoRootCertString [OTRLanguageManager translatedString: @"Cert chain not verified by root"]
#define IGNORE_STRING [OTRLanguageManager translatedString: @"Ignore"]
#define PENDING_APPROVAL_STRING [OTRLanguageManager translatedString: @"Pending Approval"]
#define LANGUAGE_ALERT_TITLE_STRING [OTRLanguageManager translatedString: @"Language Change"]
#define JABBER_STRING [OTRLanguageManager translatedString: @"Jabber (XMPP)"]
#define VERIFY_STRING [OTRLanguageManager translatedString: @"Verify"]
#define noErrString [OTRLanguageManager translatedString: @"No Error"]
#define errSSLBadConfigurationString [OTRLanguageManager translatedString: @"Configuration error"]
#define ADD_BUDDY_STRING [OTRLanguageManager translatedString: @"Add Buddy"]
#define errSSLPeerDecompressFailString [OTRLanguageManager translatedString: @"Decompression failure"]
#define FONT_SIZE_DESCRIPTION_STRING [OTRLanguageManager translatedString: @"Size for font in chat view"]
#define errSSLPeerProtocolVersionString [OTRLanguageManager translatedString: @"Bad protocol version"]
#define RECENT_STRING [OTRLanguageManager translatedString: @"Recent"]
#define errSSLBufferOverflowString [OTRLanguageManager translatedString: @"Insufficient buffer provided"]
#define CONVERSATION_SECURE_AND_VERIFIED_WARNING_STRING [OTRLanguageManager translatedString: @"This chat is secured and verified"]
#define AGREE_STRING [OTRLanguageManager translatedString: @"Agree"]
#define BASIC_STRING [OTRLanguageManager translatedString: @"Basic"]
#define DONATE_STRING [OTRLanguageManager translatedString: @"Donate"]
#define errSSLModuleAttachString [OTRLanguageManager translatedString: @"Module attach failure"]
#define SEND_STRING [OTRLanguageManager translatedString: @"Send"]
#define errSSLPeerAccessDeniedString [OTRLanguageManager translatedString: @"Access denied"]
#define errSSLPeerInternalErrorString [OTRLanguageManager translatedString: @"Internal error"]
#define LOGIN_TO_STRING [OTRLanguageManager translatedString: @"Login to"]
#define ALLOW_PLAIN_TEXT_AUTHENTICATION_STRING [OTRLanguageManager translatedString: @"Allow Plaintext Authentication"]
#define SAVED_CERTIFICATES_STRING [OTRLanguageManager translatedString: @"Saved Certificates"]
#define NEW_ACCOUNT_STRING [OTRLanguageManager translatedString: @"New Account"]
#define REJECT_STRING [OTRLanguageManager translatedString: @"Reject"]
#define AWAY_MESSAGE_STRING [OTRLanguageManager translatedString: @"is now away"]
#define OPEN_IN_SAFARI_STRING [OTRLanguageManager translatedString: @"Open in Safari"]
#define AWAY_STRING [OTRLanguageManager translatedString: @"Away"]
#define HOSTNAME_STRING [OTRLanguageManager translatedString: @"Hostname"]
#define errSSLPeerInsufficientSecurityString [OTRLanguageManager translatedString: @"Insufficient security"]
#define LANGUAGE_ALERT_MESSAGE_STRING [OTRLanguageManager translatedString: @"In order to change languages return to the home screen and remove ChatSecure from the recently used apps"]
#define SOURCE_STRING [OTRLanguageManager translatedString: @"Check out the source here on Github"]
#define AIM_STRING [OTRLanguageManager translatedString: @"OSCAR Instant Messenger"]
#define DISCONNECTION_WARNING_DESC_STRING [OTRLanguageManager translatedString: @"1 Minute Alert Before Disconnection"]
#define MESSAGE_PLACEHOLDER_STRING [OTRLanguageManager translatedString: @"Message"]
#define CLEAR_CHAT_HISTORY_STRING [OTRLanguageManager translatedString: @"Clear Chat History"]
#define errSSLPeerDecryptionFailString [OTRLanguageManager translatedString: @"Decryption failed"]
#define errSSLPeerDecryptErrorString [OTRLanguageManager translatedString: @"Decryption error"]
#define ACCOUNTS_STRING [OTRLanguageManager translatedString: @"Accounts"]
#define CRITTERCISM_DESCRIPTION_STRING [OTRLanguageManager translatedString: @"Automatically send anonymous crash logs (opt-in)"]
#define errSSLCertExpiredString [OTRLanguageManager translatedString: @"Chain had an expired cert"]
#define DISCONNECTED_TITLE_STRING [OTRLanguageManager translatedString: @"Disconnected"]
#define errSSLHostNameMismatchString [OTRLanguageManager translatedString: @"Peer host name mismatch"]
#define errSSLNegotiationString [OTRLanguageManager translatedString: @"Cipher Suite negotiation failure"]
#define errSSLPeerExportRestrictionString [OTRLanguageManager translatedString: @"Export restriction"]
#define errSSLPeerHandshakeFailString [OTRLanguageManager translatedString: @"Handshake failure"]
#define GOOGLE_TALK_STRING [OTRLanguageManager translatedString: @"Google Talk"]
#define DISAGREE_STRING [OTRLanguageManager translatedString: @"Disagree"]
#define errSSLFatalAlertString [OTRLanguageManager translatedString: @"Fatal alert"]
#define USERNAME_STRING [OTRLanguageManager translatedString: @"Username"]
#define errSSLPeerNoRenegotiationString [OTRLanguageManager translatedString: @"No renegotiation allowed"]
#define SHARE_STRING [OTRLanguageManager translatedString: @"Share"]
#define OPPORTUNISTIC_OTR_SETTING_TITLE [OTRLanguageManager translatedString: @"Auto-start Encryption"]
#define SEND_FEEDBACK_STRING [OTRLanguageManager translatedString: @"Send Feedback"]
#define NAME_STRING [OTRLanguageManager translatedString: @"Name"]
#define BLOCK_STRING [OTRLanguageManager translatedString: @"Block"]
#define OK_STRING [OTRLanguageManager translatedString: @"OK"]
#define OPPORTUNISTIC_OTR_SETTING_DESCRIPTION [OTRLanguageManager translatedString: @"Enables opportunistic OTR"]
#define errSSLUnexpectedRecordString [OTRLanguageManager translatedString: @"Unexpected (skipped) record in DTLS"]
#define PORT_STRING [OTRLanguageManager translatedString: @"Port"]
#define errSSLClosedAbortString [OTRLanguageManager translatedString: @"Connection closed via error"]
#define SECURITY_STRING [OTRLanguageManager translatedString: @"Security"]
#define SUBSCRIPTION_REQUEST_TITLE [OTRLanguageManager translatedString: @"Subscription Requests"]
#define VERIFY_FINGERPRINT_STRING [OTRLanguageManager translatedString: @"Verify Fingerprint"]
#define DELETE_ACCOUNT_TITLE_STRING [OTRLanguageManager translatedString: @"Delete Account?"]
#define errSSLPeerUnsupportedCertString [OTRLanguageManager translatedString: @"Bad unsupported cert format"]
#define VERIFY_LATER_STRING [OTRLanguageManager translatedString: @"Verify Later"]
#define errSSLBadCipherSuiteString [OTRLanguageManager translatedString: @"Bad SSLCipherSuite"]
#define OFFLINE_MESSAGE_STRING [OTRLanguageManager translatedString: @"is now offline"]
#define errSSLBadRecordMacString [OTRLanguageManager translatedString: @"Bad MAC"]
#define CONNECT_FACEBOOK_STRING [OTRLanguageManager translatedString: @"Connect Facebook"]
#define DISMISS_STRING [OTRLanguageManager translatedString: @"Dismiss"]
#define EXPIRATION_STRING [OTRLanguageManager translatedString: @"Background session will expire in one minute."]
#define NOT_AVAILABLE_STRING [OTRLanguageManager translatedString: @"Not Available"]
#define DISCONNECT_FACEBOOK_STRING [OTRLanguageManager translatedString: @"Disconnect Facebook"]
#define LOGOUT_FROM_AIM_STRING [OTRLanguageManager translatedString: @"Logout from OSCAR?"]
#define errSSLPeerUnknownCAString [OTRLanguageManager translatedString: @"Unknown Cert Authority"]
#define XMPP_CERT_FAIL_STRING [OTRLanguageManager translatedString: @"There was an error validating the certificate for %@. This may indicate that someone is trying to intercept your communications."]
#define FACEBOOK_STRING [OTRLanguageManager translatedString: @"Facebook"]
#define errSSLPeerRecordOverflowString [OTRLanguageManager translatedString: @"Record overflow"]
#define ACCOUNT_STRING [OTRLanguageManager translatedString: @"Account"]
#define FACEBOOK_HELP_STRING [OTRLanguageManager translatedString: @"Your Facebook username is not the email address that you use to login to Facebook"]
#define errSSLInternalString [OTRLanguageManager translatedString: @"Internal error"]
#define CHAT_STRING [OTRLanguageManager translatedString: @"Chat"]
#define DO_NOT_DISTURB_STRING [OTRLanguageManager translatedString: @"Do Not Disturb"]
#define errSSLProtocolString [OTRLanguageManager translatedString: @"SSL protocol error"]
#define CONVERSATIONS_STRING [OTRLanguageManager translatedString: @"Conversations"]
#define SHARE_MESSAGE_STRING [OTRLanguageManager translatedString: @"Chat with me securely"]
#define XMPP_FAIL_STRING [OTRLanguageManager translatedString: @"Failed to connect to XMPP server. Please check your login credentials and internet connection and try again."]
#define XMPP_PORT_FAIL_STRING [OTRLanguageManager translatedString: @"Domain needs to be set manually when specifying a custom port"]
#define VALID_CERTIFICATE_STRING [OTRLanguageManager translatedString: @"Valid certificate"]
#define errSSLPeerUnexpectedMsgString [OTRLanguageManager translatedString: @"Unexpected message received"]
#define DELETE_CONVERSATIONS_ON_DISCONNECT_DESCRIPTION_STRING [OTRLanguageManager translatedString: @"Delete chats on disconnect"]
#define SECURITY_WARNING_DESCRIPTION_STRING [OTRLanguageManager translatedString: @"Warning: Use with caution! This may reduce your security."]
#define NOT_VERIFIED_STRING [OTRLanguageManager translatedString: @"Not Verified"]
#define INCOMING_STATUS_MESSAGE [OTRLanguageManager translatedString: @"New Status Message: %@"]
#define errSSLBadCertString [OTRLanguageManager translatedString: @"Bad certificate format"]
#define errSSLConnectionRefusedString [OTRLanguageManager translatedString: @"Peer dropped connection before responding"]
#define SECURITY_WARNING_STRING [OTRLanguageManager translatedString: @"Security Warning"]
#define VERIFIED_STRING [OTRLanguageManager translatedString: @"Verified"]
#define BUDDY_INFO_STRING [OTRLanguageManager translatedString: @"Buddy Info"]
#define CHAT_STATE_COMPOSING_STRING [OTRLanguageManager translatedString: @"Typing"]
#define errSSLWouldBlockString [OTRLanguageManager translatedString: @"I/O would block (not fatal)"]
#define QR_CODE_INSTRUCTIONS_STRING [OTRLanguageManager translatedString: @"This QR Code contains a link to http://omniqrcode.com/q/chatsecure and will redirect to the App Store."]
#define REMEMBER_PASSWORD_STRING [OTRLanguageManager translatedString: @"Remember password"]
#define CONVERSATION_NOT_SECURE_WARNING_STRING [OTRLanguageManager translatedString: @"Warning: This chat is not encrypted"]
#define ALLOW_SSL_HOSTNAME_MISMATCH_STRING [OTRLanguageManager translatedString: @"Hostname Mismatch"]
#define CANCEL_ENCRYPTED_CHAT_STRING [OTRLanguageManager translatedString: @"Cancel Encrypted Chat"]
#define PROJECT_HOMEPAGE_STRING [OTRLanguageManager translatedString: @"Project Homepage"]
#define SETTINGS_STRING [OTRLanguageManager translatedString: @"Settings"]
#define SECURE_CONVERSATION_STRING [OTRLanguageManager translatedString: @"You must be in a secure conversation first."]
#define LOGOUT_FROM_XMPP_STRING [OTRLanguageManager translatedString: @"Logout from XMPP?"]
#define SSL_MISMATCH_STRING [OTRLanguageManager translatedString: @"SSL Hostname Mismatch"]
#define PINNED_CERTIFICATES_STRING [OTRLanguageManager translatedString: @"Pinned Certificates"]
#define errSSLPeerBadCertString [OTRLanguageManager translatedString: @"Miscellaneous bad certificate"]
#define DEFAULT_BUDDY_GROUP_STRING [OTRLanguageManager translatedString: @"Buddies"]
#define OLD_STRING [OTRLanguageManager translatedString: @"Old"]
#define errSSLSessionNotFoundString [OTRLanguageManager translatedString: @"Attempt to restore an unknown session"]
#define INFO_STRING [OTRLanguageManager translatedString: @"Info"]
#define EXTENDED_AWAY_STRING [OTRLanguageManager translatedString: @"Extended Away"]
#define OTHER_STRING [OTRLanguageManager translatedString: @"Other"]
#define REPLY_STRING [OTRLanguageManager translatedString: @"Reply"]
#define AVAILABLE_STRING [OTRLanguageManager translatedString: @"Available"]
#define OPTIONAL_STRING [OTRLanguageManager translatedString: @"Optional"]
#define errSSLCertNotYetValidString [OTRLanguageManager translatedString: @"Chain had a cert not yet valid"]
#define errSSLPeerUserCancelledString [OTRLanguageManager translatedString: @"User canceled"]
#define DELIVERED_STRING [OTRLanguageManager translatedString: @"Delivered"]
#define ABOUT_STRING [OTRLanguageManager translatedString: @"About"]
#define REQUIRED_STRING [OTRLanguageManager translatedString: @"Required"]
#define DISCONNECTION_WARNING_STRING [OTRLanguageManager translatedString: @"When you leave this conversation it will be deleted forever."]
#define YOUR_FINGERPRINT_STRING [OTRLanguageManager translatedString: @"Fingerprint for you"]
#define NEW_STRING [OTRLanguageManager translatedString: @"New"]
#define OSCAR_FAIL_STRING [OTRLanguageManager translatedString: @"Failed to start authenticating. Please try again."]
#define CONTRIBUTE_TRANSLATION_STRING [OTRLanguageManager translatedString: @"Contribute a translation"]
#define LANGUAGE_STRING [OTRLanguageManager translatedString: @"Language"]
#define errSSLUnknownRootCertString [OTRLanguageManager translatedString: @"Valid cert chain, untrusted root"]
#define DISCONNECTED_MESSAGE_STRING [OTRLanguageManager translatedString: @"You (%@) have disconnected."]
#define AVAILABLE_MESSAGE_STRING [OTRLanguageManager translatedString: @"is now available"]
#define errSSLPeerBadRecordMacString [OTRLanguageManager translatedString: @"Bad MAC"]
#define BLOCK_AND_REMOVE_STRING [OTRLanguageManager translatedString: @"Block & Remove"]
#define errSSLIllegalParamString [OTRLanguageManager translatedString: @"Illegal parameter"]
#define ALLOW_SELF_SIGNED_CERTIFICATES_STRING [OTRLanguageManager translatedString: @"Self-Signed SSL"]
#define DISCONNECTION_WARNING_TITLE_STRING [OTRLanguageManager translatedString: @"Sign out Warning"]
#define CHAT_STATE_ACTIVE_STRING [OTRLanguageManager translatedString: @"Active"]
#define BUDDY_LIST_STRING [OTRLanguageManager translatedString: @"Buddy List"]
#define errSSLPeerCertRevokedString [OTRLanguageManager translatedString: @"Certificate revoked"]
#define READ_STRING [OTRLanguageManager translatedString: @"Read"]
#define LOGGING_IN_STRING [OTRLanguageManager translatedString: @"Logging in..."]
#define GOOGLE_TALK_EXAMPLE_STRING [OTRLanguageManager translatedString: @"user@gmail.com"]
#define DONATE_MESSAGE_STRING [OTRLanguageManager translatedString: @"Your donation will help fund the continued development of ChatSecure."]
#define errSSLXCertChainInvalidString [OTRLanguageManager translatedString: @"Invalid certificate chain"]
#define EMAIL_STRING [OTRLanguageManager translatedString: @"Email"]
#define BUNDLED_CERTIFICATES_STRING [OTRLanguageManager translatedString: @"Bundled Certificates"]
#define FONT_SIZE_STRING [OTRLanguageManager translatedString: @"Font Size"]
#define SELF_SIGNED_SSL_STRING [OTRLanguageManager translatedString: @"Self Signed SSL"]
#define CANCEL_STRING [OTRLanguageManager translatedString: @"Cancel"]
#define errSSLClosedGracefulString [OTRLanguageManager translatedString: @"Connection closed gracefully"]
#define PINNED_CERTIFICATES_DESCRIPTION_STRING [OTRLanguageManager translatedString: @"Manage saved SSL certificates"]
#define DEFAULT_LANGUAGE_STRING NSLocalizedString(@"Default", @"default string to revert to normal language behaviour")