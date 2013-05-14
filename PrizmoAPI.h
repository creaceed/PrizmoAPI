//
//  PrizmoAPI.h
//  iPrizmo
//
//  Created by Raphael Sebbe on 22/02/13.
//
//

#import "IACClient.h"

extern NSString * const PrizmoActionErrorDomain;
extern NSString * const PrizmoActionURLScheme;

// Actions types
extern NSString * const PrizmoActionCaptureText;
extern NSString * const PrizmoActionReadText;


// ========= Input parameter keys ==========
// Read Text
extern NSString * const PrizmoReadTextOptionLanguageKey;		// "language"
extern NSString * const PrizmoReadTextOptionVoiceNameKey;		// "voice"
extern NSString * const PrizmoReadTextOptionTextKey;			// "text"

// Capture Text
extern NSString * const PrizmoCaptureTextOptionLanguageKey;		// "language", if not specified or if the language doesn't exist, the actual language choosed in Prizmo.
extern NSString * const PrizmoCaptureTextOptionCropModeKey;		// "cropMode", possible values: oneline, full, manual (default), detect.
extern NSString * const PrizmoCaptureTextOptionDestinationKey;	// "destination", possible values: url (default), general (for general pasteboard), com.any.pasteboard.name
extern NSString * const PrizmoCaptureTextOptionPasteboardName;  // If set, a pasteboard identified by name, otherwise the general pasteboard (default)

// Value for `PrizmoCaptureTextOptionCropModeKey`
extern NSString * const PrizmoCaptureTextOptionCropModeValueOneLine;
extern NSString * const PrizmoCaptureTextOptionCropModeValueFull;
extern NSString * const PrizmoCaptureTextOptionCropModeValueManual;
extern NSString * const PrizmoCaptureTextOptionCropModeValueDetect;

// Value for `PrizmoCaptureTextOptionDestinationKey`
extern NSString * const PrizmoCaptureTextOptionDestinationURL;
extern NSString * const PrizmoCaptureTextOptionDestinationPasteboard;


// ========= Result keys ==========
// Capture Text
extern NSString * const PrizmoCaptureTextResultTextKey;		// "text"


extern NSString * const PrizmoActionErrorDomain;

typedef NS_ENUM(NSInteger, PrizmoActionErrorCode) {
    PrizmoNoError = 0,
	PrizmoErrorUnknown = 1,
	PrizmoErrorBadParameter = 2,
};

@interface PrizmoAPI : IACClient

// sample callback (text between '...' should be URL-encoded
// prizmo://x-callback-url/captureText?&language=en&x-source='Prizmo API Tester'&x-cancel='prizmoapitester://x-callback-url/IACRequestResponse?&IACRequestID=64A62FD7-E417-44B0-A387-FB57133C8991&IACResponseType=2&'&x-error='prizmoapitester://x-callback-url/IACRequestResponse?&IACRequestID=64A62FD7-E417-44B0-A387-FB57133C8991&IACResponseType=1&'&x-success='prizmoapitester://x-callback-url/IACRequestResponse?&IACRequestID=64A62FD7-E417-44B0-A387-FB57133C8991&IACResponseType=0&'&
- (void)captureTextWithOptions:(NSDictionary*)options completionHandler:(void(^)(NSString *text, NSError *error))handler;

- (void)readText:(NSString*)text options:(NSDictionary*)options completionHandler:(void(^)(BOOL completed, NSError *error))handler;

@end
