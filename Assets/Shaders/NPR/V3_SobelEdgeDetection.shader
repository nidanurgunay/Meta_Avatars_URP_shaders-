Shader "Custom/V3_SobelEdgeDetection"
{
    Properties
    {
        _MainTex          ("Albedo Texture",   2D)           = "white" {}
        _Color            ("Main Color",       Color)        = (1,1,1,1)
        _TextureIntensity ("Texture Intensity",Range(0,1))   = 1.0

        [Normal]
        _BumpMap  ("Normal Map",      2D)          = "bump" {}
        _BumpScale("Normal Intensity",Range(0,2))  = 1.0

        _ShadowStrength("Shadow Strength", Range(0,1))     = 0.5
        _AmbientColor  ("Ambient Color",   Color)          = (0.35,0.35,0.35,1)
        _RimColor      ("Rim Color",       Color)          = (0.408,0.408,0.408,1)
        _RimPower      ("Rim Power",       Range(0.5,10))  = 3.0

        [Header(Outer Outline)]
        _OuterOutlineWidth("Outline Width", Range(0,0.05)) = 0.003
        _OuterOutlineColor("Outline Color", Color)         = (0,0,0,1)

        [Header(Sobel Edge Detection)]
        [Toggle] _EnableInnerLines("Enable Inner Lines", Float) = 1
        _InnerLineColor   ("Edge Color",     Color)            = (0,0,0,1)
        _EdgeThreshold    ("Edge Threshold", Range(0.001,1.0)) = 0.15
        _EdgeSampleDist   ("Sample Distance",Range(0.1,10.0))  = 1.0
        _InnerLineStrength("Edge Strength",  Range(0,1))       = 1.0

        [Toggle] _EnableAlphaTest("Alpha Test (eyelashes)", Float) = 0
        _AlphaCutoff("Alpha Cutoff", Range(0,1)) = 0.07
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" "RenderPipeline"="UniversalPipeline" }

        // ── Outer outline (inverted hull) ────────────────────────────────────
        Pass
        {
            Name "OuterOutline"
            Tags { "Queue"="Geometry+1" }
            Cull Front
            ZWrite On
            ZTest Less

            HLSLPROGRAM
            #pragma vertex   vert_outline
            #pragma fragment frag_outline
            #pragma target   3.5
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "OvrVertexFetchBridge.hlsl"

            struct Attr_OL { float4 vertex : POSITION; float3 normal : NORMAL; float2 uv : TEXCOORD0; uint vertexID : SV_VertexID; };
            struct Vary_OL { float4 pos    : SV_POSITION; float2 uv : TEXCOORD0; };

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

        // ── Forward lit ──────────────────────────────────────────────────────
        Pass
        {
            Name "ForwardLit"
            Tags { "LightMode"="UniversalForward" }
            Cull Back
            ZWrite On
            ZTest LEqual

            HLSLPROGRAM
            #pragma vertex   vert
            #pragma fragment frag
            #pragma target   3.5
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE
            #pragma multi_compile _ _SHADOWS_SOFT

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "OvrVertexFetchBridge.hlsl"

            struct Attr
            {
                float4 vertex   : POSITION;
                float3 normal   : NORMAL;
                float4 tangent  : TANGENT;
                float2 uv       : TEXCOORD0;
                uint   vertexID : SV_VertexID;
            };

            struct Vary
            {
                float4 pos   : SV_POSITION;
                float2 uv    : TEXCOORD0;
                float3 posWS : TEXCOORD1;
                float3 nWS   : TEXCOORD2;
                float3 tWS   : TEXCOORD3;
                float3 bWS   : TEXCOORD4;
            };

            TEXTURE2D(_MainTex); SAMPLER(sampler_MainTex);
            TEXTURE2D(_BumpMap); SAMPLER(sampler_BumpMap);
            float4 _MainTex_ST;
            float4 _Color;
            float  _TextureIntensity;
            float  _BumpScale;
            float  _ShadowStrength;
            float4 _RimColor;
            float  _RimPower;
            float4 _AmbientColor;
            float  _EnableInnerLines;
            float4 _InnerLineColor;
            float  _EdgeThreshold;
            float  _EdgeSampleDist;
            float  _InnerLineStrength;
            float  _EnableAlphaTest;
            float  _AlphaCutoff;

            Vary vert(Attr v)
            {
                Vary o;
                OVR_FETCH_POS_NORM(v.vertex.xyz, v.normal, v.vertexID);
                VertexPositionInputs pi = GetVertexPositionInputs(v.vertex.xyz);
                VertexNormalInputs   ni = GetVertexNormalInputs(v.normal, v.tangent);
                o.pos   = pi.positionCS;
                o.uv    = TRANSFORM_TEX(v.uv, _MainTex);
                o.posWS = pi.positionWS;
                o.nWS   = ni.normalWS;
                o.tWS   = ni.tangentWS;
                o.bWS   = ni.bitangentWS;
                return o;
            }

            half4 frag(Vary IN) : SV_Target
            {
                half4 texColor = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv);
                if (_EnableAlphaTest > 0.5)
                    clip(texColor.a - _AlphaCutoff);

                half3 baseColor = lerp(_Color.rgb, texColor.rgb * _Color.rgb, _TextureIntensity);
                half4 albedo    = half4(baseColor, texColor.a * _Color.a);

                // ── Normal map → world-space normal ───────────────────────────
                half3 normalTS = UnpackNormalScale(
                    SAMPLE_TEXTURE2D(_BumpMap, sampler_BumpMap, IN.uv), _BumpScale);
                float3x3 TBN = float3x3(normalize(IN.tWS), normalize(IN.bWS), normalize(IN.nWS));
                float3 nWS   = normalize(mul(normalTS, TBN));

                float3 vWS = normalize(_WorldSpaceCameraPos - IN.posWS);

                // ── Smooth Lambert ────────────────────────────────────────────
                Light  mainLight = GetMainLight();
                float  NdotL     = saturate(dot(nWS, mainLight.direction));
                float  diffuse   = lerp(1.0 - _ShadowStrength, 1.0, NdotL);
                float3 lighting  = mainLight.color * diffuse + _AmbientColor.rgb;
                float  rim       = pow(1.0 - saturate(dot(vWS, nWS)), _RimPower);
                float3 shaded    = albedo.rgb * lighting + rim * _RimColor.rgb;

                // ── Sobel on albedo texture ───────────────────────────────────
                if (_EnableInnerLines > 0.5)
                {
                    float off = _EdgeSampleDist * 0.001;
                    float3 luma = float3(0.299, 0.587, 0.114);

                    float tl = dot(SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv + float2(-off,  off)).rgb, luma);
                    float t  = dot(SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv + float2(   0,  off)).rgb, luma);
                    float tr = dot(SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv + float2( off,  off)).rgb, luma);
                    float l  = dot(SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv + float2(-off,    0)).rgb, luma);
                    float r  = dot(SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv + float2( off,    0)).rgb, luma);
                    float bl = dot(SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv + float2(-off, -off)).rgb, luma);
                    float b  = dot(SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv + float2(   0, -off)).rgb, luma);
                    float br = dot(SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv + float2( off, -off)).rgb, luma);

                    float sobelX  = (tr + 2.0*r + br) - (tl + 2.0*l + bl);
                    float sobelY  = (tl + 2.0*t + tr) - (bl + 2.0*b + br);
                    float edgeMag = sqrt(sobelX * sobelX + sobelY * sobelY);

                    float edge = step(_EdgeThreshold, edgeMag) * _InnerLineStrength;
                    shaded = lerp(shaded, _InnerLineColor.rgb, edge);
                }

                return half4(shaded, albedo.a);
            }
            ENDHLSL
        }

        // ── DepthNormals — writes normal-map-perturbed normals to URP's
        //    _CameraNormalsTexture so post-process edge shaders (HierarchicalEdge,
        //    SobelEdgeDetection post-process) see bump-map detail, not just vertex normals.
        Pass
        {
            Name "DepthNormals"
            Tags { "LightMode" = "DepthNormals" }
            ZWrite On
            Cull Back

            HLSLPROGRAM
            #pragma vertex   DNVert
            #pragma fragment DNFrag
            #pragma target   3.5

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            TEXTURE2D(_BumpMap); SAMPLER(sampler_BumpMap);
            float4 _MainTex_ST;
            float  _BumpScale;

            struct DNAttr
            {
                float4 positionOS : POSITION;
                float3 normalOS   : NORMAL;
                float4 tangentOS  : TANGENT;
                float2 uv         : TEXCOORD0;
            };
            struct DNVary
            {
                float4 positionCS  : SV_POSITION;
                float2 uv          : TEXCOORD0;
                float3 normalWS    : TEXCOORD1;
                float3 tangentWS   : TEXCOORD2;
                float3 bitangentWS : TEXCOORD3;
            };

            DNVary DNVert(DNAttr v)
            {
                DNVary o;
                VertexPositionInputs pi = GetVertexPositionInputs(v.positionOS.xyz);
                VertexNormalInputs   ni = GetVertexNormalInputs(v.normalOS, v.tangentOS);
                o.positionCS  = pi.positionCS;
                o.uv          = TRANSFORM_TEX(v.uv, _MainTex);
                o.normalWS    = ni.normalWS;
                o.tangentWS   = ni.tangentWS;
                o.bitangentWS = ni.bitangentWS;
                return o;
            }

            float4 DNFrag(DNVary i) : SV_Target
            {
                half3 nTS    = UnpackNormalScale(
                    SAMPLE_TEXTURE2D(_BumpMap, sampler_BumpMap, i.uv), _BumpScale);
                float3x3 TBN = float3x3(normalize(i.tangentWS),
                                        normalize(i.bitangentWS),
                                        normalize(i.normalWS));
                float3 nWS   = normalize(mul(nTS, TBN));
                return half4(NormalizeNormalPerPixel(nWS), 0.0);
            }
            ENDHLSL
        }
    }
    CustomEditor "AvaturnPresetShaderGUI"
    FallBack "Hidden/Universal Render Pipeline/FallbackError"
}
