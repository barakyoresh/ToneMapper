// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

NS_ASSUME_NONNULL_BEGIN

/// Protocol for factory class used to compile opengl shader objects given a specific type, file
/// extension and path.
@protocol TMGLShaderCompiler <NSObject>

/// Return pointer to compiled shader of type \c type from \c path.fileType or 0 if unsuccessful.
- (GLuint)createShaderType:(GLenum)shaderType FromPath:(NSString *)path
              withFileType:(NSString *)fileType;

@end

NS_ASSUME_NONNULL_END
