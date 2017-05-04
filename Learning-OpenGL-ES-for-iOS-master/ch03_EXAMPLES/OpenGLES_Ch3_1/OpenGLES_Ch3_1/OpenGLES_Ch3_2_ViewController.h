//
//  OpenGLES_Ch3_2_ViewController.h
//  OpenGLES_Ch3_1
//
//  Created by 张一鸣 on 2017/4/30.
//
//

#import <GLKit/GLKit.h>


@class AGLKVertexAttribArrayBuffer;

@interface OpenGLES_Ch3_2_ViewController : GLKViewController

@property (nonatomic, strong)GLKBaseEffect * baseEffect;

@property (nonatomic,strong) AGLKVertexAttribArrayBuffer * vertexBuffer;

@end
