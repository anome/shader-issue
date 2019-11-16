uniform int mode;
uniform float speed;



void main()
{
    float factor;
    if( mode == 1 )
    {
        factor = 1.;
    }
    else if( mode == 2 )
    {
        factor = 2.;
    }
    else if( mode == 3 )
    {
        factor = 3.;
    }
    else if( mode == 4 )
    {
        factor = 4.;
    }
    else if( mode == 5 )
    {
        factor = 5.;
    }
    else if( mode == 6 )
    {
        factor = float(mode);
    }
    else
    {
        factor = speed/10.;
    }
    gl_FragColor = vec4(1.)*factor;
}
