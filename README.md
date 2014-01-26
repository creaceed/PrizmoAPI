# PrizmoAPI

[Prizmo](http://www.creaceed.com/iprizmo/about) offers its OCR and Text-to-speech capabilities to other apps through a custom URL scheme. Moreover, this custom URL scheme is compliant to the [x-callback-url](http://x-callback-url.com) protocol.

Prizmo's x-callback-url API can be used directly (no need of this PrizmoAPI Objective-C SDK) with standard x-callback-url invocations. But an Objective-C API is also provided to make it easier to integrate the features in an app if needed.

PrizmoAPI SDK depends on [InterAppCommunication](https://github.com/tapsandswipes/InterAppCommunication).

## Invoking Prizmo with standard x-callback-url calls

Prizmo can be invoked from other apps to perform scanning, OCR, or text reading. This is handled with a custom URL scheme. 

This automation scheme can be directly invoked using the documentation below. Alternatively, it can be invoked from another app using the *Prizmo API SDK* (Objective-C), that can be found on [here](http://www.creaceed.com/iprizmo/faq). 

#### Capturing Text

Other apps can initiate text capture with Prizmo. Here is an example of how this is achieved:

**prizmo://x-callback-url/captureText?language=en&destination=pasteboard**

This will start Prizmo to take a picture and perform English OCR on it. The following options are supported:

- **language:** language can be any ISO 639-1 language code (like en, fr, de) and will instruct which language should be picked in the OCR engine.
- **destination:** destination can be either 'url' to send the captured text in the callback URL to the calling app, or 'pasteboard' to write the text in a pasteboard.
- **pasteboardName:** when destination is set to 'pasteboard', this option can be used to determine which pasteboard should be used (the default value is the general pasteboard).
- **cropMode:** this controls the cropping method used while taking the picture in Prizmo. Possible values are **full**, **oneline**, **manual**, and **detect**. The first 3 values will start Prizmo camera in manual mode (curtain) with **full** being configured as full screen (no cropping), **oneline** as a thin capture line into the picture (for single line of text), and **manual** as the last chosen opening. When **detect** is chosen, Prizmo performs live page detection while shooting.
- **x-success:** this is the URL to be invoked when processing is complete, and it serves to pass the result back to the calling app (or any other app). It must be URL encoded. The resulting text is passed as the **text** argument if destination is set to 'url' (see above)
- **x-cancel:** this is the URL to invoke when the user cancels the processing within Prizmo. It must be URL encoded.
- **x-error:** this is the URL to invoke when an error occurs during the processing in Prizmo. It must be URL encoded.

#### Reading Text

Prizmo Voice Reader, which features high quality voices, can be invoked from other apps. Here is an example of how to achieve that:

**prizmo://x-callback-url/readText?voice=Ryan&text=Hello%20World**

This will read the provided text (Hello World) with the Ryan voice in Prizmo Voice Reader. The following options are supported:

- **text:** this is the text to read in Prizmo Voice Reader. It must be URL encoded.
- **voice:** this is the voice that should be used to read the text. The voice should have been previously installed by the user.
- **language:** if a specific voice is not set, the language can be specified. It will pick the first available voice for that language.
- **x-success:** this is the URL to be invoked when processing is complete. It must be URL encoded.
- **x-cancel:** this is the URL to invoke when the user cancels the processing within Prizmo. It must be URL encoded.
- **x-error:** this is the URL to invoke when an error occurs during the processing in Prizmo. It must be URL encoded.


## Invoking Prizmo using PrizmoAPI SDK (Objective-C)

You first need to import this SDK header files:

``` objective-c
#import "PrizmoAPI.h"
```

Then, in your App delegate (or anywhere else), create a PrizmoAPI instance:

``` objective-c
self.prizmoAPI = [PrizmoAPI client];
```

Finally, invoke Prizmo, either for capturing text:

``` objective-c
- (IBAction)captureText:(id)sender
{    
    NSDictionary * options =
    @{
      PrizmoCaptureTextOptionLanguageKey:@"fr",
      PrizmoCaptureTextOptionCropModeKey : PrizmoCaptureTextOptionCropModeValueManual,
      PrizmoCaptureTextOptionDestinationKey: PrizmoCaptureTextOptionDestinationPasteboard,
      PrizmoCaptureTextOptionPasteboardName : @"titi"
      };
    
	[self.prizmoAPI captureTextWithOptions:options completionHandler:^(NSString *text, NSError *error) {
		if(text)
			self.textView.text = text;
		else
			self.textView.text = error.localizedDescription;
	}];
}
```

or for reading text:

```objective-c
- (IBAction)readText:(id)sender
{
    NSDictionary * options =
    @{
      PrizmoReadTextOptionLanguageKey: @"it"
      };
    
	[self.prizmoAPI readText:self.textView.text options:nil completionHandler:^(BOOL completed, NSError *error) {
		NSLog(@"completed: %d, error: %@", completed, error);
	}];
}
```
