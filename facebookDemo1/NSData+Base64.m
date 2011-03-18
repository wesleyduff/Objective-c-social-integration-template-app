#import "NSData+Base64.h"

static unsigned char base64EncodeLookup[65] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

#define xx 65

#define BINARY_UNIT_SIZE 3
#define BASE64_UNIT_SIZE 4

char *NewBase64Encode(const void *buffer, size_t length, bool separateLines, size_t *outputLength) {
	const unsigned char *inputBuffer = (const unsigned char *)buffer;
	
#define MAX_NUM_PADDING_CHARS 2
#define OUTPUT_LINE_LENGTH 64
#define INPUT_LINE_LENGTH ((OUTPUT_LINE_LENGTH / BASE64_UNIT_SIZE) * BINARY_UNIT_SIZE)
#define CR_LF_SIZE 2
	
	size_t outputBufferSize = ((length / BINARY_UNIT_SIZE) + ((length % BINARY_UNIT_SIZE) ? 1 : 0)) * BASE64_UNIT_SIZE;
	if (separateLines) {
		outputBufferSize += (outputBufferSize / OUTPUT_LINE_LENGTH) * CR_LF_SIZE;
	}
	
	outputBufferSize += 1;
	
	char *outputBuffer = (char *)malloc(outputBufferSize);
	if (!outputBuffer) {
		return NULL;
	}
	
	size_t i = 0;
	size_t j = 0;
	const size_t lineLength = separateLines ? INPUT_LINE_LENGTH : length;
	size_t lineEnd = lineLength;
	
	while (true) {
		if (lineEnd > length) {
			lineEnd = length;
		}
		
		for (; i + BINARY_UNIT_SIZE - 1 < lineEnd; i += BINARY_UNIT_SIZE) {
			outputBuffer[j++] = base64EncodeLookup[(inputBuffer[i] & 0xFC) >> 2];
			outputBuffer[j++] = base64EncodeLookup[((inputBuffer[i] & 0x03) << 4) | ((inputBuffer[i + 1] & 0xF0) >> 4)];
			outputBuffer[j++] = base64EncodeLookup[((inputBuffer[i + 1] & 0x0F) << 2) | ((inputBuffer[i + 2] & 0xC0) >> 6)];
			outputBuffer[j++] = base64EncodeLookup[inputBuffer[i + 2] & 0x3F];
		}
		
		if (lineEnd == length) {
			break;
		}
		
		outputBuffer[j++] = '\r';
		outputBuffer[j++] = '\n';
		lineEnd += lineLength;
	}
	
	if (i + 1 < length) {
		outputBuffer[j++] = base64EncodeLookup[(inputBuffer[i] & 0xFC) >> 2];
		outputBuffer[j++] = base64EncodeLookup[((inputBuffer[i] & 0x03) << 4)
											   | ((inputBuffer[i + 1] & 0xF0) >> 4)];
		outputBuffer[j++] = base64EncodeLookup[(inputBuffer[i + 1] & 0x0F) << 2];
		outputBuffer[j++] =	'=';
	} else if (i < length) {
		outputBuffer[j++] = base64EncodeLookup[(inputBuffer[i] & 0xFC) >> 2];
		outputBuffer[j++] = base64EncodeLookup[(inputBuffer[i] & 0x03) << 4];
		outputBuffer[j++] = '=';
		outputBuffer[j++] = '=';
	}
	outputBuffer[j] = 0;
	
	if (outputLength) {
		*outputLength = j;
	}
	return outputBuffer;
}

@implementation NSData (Base64)

- (NSString *)base64EncodedString {
	size_t outputLength;
	char *outputBuffer = NewBase64Encode([self bytes], [self length], true, &outputLength);
	NSString *result = [[[NSString alloc] initWithBytes:outputBuffer length:outputLength encoding:NSASCIIStringEncoding] autorelease];
	free(outputBuffer);
	return result;
}

@end
