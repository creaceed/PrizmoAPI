//
//  PrizmoAPI.m
//  iPrizmo
//
//  Created by Raphael Sebbe on 22/02/13.
//
//

#import "PrizmoAPI.h"

// Actions
NSString * const PrizmoActionCaptureText = @"captureText";
NSString * const PrizmoActionReadText = @"readText";

// Parameters
NSString * const PrizmoReadTextOptionLanguageKey = @"language";
NSString * const PrizmoReadTextOptionVoiceNameKey = @"voice";
NSString * const PrizmoReadTextOptionTextKey = @"text";

NSString * const PrizmoCaptureTextOptionLanguageKey = @"language";
NSString * const PrizmoCaptureTextOptionCropModeKey = @"cropMode";
NSString * const PrizmoCaptureTextOptionDestinationKey = @"destination";

NSString * const PrizmoCaptureTextOptionCropModeValueOneLine = @"oneline";
NSString * const PrizmoCaptureTextOptionCropModeValueFull = @"full";
NSString * const PrizmoCaptureTextOptionCropModeValueManual = @"manual";
NSString * const PrizmoCaptureTextOptionCropModeValueDetect = @"detect";
NSString * const PrizmoCaptureTextOptionPasteboardName = @"pasteboardName";

NSString * const PrizmoCaptureTextOptionDestinationURL = @"url";
NSString * const PrizmoCaptureTextOptionDestinationPasteboard = @"pasteboard";

// Results
NSString * const PrizmoCaptureTextResultTextKey = @"text";



NSString * const PrizmoActionErrorDomain = @"com.creaceed.iprizmo.ActionErrorDomain";
NSString * const PrizmoActionURLScheme = @"prizmo";

@implementation PrizmoAPI

- (instancetype)init {
    return [self initWithURLScheme:PrizmoActionURLScheme];
}

- (void)captureTextWithOptions:(NSDictionary*)options completionHandler:(void(^)(NSString *text, NSError *error))handler
{
	//if(lang == nil) [NSException raise:NSInvalidArgumentException format:@"language argument should be provided"];
	if(handler == nil) [NSException raise:NSInvalidArgumentException format:@"language argument should be provided"];
	
	handler = [handler copy];
	
//	NSMutableDictionary *params = [NSMutableDictionary dictionary];
//	
//	for(id key in @[PrizmoCaptureTextOptionLanguageKey, PrizmoCaptureTextOptionCropModeKey])
//	{
//		if(options[key])
//			params[key] = options[key];	
//	}
	[self performAction:PrizmoActionCaptureText
			 parameters:options
			  onSuccess:^(NSDictionary *result) {
				  //                  NSString *jsonArray = result[@"names"];
				  //                  NSError * __autoreleasing jserr = nil;
				  //                  NSArray *names = [NSJSONSerialization JSONObjectWithData:[jsonArray dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&jserr];
				  
                  NSString *text = nil;
                  
                  NSString *destination = options[PrizmoCaptureTextOptionDestinationKey];
                  if ([destination isEqualToString:PrizmoCaptureTextOptionDestinationPasteboard]) {
                      NSString *customPasteboardName = options[PrizmoCaptureTextOptionPasteboardName];
                      UIPasteboard *pasteboard = nil;
                      if (customPasteboardName.length > 0) {
                          pasteboard = [UIPasteboard pasteboardWithName:customPasteboardName create:NO];
                      }
                      else {
                          pasteboard = [UIPasteboard generalPasteboard];
                      }
                      text = pasteboard.string;
                  }
                  else { // PrizmoCaptureTextOptionDestinationURL
                      text = result[PrizmoCaptureTextResultTextKey];
                  }
                  
				  handler(text, nil);
                  
                  
			  }
			  onFailure:^(NSError *error) {
				  handler(nil, error);
			  }];
}

- (void)readText:(NSString*)text options:(NSDictionary*)options completionHandler:(void(^)(BOOL completed, NSError *error))handler
{
	if(text == nil) [NSException raise:NSInvalidArgumentException format:@"text argument should be provided"];
	
	handler = [handler copy];
	
	NSMutableDictionary *params = [NSMutableDictionary dictionary];
	
	for(id key in @[PrizmoReadTextOptionLanguageKey, PrizmoReadTextOptionVoiceNameKey])
	{
		if(options[key])
			params[key] = options[key];
	}
	
	params[PrizmoReadTextOptionTextKey] = text;
	
	void(^successHandler)(NSDictionary *result) = nil;
	void(^failureHandler)(NSError *error) = nil;
	
	if(handler)
	{
		successHandler = ^(NSDictionary *result) {
			handler(YES, nil);
		};
		
		failureHandler = ^(NSError *err) {
			handler(NO, err);
		};
	}
	
    [self performAction:PrizmoActionReadText
			 parameters:params
			  onSuccess:successHandler
			  onFailure:failureHandler];
}

@end
