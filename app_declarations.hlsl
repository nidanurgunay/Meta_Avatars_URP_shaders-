// Declare the properties we added in the wrapper shader
float _ColorThreshold;
float4 _InnerLineColor;
float _InnerLineWidth;

// Extracted from your post-process shader
inline float Luminance3(float3 c)
{
    return dot(c, float3(0.2126, 0.7152, 0.0722));
}