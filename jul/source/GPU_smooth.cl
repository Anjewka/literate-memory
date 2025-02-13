void kernel main2(global uchar4* out, global const float* input, global const uchar3* colors)
{
    const int ix = get_global_id(0);
    const int iy = get_global_id(1);

    const float w = input[6]; const float h = input[7]; const float size = input[4];
    const float x0 = input[2]; const float y0 = input[3]; const float mi = input[5];
    const float re = input[0]; const float im = input[1];

    float2 z = (float2)((float)(ix - w / 2), (float)(iy - h / 2));
    z = z / size;
    z = z + (float2)(x0, y0);

    float i = 0;
    while(i < 255)
    {
        if(length(z) > 4.0) {break;}
        float tmp = z.x * z.x - z.y * z.y;
        z.y = z.x * z.y + z.x * z.y;
        z.x = tmp;
        z = z +(float2)(re, im);
        i += 0.5;
    }

    uchar r = i;
    uchar g = (255 - i);
    uchar b = 100 * length(z) < 255 ? 100 * length(z) : 255;

    if(r == g && g == b && b == 0) {r = g = b = 255;}


    if(ix >= w || iy >= h)
    {
        return;
    }

    out[(ix + iy * (int)(w))] = (uchar4)(r, g, b, 255);
}
