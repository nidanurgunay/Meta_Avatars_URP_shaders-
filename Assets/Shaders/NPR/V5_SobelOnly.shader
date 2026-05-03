// V5: Smooth Lambert lighting + Sobel inner edge detection (no toon quantization).
// Use alongside V1/V3 to isolate whether patch artifacts come from toon stepping
// or from the Sobel edge detection itself.

Shader "Custom/V5_SobelOnly"
{
    Properties
    {
        _Color ("Main Color", Color) = (1,1,1,1)
        _MainTex ("Texture", 2D) = "white" {}
        _TextureIntensity ("Texture Intensity", Range(0, 1)) = 1.0
        _ShadowStrength ("Shadow Strength", Range(0, 1)) = 0.7

        [Header(Outer Outline)]
        _OuterOutlineWidth ("Outer Outline Width", Range(0, 0.05)) = 0.003
        _OuterOutlineColor ("Outer Outline Color", Color) = (0,0,0,1)

        [Header(Rim Light)]
        _RimColor ("Rim Color", Color) = (0.408,0.408,0.408,1)
        _RimPower ("Rim Power", Range(0.5, 10.0)) = 3.0
        _AmbientColor ("Ambient Color", Color) = (0.35,0.35,0.35,1)

        [Header(Inner Sobel Edges)]
        [Toggle] _EnableInnerLines ("Enable Inner Lines", Float) = 1
        _InnerLineColor ("Inner Line Color", Color) = (0,0,0,1)
        _InnerLineThresholdSkin ("Skin Edge Threshold", Range(0.001, 1.0)) = 0.4
        _InnerLineThresholdClothes ("Clothes Edge Threshold", Range(0.001, 1.0)) = 0.15
        _InnerLineMax ("Seam Suppression Max", Range(0.1, 8.0)) = 2.0
        _SeamRangeLimit ("Seam Range Limit", Range(0.0, 1.0)) = 0.6
        _SkinSaturationCutoff ("Skin Saturation Cutoff", Range(0.0, 0.5)) = 0.25
        _InnerLineBlur ("Edge Sample Distance", Range(0.0, 10.0)) = 0.5
        _InnerLineStrength ("Inner Line Strength", Range(0, 1)) = 1.0
        _ThinEdgeThreshold ("Thin Edge Threshold", Range(0.0, 0.5)) = 0.03

        [Toggle] _EnableAlphaTest ("Enable Alpha Test", Float) = 0
        _AlphaCutoff ("Alpha Cutoff", Range(0, 1)) = 0.07
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" "RenderPipeline"="UniversalPipeline" }

        // -- Outer outline (inverted hull) -------------------------------------
        Pass
        {
            Name "OuterOutline"
            Tags { "Queue"="Geometry+1" }
            Cull Front
            ZWrite On
            ZTest Less

            HLSLPROGRAM
            #pragma vertex vert_outline
            #pragma fragment frag_outline
            #pragma target 3.5
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "OvrVertexFetchBridge.hlsl"

            struct Attr_OL { float4 vertex : POSITION; float3 normal : NORMAL; float2 uv : TEXCOORD0; uint vertexID : SV_VertexID; };
            struct Vary_OL { float4 pos : SV_POSITION; float2 uv : TEXCOORD0; };

            TEXTURE2D(_MainTex); SAMPLER(sampler_MainTex);
            float4 _MainTex_ST;
            float4 _OuterOutlineColor;
            float  _OuterOutlineWidth;
            float  _EnableAlphaTest;
            float  _AlphaCutoff;

            Vary_OL vert_outline(Attr_OL v)
            {
                Vary_OL o;
                OVR_FETCH_POS_NORM(v.vertex.xyz, v.normal, v.vertexID);
                VertexPositionInputs pi = GetVertexPositionInputs(v.vertex.xyz);
                VertexNormalInputs   ni = GetVertexNormalInputs(v.normal);
                float3 posWS = pi.positionWS + ni.normalWS * _OuterOutlineWidth;
                o.pos = TransformWorldToHClip(posWS);
                o.uv  = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            half4 frag_outline(Vary_OL i) : SV_Target
            {
                if (_EnableAlphaTest > 0.5)
                    clip(SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.uv).a - _AlphaCutoff);
                return _OuterOutlineColor;
            }
            ENDHLSL
        }

        // -- Forward lit: smooth Lambert + Sobel -------------------------------
        Pass
        {
            Name "ForwardLit"
            Tags { "LightMode"="UniversalForward" }
            Cull Back
            ZWrite On
            ZTest LEqual

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.5
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE
            #pragma multi_compile _ _SHADOWS_SOFT

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "OvrVertexFetchBridge.hlsl"

            struct Attr { float4 vertex : POSITION; float3 normal : NORMAL; float2 uv : TEXCOORD0; uint vertexID : SV_VertexID; };
            struct Vary { float4 pos : SV_POSITION; float2 uv : TEXCOORD0; float3 posWS : TEXCOORD1; float3 nWS : TEXCOORD2; };

            TEXTURE2D(_MainTex); SAMPLER(sampler_MainTex);
            float4 _MainTex_ST;
            float4 _Color;
            float  _TextureIntensity;
            float  _ShadowStrength;
            float4 _RimColor;
            float  _RimPower;
            float4 _AmbientColor;
            float  _EnableInnerLines;
            float4 _InnerLineColor;
            float  _InnerLineThresholdSkin;
            float  _InnerLineThresholdClothes;
            float  _InnerLineMax;
            float  _SeamRangeLimit;
            float  _SkinSaturationCutoff;
            float  _InnerLineBlur;
            float  _InnerLineStrength;
            float  _ThinEdgeThreshold;
            float  _EnableAlphaTest;
            float  _AlphaCutoff;

            Vary vert(Attr v)
            {
                Vary o;
                OVR_FETCH_POS_NORM(v.vertex.xyz, v.normal, v.vertexID);
                VertexPositionInputs pi = GetVertexPositionInputs(v.vertex.xyz);
                VertexNormalInputs   ni = GetVertexNormalInputs(v.normal);
                o.pos   = pi.positionCS;
                o.uv    = TRANSFORM_TEX(v.uv, _MainTex);
                o.posWS = pi.positionWS;
                o.nWS   = ni.normalWS;
                return o;
            }

            half4 frag(Vary IN) : SV_Target
            {
                half4 texColor = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv);
                if (_EnableAlphaTest > 0.5)
                    clip(texColor.a - _AlphaCutoff);

                half3 baseColor = lerp(_Color.rgb, texColor.rgb * _Color.rgb, _TextureIntensity);
                half4 albedo    = half4(baseColor, texColor.a * _Color.a);

                float3 nWS = normalize(IN.nWS);
                float3 vWS = normalize(_WorldSpaceCameraPos - IN.posWS);

                // ── Smooth Lambert (no toon stepping) ─────────────────────────
                Light mainLight = GetMainLight();
                float NdotL     = saturate(dot(nWS, mainLight.direction));
                // _ShadowStrength controls how dark the shadow side gets
                float diffuse   = lerp(1.0 - _ShadowStrength, 1.0, NdotL);
                float3 lighting = mainLight.color * diffuse + _AmbientColor.rgb;

                float rim    = pow(1.0 - saturate(dot(vWS, nWS)), _RimPower);
                float3 shaded = albedo.rgb * lighting + rim * _RimColor.rgb;

                // ── Sobel inner edge detection ────────────────────────────────
                if (_EnableInnerLines > 0.5)
                {
                    float offset = _InnerLineBlur * 0.001;
                    static const float3 luma = float3(0.299, 0.587, 0.114);

                    float tl = dot(SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv + float2(-offset,  offset)).rgb, luma);
                    float t  = dot(SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv + float2( 0,       offset)).rgb, luma);
                    float tr = dot(SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv + float2( offset,  offset)).rgb, luma);
                    float l  = dot(SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv + float2(-offset,  0     )).rgb, luma);
                    float r  = dot(SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv + float2( offset,  0     )).rgb, luma);
                    float bl = dot(SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv + float2(-offset, -offset)).rgb, luma);
                    float b  = dot(SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv + float2( 0,      -offset)).rgb, luma);
                    float br = dot(SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv + float2( offset, -offset)).rgb, luma);

                    float sobelX  = (tr + 2.0*r + br) - (tl + 2.0*l + bl);
                    float sobelY  = (tl + 2.0*t + tr) - (bl + 2.0*b + br);
                    float edgeMag = sqrt(sobelX*sobelX + sobelY*sobelY);

                    // ── Edge thinning via screen-space derivatives ────────────
                    // Inside a filled patch, edgeMag is uniformly high → small ddx/ddy.
                    // At the true boundary of a patch, edgeMag transitions fast → large ddx/ddy.
                    // Only keep pixels where edgeMag is actively changing = thin line.
                    float dex = abs(ddx(edgeMag));
                    float dey = abs(ddy(edgeMag));
                    float peakMask = step(_ThinEdgeThreshold, dex + dey);

                    // UV seam guard: suppress if neighbour luminance range is extreme
                    float lumaMin  = min(tl, min(t, min(tr, min(l, min(r, min(bl, min(b, br)))))));
                    float lumaMax  = max(tl, max(t, max(tr, max(l, max(r, max(bl, max(b, br)))))));
                    float seamMask = step(lumaMax - lumaMin, _SeamRangeLimit);

                    // Skin vs clothes via HSV saturation
                    float maxC = max(texColor.r, max(texColor.g, texColor.b));
                    float minC = min(texColor.r, min(texColor.g, texColor.b));
                    float sat  = (maxC > 0.001) ? (maxC - minC) / maxC : 0.0;
                    float skinBlend = 1.0 - smoothstep(0.0, _SkinSaturationCutoff, sat);
                    float threshold = lerp(_InnerLineThresholdClothes, _InnerLineThresholdSkin, skinBlend);

                    // Band-pass: [threshold … _InnerLineMax]
                    float inBand = step(threshold, edgeMag) * step(edgeMag, _InnerLineMax);
                    float edge   = inBand * seamMask * peakMask * _InnerLineStrength;
                    shaded = lerp(shaded, _InnerLineColor.rgb, edge);
                }

                return half4(shaded, albedo.a);
            }
            ENDHLSL
        }
    }
    FallBack "Hidden/Universal Render Pipeline/FallbackError"
}
