//
//  AGLkTextureLoader.h
//  OpenGLES_Ch3_1
//
//  Created by 张一鸣 on 2017/4/29.
//
//

#import <GLKit/GLKit.h>
@interface AGLkTextureInfo : NSObject

{
    @private
    GLuint name;
    GLenum target;
    GLuint width;
    GLuint height;
}

@property (readonly) GLuint name;
@property (readonly) GLenum target;
@property (readonly) GLuint width;
@property (readonly) GLuint height;



@end

@interface AGLkTextureLoader : NSObject


+ (AGLkTextureInfo *) textureWithCGImage:(CGImageRef)cgImage
                               options:(NSDictionary *)options
                                 error:(NSError **)outError;

@end
