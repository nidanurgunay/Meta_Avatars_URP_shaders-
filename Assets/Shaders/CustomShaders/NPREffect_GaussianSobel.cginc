#ifndef NPR_EFFECT_GAUSSIAN_SOBEL_INCLUDED
#define NPR_EFFECT_GAUSSIAN_SOBEL_INCLUDED

// Gaussian pre-filtered Sobel edge detection.
// Each of the 8 Sobel kernel positions is pre-blurred with a 9-tap Gaussian
// before the gradient is computed, reducing texture noise significantly.
// Ported from V2_NormalEdgeDetection.shader (SOBELFILTERMODE_MODERATE path).
// Requires ENABLE_NPR_EDGES + EFFECT_GAUSS_SOBEL keywords.

float4 _InnerLineColor;
float  _GSobelSampleDist;   // Sobel kernel UV offset  (0–10, × 0.001)
float  _GSobelBlurRadius;   // Per-sample Gaussian radius (0–5, × 0.001)
float  _GSobelThreshold;    // Edge threshold  (0–0.5)
float  _GSobelStrength;     // Overall edge opacity  (0–1)

// 9-tap Gaussian weighted luminance centred on `center`
float GaussianLuma(float2 center, float blurR)
{
    float3 L = float3(0.299, 0.587, 0.114);
    float  v = 0.0;
    v += dot(tex2D(u_BaseColorSampler, center).rgb,                                L) * 0.25;
    v += dot(tex2D(u_BaseColorSampler, center + float2( blurR,     0)).rgb,        L) * 0.125;
    v += dot(tex2D(u_BaseColorSampler, center + float2(-blurR,     0)).rgb,        L) * 0.125;
    v += dot(tex2D(u_BaseColorSampler, center + float2(    0,  blurR)).rgb,        L) * 0.125;
    v += dot(tex2D(u_BaseColorSampler, center + float2(    0, -blurR)).rgb,        L) * 0.125;
    v += dot(tex2D(u_BaseColorSampler, center + float2( blurR,  blurR)).rgb,       L) * 0.0625;
    v += dot(tex2D(u_BaseColorSampler, center + float2(-blurR,  blurR)).rgb,       L) * 0.0625;
    v += dot(tex2D(u_BaseColorSampler, center + float2( blurR, -blurR)).rgb,       L) * 0.0625;
    v += dot(tex2D(u_BaseColorSampler, center + float2(-blurR, -blurR)).rgb,       L) * 0.0625;
    return v;
}

float4 ApplyNPREffect(float4 color, float2 uv, half3 worldNormal, half3 worldViewDir)
{
    float off  = _GSobelSampleDist * 0.001;
    float blur = _GSobelBlurRadius * 0.001;

    float tl = GaussianLuma(uv + float2(-off,  off), blur);
    float t  = GaussianLuma(uv + float2(   0,  off), blur);
    float tr = GaussianLuma(uv + float2( off,  off), blur);
    float l  = GaussianLuma(uv + float2(-off,    0), blur);
    float r  = GaussianLuma(uv + float2( off,    0), blur);
    float bl = GaussianLuma(uv + float2(-off, -off), blur);
    float b  = GaussianLuma(uv + float2(   0, -off), blur);
    float br = GaussianLuma(uv + float2( off, -off), blur);

    float sobelX  = (tr + 2*r + br) - (tl + 2*l + bl);
    float sobelY  = (tl + 2*t + tr) - (bl + 2*b + br);
    float edgeMag = sqrt(sobelX*sobelX + sobelY*sobelY);

    // Two-pass smoothstep to sharpen the edge band (matches MODERATE mode from V2)
    float edge = smoothstep(_GSobelThreshold * 0.5, _GSobelThreshold * 1.5, edgeMag);
    edge = smoothstep(0.2, 0.8, edge);
    edge *= _GSobelStrength;

    color.rgb = lerp(color.rgb, _InnerLineColor.rgb, edge);
    return color;
}

#endif // NPR_EFFECT_GAUSSIAN_SOBEL_INCLUDED
