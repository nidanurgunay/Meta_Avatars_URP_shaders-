#ifndef AVATAR_NPR_EDGE_EFFECT_INCLUDED
#define AVATAR_NPR_EDGE_EFFECT_INCLUDED

// Screen-space derivative inner-edge detection for Meta Avatars.
// Uses hardware ddx/ddy (atlas-safe: never crosses UV island boundaries).
// UnityCG.cginc is already included via Style2MetaAvatarCore.hlsl.

// Uniforms (declared here, exposed via shader Properties and OvrAvatarShaderConfiguration)
float4 _InnerLineColor;
float  _EdgeThreshold;
float  _EdgeMax;
float  _ColorEdgeWeight;
float  _InnerLineStrength;

float4 ApplyNPREdgeEffect(float4 color, float2 uv)
{
    float3 baseColor = tex2D(u_BaseColorSampler, uv).rgb;
    float2 normalXY  = tex2D(u_NormalSampler,    uv).xy;

    float3 bcDX = ddx(baseColor);
    float3 bcDY = ddy(baseColor);
    float2 nmDX = ddx(normalXY);
    float2 nmDY = ddy(normalXY);

    float colorEdge  = sqrt(dot(bcDX, bcDX) + dot(bcDY, bcDY));
    float normalEdge = sqrt(dot(nmDX, nmDX) + dot(nmDY, nmDY));

    float edgeMag = _ColorEdgeWeight * colorEdge + (1.0 - _ColorEdgeWeight) * normalEdge;

    float inBand = step(_EdgeThreshold, edgeMag) * step(edgeMag, _EdgeMax);
    color.rgb    = lerp(color.rgb, _InnerLineColor.rgb, inBand * _InnerLineStrength);

    return color;
}

#endif // AVATAR_NPR_EDGE_EFFECT_INCLUDED
