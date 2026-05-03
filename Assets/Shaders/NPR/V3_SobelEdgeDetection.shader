// Version 2: Basic Sobel Edge Detection (NO PRE-BLUR)
// This version adds simple Sobel operator for texture edge detection
// NO Gaussian pre-filtering - this is the raw/unfiltered baseline
// Compare with V3+ to see the effect of pre-blur on noise suppression

Shader "Custom/V3_SobelEdgeDetection"
{
    Properties
    {
        [Header(Debug Mode)]
        [Toggle] _UseDebugDefaults ("Use Debug Defaults (overrides all settings below)", Float) = 0
        [Space(10)]
        
        _Color ("Main Color", Color) = (1,1,1,1)
        _MainTex ("Texture", 2D) = "white" {}
        _TextureIntensity ("Texture Intensity", Range(0, 1)) = 1.0

        _ToonSteps ("Shading Steps", Range(1, 10)) = 3
        _ToonThreshold ("Threshold", Range(0, 1)) = 0.5
        _ToonSmoothness ("Smoothness", Range(0.001, 0.1)) = 0.01
        _ShadowStrength ("Shadow Strength", Range(0, 1)) = 0.7

        _OuterOutlineWidth ("Outer Outline Width (world units)", Range(0,0.5)) = 0.005
        _OuterOutlineColor ("Outer Outline Color", Color) = (0,0,0,1)
        [Toggle] _UseOutlineDepthOffset ("Use Depth Offset (fix z-fighting)", Float) = 0
        _OutlineDepthBias ("Outline Depth Bias", Range(0, 5)) = 1.0

        [Toggle] _EnableInnerLines ("Enable Inner Lines", Float) = 1
        _InnerLineColor ("Inner Line Color", Color) = (0,0,0,1)
        [Space(4)]
        [Header(Edge Threshold by Surface Type)]
        _InnerLineThresholdSkin ("Skin Edge Threshold", Range(0.001, 1.0)) = 0.4
        _InnerLineThresholdClothes ("Clothes Edge Threshold", Range(0.001, 1.0)) = 0.15
        _InnerLineMax ("Seam Suppression Max", Range(0.1, 8.0)) = 2.0
        _SeamRangeLimit ("Seam Range Limit", Range(0.0, 1.0)) = 0.6
        _SkinSaturationCutoff ("Skin Saturation Cutoff", Range(0.0, 0.5)) = 0.25
        _InnerLineBlur ("Edge Sample Distance", Range(0.0, 10.0)) = 0.5
        _InnerLineStrength ("Inner Line Strength", Range(0, 1)) = 1.0

        _RimColor ("Rim Color", Color) = (0.408,0.408,0.408,1)
        _RimPower ("Rim Power", Range(0.1, 8.0)) = 3.0
        _AmbientColor ("Ambient Color", Color) = (0.35,0.35,0.35,1)
        
        // Transparency
        [Toggle] _EnableAlphaTest ("Enable Alpha Test (for eyelashes)", Float) = 0
        _AlphaCutoff ("Alpha Cutoff", Range(0, 1)) = 0.07
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" "RenderPipeline"="UniversalPipeline" }

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
            #pragma shader_feature_local _USEOUTLINEDEPTHOFFSET_ON
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "OvrVertexFetchBridge.hlsl"

            struct appdata_outline { float4 vertex : POSITION; float3 normal : NORMAL; float2 uv : TEXCOORD0; uint vertexID : SV_VertexID; };
            struct v2f_outline { float4 pos : SV_POSITION; float2 uv : TEXCOORD0; };

            TEXTURE2D(_MainTex); SAMPLER(sampler_MainTex);
            float4 _MainTex_ST;
            float _OuterOutlineWidth;
            float4 _OuterOutlineColor;
            float _EnableAlphaTest;
            float _AlphaCutoff;
            float _OutlineDepthBias;

            v2f_outline vert_outline(appdata_outline v)
            {
                v2f_outline o;
                OVR_FETCH_POS_NORM(v.vertex.xyz, v.normal, v.vertexID);
                VertexPositionInputs positionInputs = GetVertexPositionInputs(v.vertex.xyz);
                VertexNormalInputs normalInputs = GetVertexNormalInputs(v.normal);
                float3 posWS = positionInputs.positionWS + normalInputs.normalWS * _OuterOutlineWidth;
                o.pos = TransformWorldToHClip(posWS);
                
                // Apply depth bias in clip space if enabled
                #if _USEOUTLINEDEPTHOFFSET_ON
                    o.pos.z -= _OutlineDepthBias * 0.0001; // Push toward camera in depth
                #endif
                
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            half4 frag_outline(v2f_outline i) : SV_Target
            {
                if (_EnableAlphaTest > 0.5)
                {
                    half alpha = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.uv).a;
                    clip(alpha - _AlphaCutoff);
                }
                return _OuterOutlineColor;
            }
            ENDHLSL
        }

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
            #pragma multi_compile _ _ADDITIONAL_LIGHTS
            #pragma multi_compile _ _SHADOWS_SOFT

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "OvrVertexFetchBridge.hlsl"

            struct appdata { float4 vertex : POSITION; float3 normal : NORMAL; float2 uv : TEXCOORD0; uint vertexID : SV_VertexID; };
            struct v2f { float4 pos : SV_POSITION; float2 uv : TEXCOORD0; float3 posWS : TEXCOORD1; float3 nWS : TEXCOORD2; };

            TEXTURE2D(_MainTex);
            SAMPLER(sampler_MainTex);
            float4 _MainTex_ST;
            float4 _Color;
            float4 _OuterOutlineColor;
            float _TextureIntensity;
            float _ToonSteps;
            float _ToonThreshold;
            float _ToonSmoothness;
            float _ShadowStrength;
            float4 _RimColor;
            float _RimPower;
            float4 _AmbientColor;
            float _EnableInnerLines;
            float4 _InnerLineColor;
            float _InnerLineThresholdSkin;
            float _InnerLineThresholdClothes;
            float _InnerLineMax;
            float _SeamRangeLimit;
            float _SkinSaturationCutoff;
            float _InnerLineBlur;
            float _InnerLineStrength;
            float _EnableAlphaTest;
            float _AlphaCutoff;
            float _UseDebugDefaults;

            v2f vert(appdata v)
            {
                v2f o;
                OVR_FETCH_POS_NORM(v.vertex.xyz, v.normal, v.vertexID);
                VertexPositionInputs positionInputs = GetVertexPositionInputs(v.vertex.xyz);
                VertexNormalInputs normalInputs = GetVertexNormalInputs(v.normal);
                o.pos = positionInputs.positionCS;
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.posWS = positionInputs.positionWS;
                o.nWS = normalInputs.normalWS;
                return o;
            }

            half4 frag(v2f IN) : SV_Target
            {
                // Debug mode: override with default values
                if (_UseDebugDefaults > 0.5)
                {
                    _TextureIntensity = 1.0;
                    _ToonSteps = 5.0;
                    _ToonThreshold = 1.0;
                    _ToonSmoothness = 0.03;
                    _ShadowStrength = 0.6;
                    _RimPower = 5.0;
                    _OuterOutlineColor = float4(0, 0, 0, 1);
                    _InnerLineColor = float4(0, 0, 0, 1);
                }
                
                half4 texColor = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv);
                
                if (_EnableAlphaTest > 0.5)
                {
                    clip(texColor.a - _AlphaCutoff);
                }
                
                half3 baseColor = lerp(_Color.rgb, texColor.rgb * _Color.rgb, _TextureIntensity);
                half4 albedo = half4(baseColor, texColor.a * _Color.a);
                
                float3 nWS = normalize(IN.nWS);
                float3 vWS = normalize(_WorldSpaceCameraPos - IN.posWS);

                Light mainLight = GetMainLight();
                float NdotL = saturate(dot(nWS, mainLight.direction));

                float steps  = max(1.0, _ToonSteps);
                float scaled = NdotL * steps;
                float band   = floor(scaled);
                float frac   = scaled - band;
                float blend  = smoothstep(1.0 - _ToonSmoothness, 1.0, frac);
                float toon   = saturate((band + blend) / steps);
                toon = lerp(1.0 - _ShadowStrength, 1.0, toon);
                
                float3 lighting = mainLight.color * toon + _AmbientColor.rgb;
                float rim = pow(1.0 - saturate(dot(vWS, nWS)), _RimPower);
                float3 shaded = albedo.rgb * lighting + rim * _RimColor.rgb;

                // SOBEL EDGE DETECTION with skin-aware adaptive threshold
                if (_EnableInnerLines > 0.5)
                {
                    float offset = _InnerLineBlur * 0.001;

                    float tl = dot(SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv + float2(-offset,  offset)).rgb, float3(0.299, 0.587, 0.114));
                    float t  = dot(SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv + float2( 0,       offset)).rgb, float3(0.299, 0.587, 0.114));
                    float tr = dot(SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv + float2( offset,  offset)).rgb, float3(0.299, 0.587, 0.114));
                    float l  = dot(SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv + float2(-offset,  0     )).rgb, float3(0.299, 0.587, 0.114));
                    float r  = dot(SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv + float2( offset,  0     )).rgb, float3(0.299, 0.587, 0.114));
                    float bl = dot(SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv + float2(-offset, -offset)).rgb, float3(0.299, 0.587, 0.114));
                    float b  = dot(SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv + float2( 0,      -offset)).rgb, float3(0.299, 0.587, 0.114));
                    float br = dot(SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv + float2( offset, -offset)).rgb, float3(0.299, 0.587, 0.114));

                    float sobelX = (tr + 2.0 * r + br) - (tl + 2.0 * l + bl);
                    float sobelY = (tl + 2.0 * t + tr) - (bl + 2.0 * b + br);
                    float edgeMagnitude = sqrt(sobelX * sobelX + sobelY * sobelY);

                    // UV seam check: if the spread of luminance across all 8 neighbors
                    // is extreme, some neighbors belong to a different UV island.
                    // Suppress the edge in that case regardless of magnitude.
                    float lumaMin = min(tl, min(t, min(tr, min(l, min(r, min(bl, min(b, br)))))));
                    float lumaMax = max(tl, max(t, max(tr, max(l, max(r, max(bl, max(b, br)))))));
                    float lumaRange = lumaMax - lumaMin;
                    float seamMask = step(lumaRange, _SeamRangeLimit); // 1 = safe, 0 = seam

                    // Skin vs clothes classification via HSV saturation of the center pixel.
                    float maxC = max(texColor.r, max(texColor.g, texColor.b));
                    float minC = min(texColor.r, min(texColor.g, texColor.b));
                    float saturation = (maxC > 0.001) ? (maxC - minC) / maxC : 0.0;

                    // skinBlend: 1 = skin (low sat), 0 = clothes (high sat)
                    float skinBlend = 1.0 - smoothstep(0.0, _SkinSaturationCutoff, saturation);
                    float adaptiveThreshold = lerp(_InnerLineThresholdClothes, _InnerLineThresholdSkin, skinBlend);

                    // Band-pass: only show edges in [adaptiveThreshold, _InnerLineMax].
                    // Too-high magnitude = UV seam spike (second line of defense after seamMask).
                    float inBand = step(adaptiveThreshold, edgeMagnitude) * step(edgeMagnitude, _InnerLineMax);
                    float edge = inBand * seamMask * _InnerLineStrength;
                    shaded = lerp(shaded, _InnerLineColor.rgb, edge);
                }
                
                return half4(shaded, albedo.a);
            }
            ENDHLSL
        }
    }
    FallBack "Hidden/Universal Render Pipeline/FallbackError"
    CustomEditor "ToonShaderEditor"
}
