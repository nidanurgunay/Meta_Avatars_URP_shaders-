// 3x3 Sobel kernel translated to texture-space
float ComputeTextureSobel(float2 uv, float widthScale)
{
    // Convert width to UV offset scale
    float2 off = float2(widthScale * 0.001, widthScale * 0.001);

    // Sample the 8 neighbors from the Meta Avatar's BaseMap
    float3 c_tl = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, uv + float2(-off.x,  off.y)).rgb;
    float3 c_t  = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, uv + float2(     0,  off.y)).rgb;
    float3 c_tr = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, uv + float2( off.x,  off.y)).rgb;
    float3 c_l  = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, uv + float2(-off.x,      0)).rgb;
    float3 c_r  = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, uv + float2( off.x,      0)).rgb;
    float3 c_bl = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, uv + float2(-off.x, -off.y)).rgb;
    float3 c_b  = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, uv + float2(     0, -off.y)).rgb;
    float3 c_br = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, uv + float2( off.x, -off.y)).rgb;

    float ltl = Luminance3(c_tl), lt = Luminance3(c_t), ltr = Luminance3(c_tr);
    float ll  = Luminance3(c_l),                         lr  = Luminance3(c_r);
    float lbl = Luminance3(c_bl), lb = Luminance3(c_b),  lbr = Luminance3(c_br);

    float gx = -ltl - 2.0*ll - lbl + ltr + 2.0*lr + lbr;
    float gy = -ltl - 2.0*lt - ltr + lbl + 2.0*lb + lbr;
    
    return sqrt(gx*gx + gy*gy);
}