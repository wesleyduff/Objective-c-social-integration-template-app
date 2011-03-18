#import <Foundation/Foundation.h>

char *NewBase64Encode(const void *inputBuffer, size_t length, bool separateLines, size_t *outputLength);

@interface NSData (Base64)
- (NSString *)base64EncodedString;
@end
