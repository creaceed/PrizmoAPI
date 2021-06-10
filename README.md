# Automation with Prizmo

[Prizmo](https://www.creaceed.com/iprizmo) is a pro scanning app for iPhone & iPad. Prizmo offers automation capabilities that are detailed in this document. Prizmo can be downloaded on the App Store with this [link](https://apps.apple.com/app/id1460243446).

Prizmo can be invoked from other apps to extract text (OCR), to generate PDF documents, to perform image cropping and cleanup, or to read text aloud. This is handled with a custom URL scheme. Apple Shortcuts app can be used to build an automation workflow that invokes Prizmo. Alternatively, any other app can also invoke this automation scheme by referring to the documentation below.

# Processing a Document

Prizmo document processing can be invoked from other apps either from provided input, or by shooting directly in Prizmo. This lets you accomplish various actions, like running the OCR to extract text, generating a PDF document (with or without the text), or cleaning up and cropping images. Here is an example of how this is achieved:

**prizmo://x-callback-url/processDocument?language=en&destination=pasteboard**

This will start Prizmo to take a picture and perform English OCR on it.

[Discover the API directly in Apple Shortcuts app](https://www.icloud.com/shortcuts/5b1a4bdae74a4d6dab27f0ba1580463a)

The following options are supported:

- **input** (optional): the input can be provided in multiple ways.
	- `camera` (default): will shoot directly in Prizmo.
	- `clipboard`: will import the image that has been copied to the clipboard.
	- `data`: will import the document provided as parameter (requires `imageData` or `pdfData` parameter).
- **imageData** (optional): Base64 encoded image data that is provided as part of the URL (base64 data stream must be URL encoded). Image format can be any format supported by iOS (see `imageFormat`).
- **imageFormat** (optional): format of `imageData`, expressed as a file extension (ex: 'jpeg'). The is a hint to help disambiguate actual format in some situations.
- **pdfData** (optional): Base64 encoded PDF data that is provided as part of the URL (base64 data stream must be URL encoded).
- **ocr** (optional): the OCR to use to recognize text. If no value is provided, Prizmo will use the one previously set by the user.
	- `none`: do not perform any text recognition. Can be used for instance to export cleaned-up images only.
	- `en`, `fr`, `de`, etc.: use on-device OCR by specifying the ISO 639-1 language code. The language must have been previously installed by the user. List of supported language codes for the on-device recognizer: `ar` (Arabic), `cs` (Czech), `da` (Danish), `de` (German), `el` (Greek), `en` (English), `es` (Spanish), `fi` (Finnish), `fr` (French),`he` (Hebrew), `hu` (Hungarian), `it` (Italian), `ja` (Japanese), `ko` (Korean), `nb` (Norwegian Bokmål), `nl` (Dutch), `pl` (Polish), `pt` (Portuguese), `ro` (Romanian), `ru` (Russian), `sk` (Slovak), `sr-Latn` (Serbian (Latin)), `sr` (Serbian (Cyrillic)), `sv` (Swedish), `tr` (Turkish), `uk` (Ukrainian), `zh-hans` (Simplified Chinese), `zh-hant` (Traditional Chinese).
	- `cloud`: use Cloud OCR for print
	- `cloud-handwriting`:  use Cloud OCR for handwriting
- **pageFormat** (optional): dimensions of the generated document when `output` is set to PDF. Use `A4` (default), `A5`, `LTR` (US Letter), `LGL` (US Legal), or `CRD` (Business Card).
- **cleanupMode** (optional): `none`, `black`, `gray`, or `color` (default).
- **destination** (optional): destination can be either `url` to send the output through the callback URL (calling app or another app), or `clipboard` to write the output in the clipboard. For `url` destination, see the *callback parameters* below.
- **callbackTextParameter**, **callbackPDFParameter**, **callbackImageParameter** (Optional): when destination is set to `url`, this option can be used to set the name of the parameter that receives the Base64 output (if these parameters are omitted, default value respectively are `text`, `pdfData`, `imageData`).
- **output** (optional): kind of generated output, `text` (default), `image`, or `PDF`. Multiple output options can be combined with +, eg. `text+PDF`. Works with both `url` destination (multiple output parameters), and `clipboard` (multiple representation).
- **createDocument** (optional): use `true` to create a persistent document in Prizmo, or `false` (default) to immediately discard the temporary document after processing.
- **detectPage** (optional): use `true` (default) to automatically detect page borders and crop it, or `false` to use input as is.
- **x-success** (optional): the URL to be invoked when processing succeeds (must be URL encoded). If `destination` is set to `url`, additional arguments are appended to this url to provide the output back to the receiver (see *callback parameters* above).
- **x-cancel** (optional): the URL to invoke when the user cancels the processing in Prizmo (must be URL encoded).
- **x-error** (optional): the URL to invoke when an error occurs during the processing in Prizmo (must be URL encoded).

### Deprecated Parameters
The following parameters from Prizmo 4 should be updated:
- **language**: deprecated, use `ocr` instead.
- **textParameterName**: deprecated, use `callbackTextParameter` instead.
- **pasteboardName**: not available anymore (iOS 10 removed support for persistent named pasteboard)
- **cropMode**: not available anymore, see `detectPage`.

# Reading Text

Prizmo Text Reader can be invoked from other apps to read any text aloud. Here is an example of how to achieve that:

**prizmo://x-callback-url/readText?voice=Ryan&text=Hello%20World**

This will read the provided text (Hello World) with the Ryan voice in Prizmo Text Reader. The following options are supported:

- **text** (optional): the text to read in Prizmo Text Reader. It must be URL encoded. If no text is provided, the action will just open the Prizmo Text Reader.
- **voice**: (optional) the voice name. Note that some voices share the same name in multiple languages. e.g. Daniel in French and Daniel in EN-UK. To resolve the ambiguity, use the `language` parameter.
- **language** (optional): ISO 639-1 language code or Language-Region code with BCP-47 format. e.g. "fr" or better "fr-FR".

# Remarks

The standard (and recommended) URL scheme is **prizmo://**. Alternatively, if you want to target a specific version of Prizmo, you can use **prizmo5://** or **prizmo4://** instead. Note that the APIs (command names and arguments) are different, and this document describes the Prizmo 5 API.
