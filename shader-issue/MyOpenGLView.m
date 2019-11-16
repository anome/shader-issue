#import "MyOpenGLView.h"
#import <OpenGL/gl.h>
#import <OpenGL/gl3.h>



@implementation MyOpenGLView
{
    GLhandleARB shader;
}

- (GLhandleARB)loadShaderOfType:(GLenum)type named:(NSString *)name
{
    NSString *extension = (type == GL_VERTEX_SHADER_ARB ? @"vert" : @"frag");
    NSString  *path = [[NSBundle bundleForClass:[self class]] pathForResource:name ofType:extension];
    NSString *source = nil;
    if( path )
    {
        source = [NSString stringWithContentsOfFile:path usedEncoding:nil error:nil];
    }
    GLint shaderCompiled = 0;
    GLhandleARB shaderObject = NULL;
    if( source != nil )
    {
        const GLcharARB *glSource = [source cStringUsingEncoding:NSASCIIStringEncoding];
        shaderObject = glCreateShaderObjectARB(type);
        glShaderSourceARB(shaderObject, 1, &glSource, NULL);
        glCompileShaderARB(shaderObject);
        glGetObjectParameterivARB(shaderObject, GL_OBJECT_COMPILE_STATUS_ARB, &shaderCompiled);
        if( shaderCompiled == 0 )
        {
            glDeleteObjectARB(shaderObject);
            shaderObject = NULL;
        }
    }
    return shaderObject;
}

- (GLhandleARB)compileAndLinkShaderNamed:(NSString*)name
{
    [self.openGLContext makeCurrentContext];
    GLhandleARB shader = NULL;
    GLhandleARB vert = [self loadShaderOfType:GL_VERTEX_SHADER_ARB named:name];
    GLhandleARB frag = [self loadShaderOfType:GL_FRAGMENT_SHADER_ARB named:name];
    GLint programLinked = 0;
    if( frag && vert )
    {
        shader = glCreateProgramObjectARB();
        glAttachObjectARB(shader, vert);
        glAttachObjectARB(shader, frag);
        glLinkProgramARB(shader);
        glGetObjectParameterivARB(shader, GL_OBJECT_LINK_STATUS_ARB, &programLinked);
        if(programLinked == 0 )
        {
            glDeleteObjectARB(shader);
            shader = NULL;
        }
        else
        {
            glUseProgramObjectARB(shader);
            GLint samplerLoc = glGetUniformLocationARB(shader, "mode");
            if( samplerLoc >= 0 )
            {
                glUniform1i(samplerLoc, 1);
            }
            glUseProgram(0);
        }
    }
    if( frag ) glDeleteObjectARB(frag);
    if( vert ) glDeleteObjectARB(vert);
    return shader;
}

- (void)drawTriangle
{
    GLuint VertexArrayID;
    glGenVertexArrays(1, &VertexArrayID);
    glBindVertexArray(VertexArrayID);
    static const GLfloat g_vertex_buffer_data[] = {
        -1.0f, -1.0f, 0.0f,
        1.0f, -1.0f, 0.0f,
        0.0f,  1.0f, 0.0f,
    };
    GLuint vertexbuffer;
    glGenBuffers(1, &vertexbuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexbuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(g_vertex_buffer_data), g_vertex_buffer_data, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(0);
    glBindBuffer(GL_ARRAY_BUFFER, vertexbuffer);
    glVertexAttribPointer(
                          0,                  // attribute 0. No particular reason for 0, but must match the layout in the shader.
                          3,                  // size
                          GL_FLOAT,           // type
                          GL_FALSE,           // normalized?
                          0,                  // stride
                          (void*)0            // array buffer offset
                          );
    // Draw the triangle !
    glDrawArrays(GL_TRIANGLES, 0, 3); // Starting from vertex 0; 3 vertices total -> 1 triangle
    glDisableVertexAttribArray(0);

}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    glClearColor(0, 0, 0.5+0.5*(rand()%10)/10., 1);
    glClear(GL_COLOR_BUFFER_BIT);
    glUseProgramObjectARB(shader);
    [self drawTriangle];
    glFlush();
}

- (IBAction)useOKShader:(id)sender
{
    shader = [self compileAndLinkShaderNamed:@"ok"];
}

- (IBAction)useKOShader:(id)sender
{
    shader = [self compileAndLinkShaderNamed:@"ko"];
}

@end
