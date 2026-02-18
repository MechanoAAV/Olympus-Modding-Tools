Shader "Shader Graphs/Lit"
{
    Properties
    {
        [NoScaleOffset]_MainTex("MainTex", 2D) = "white" {}
        _TexAnim("TexAnim", Vector, 2) = (0, 0, 0, 0)
        _GroundLuminance("GroundLuminance", Vector, 2) = (0, 1, 0, 0)
        _DitherAmount("DitherAmount", Range(0, 2)) = 1
        _Fade("Fade", Range(0, 1)) = 1
        _Mirror("Mirror", Float) = 0
        _MirrorMinMax("MirrorMinMax", Vector, 2) = (0, 0, 0, 0)
        _Emmission("Emmission", Float) = 0
        [NoScaleOffset]_Emm("Emm", 2D) = "black" {}
        [HideInInspector][HDR]_EmmissionColor("EmmissionColor", Color) = (0, 0, 0, 0)
        _Fresnel("Fresnel", Float) = 10
        _Specular("Specular", Float) = 10
        [ToggleUI]_Metallic("Metallic", Float) = 1
        [HideInInspector]_CastShadows("_CastShadows", Float) = 1
        [HideInInspector]_Surface("_Surface", Float) = 0
        [HideInInspector]_Blend("_Blend", Float) = 0
        [HideInInspector]_AlphaClip("_AlphaClip", Float) = 1
        [HideInInspector]_SrcBlend("_SrcBlend", Float) = 1
        [HideInInspector]_DstBlend("_DstBlend", Float) = 0
        [HideInInspector]_SrcBlendAlpha("_SrcBlendAlpha", Float) = 1
        [HideInInspector]_DstBlendAlpha("_DstBlendAlpha", Float) = 0
        [HideInInspector][ToggleUI]_ZWrite("_ZWrite", Float) = 1
        [HideInInspector]_ZWriteControl("_ZWriteControl", Float) = 0
        [HideInInspector]_ZTest("_ZTest", Float) = 4
        [HideInInspector]_Cull("_Cull", Float) = 0
        [HideInInspector]_AlphaToMask("_AlphaToMask", Float) = 1
        [HideInInspector]_QueueOffset("_QueueOffset", Float) = 0
        [HideInInspector]_QueueControl("_QueueControl", Float) = -1
        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Opaque"
            "UniversalMaterialType" = "Unlit"
            "Queue"="AlphaTest"
            "DisableBatching"="False"
            "ShaderGraphShader"="true"
            "ShaderGraphTargetId"="UniversalUnlitSubTarget"
        }
        Pass
        {
            Name "Universal Forward"
            Tags
            {
                // LightMode: <None>
            }
        
        // Render State
        Cull [_Cull]
        Blend [_SrcBlend] [_DstBlend], [_SrcBlendAlpha] [_DstBlendAlpha]
        ZTest [_ZTest]
        ZWrite [_ZWrite]
        AlphaToMask [_AlphaToMask]
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma instancing_options renderinglayer
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ USE_LEGACY_LIGHTMAPS
        #pragma multi_compile _ LIGHTMAP_BICUBIC_SAMPLING
        #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        #pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
        #pragma shader_feature_fragment _ _SURFACE_TYPE_TRANSPARENT
        #pragma shader_feature_local_fragment _ _ALPHAPREMULTIPLY_ON
        #pragma shader_feature_local_fragment _ _ALPHAMODULATE_ON
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        #pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
        #pragma multi_compile _ _FORWARD_PLUS
        
        
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_UNLIT
        #define _FOG_FRAGMENT 1
        #define UNLIT_DEFAULT_DECAL_BLENDING 1
        #define UNLIT_DEFAULT_SSAO 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Fog.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 texCoord0;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpaceNormal;
             float3 WorldSpaceViewDirection;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float4 uv0;
             float4 VertexColor;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
             float4 color : INTERP1;
             float3 positionWS : INTERP2;
             float3 normalWS : INTERP3;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            output.color.xyzw = input.color;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            output.color = input.color.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _MainTex_TexelSize;
        float4 _Emm_TexelSize;
        float _DitherAmount;
        float _Fade;
        float4 _EmmissionColor;
        float2 _TexAnim;
        float _Mirror;
        float2 _MirrorMinMax;
        float _Emmission;
        float2 _GroundLuminance;
        float _Metallic;
        float _Specular;
        float _Fresnel;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);
        TEXTURE2D(_Emm);
        SAMPLER(sampler_Emm);
        float _Shine;
        
        // Graph Includes
        #include_with_pragmas "Packages/com.cyanilux.shadergraph-customlighting/CustomLighting.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
        Out = A * B;
        }
        
        void Unity_Fraction_float(float In, out float Out)
        {
            Out = frac(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Minimum_float(float A, float B, out float Out)
        {
            Out = min(A, B);
        };
        
        void Unity_Round_float(float In, out float Out)
        {
            Out = round(In);
        }
        
        struct Bindings_LinearTime_f5a6b970195e54e43a218b75fe1986be_float
        {
        float3 TimeParameters;
        };
        
        void SG_LinearTime_f5a6b970195e54e43a218b75fe1986be_float(float _In, bool _In_90e9a0b0dc6344b8adaa3e14779fa2f9_IsConnected, float _Speed, Bindings_LinearTime_f5a6b970195e54e43a218b75fe1986be_float IN, out float Loop_1, out float Mirror_2, out float Switch_3)
        {
        float _Property_ccec6e839c994bbc9b8379fc232a4cb4_Out_0_Float = _In;
        bool _Property_ccec6e839c994bbc9b8379fc232a4cb4_Out_0_Float_IsConnected = _In_90e9a0b0dc6344b8adaa3e14779fa2f9_IsConnected;
        float _BranchOnInputConnection_f58c0353cb07438e8373957e727be54c_Out_3_Float = _Property_ccec6e839c994bbc9b8379fc232a4cb4_Out_0_Float_IsConnected ? _Property_ccec6e839c994bbc9b8379fc232a4cb4_Out_0_Float : IN.TimeParameters.x;
        float _Property_e45ce466129c4bee8f6fffff4f8e3234_Out_0_Float = _Speed;
        float _Multiply_4a6091052dbe4988b0d16523d257520e_Out_2_Float;
        Unity_Multiply_float_float(_BranchOnInputConnection_f58c0353cb07438e8373957e727be54c_Out_3_Float, _Property_e45ce466129c4bee8f6fffff4f8e3234_Out_0_Float, _Multiply_4a6091052dbe4988b0d16523d257520e_Out_2_Float);
        float _Fraction_42d232cf1270414ba1023756f71f0a2d_Out_1_Float;
        Unity_Fraction_float(_Multiply_4a6091052dbe4988b0d16523d257520e_Out_2_Float, _Fraction_42d232cf1270414ba1023756f71f0a2d_Out_1_Float);
        float _OneMinus_351c618a71f6456e85bc8c971f0066a9_Out_1_Float;
        Unity_OneMinus_float(_Fraction_42d232cf1270414ba1023756f71f0a2d_Out_1_Float, _OneMinus_351c618a71f6456e85bc8c971f0066a9_Out_1_Float);
        float _Minimum_782aeb76b2974423b93c59ba2d9ed533_Out_2_Float;
        Unity_Minimum_float(_Fraction_42d232cf1270414ba1023756f71f0a2d_Out_1_Float, _OneMinus_351c618a71f6456e85bc8c971f0066a9_Out_1_Float, _Minimum_782aeb76b2974423b93c59ba2d9ed533_Out_2_Float);
        float _Multiply_fd017f80dd2949fa8038202f7f5bb911_Out_2_Float;
        Unity_Multiply_float_float(_Minimum_782aeb76b2974423b93c59ba2d9ed533_Out_2_Float, 2, _Multiply_fd017f80dd2949fa8038202f7f5bb911_Out_2_Float);
        float _Round_60cd34698aad44c187a74884eca39139_Out_1_Float;
        Unity_Round_float(_Fraction_42d232cf1270414ba1023756f71f0a2d_Out_1_Float, _Round_60cd34698aad44c187a74884eca39139_Out_1_Float);
        Loop_1 = _Fraction_42d232cf1270414ba1023756f71f0a2d_Out_1_Float;
        Mirror_2 = _Multiply_fd017f80dd2949fa8038202f7f5bb911_Out_2_Float;
        Switch_3 = _Round_60cd34698aad44c187a74884eca39139_Out_1_Float;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        struct Bindings_AdditionalLights_f831f4743ad6aab44842def2f21aa4bd_float
        {
        float3 WorldSpaceNormal;
        float3 WorldSpaceViewDirection;
        float3 WorldSpacePosition;
        };
        
        void SG_AdditionalLights_f831f4743ad6aab44842def2f21aa4bd_float(float3 Vector3_209992F2, float Vector1_A38DA60E, float3 _Normal, bool _Normal_f4bf772aaae34d2f9780cff2a9b55bc8_IsConnected, half4 _Shadowmask, Bindings_AdditionalLights_f831f4743ad6aab44842def2f21aa4bd_float IN, out float3 Diffuse_1, out float3 Specular_2)
        {
        float3 _Property_1583269ec9a68c8aba285145649a2ac5_Out_0_Vector3 = Vector3_209992F2;
        float _Property_eb4601815121318284520396b2d3fae7_Out_0_Float = Vector1_A38DA60E;
        float3 _Property_adb1e03036394f8da6438aa4d7b50025_Out_0_Vector3 = _Normal;
        bool _Property_adb1e03036394f8da6438aa4d7b50025_Out_0_Vector3_IsConnected = _Normal_f4bf772aaae34d2f9780cff2a9b55bc8_IsConnected;
        float3 _BranchOnInputConnection_f086b1ffa0584bc9bda364f3e240bc4e_Out_3_Vector3 = _Property_adb1e03036394f8da6438aa4d7b50025_Out_0_Vector3_IsConnected ? _Property_adb1e03036394f8da6438aa4d7b50025_Out_0_Vector3 : IN.WorldSpaceNormal;
        half4 _Property_a2e212aebe7a4f57982c65d053a53703_Out_0_Vector4 = _Shadowmask;
        float3 _AdditionalLightsCustomFunction_438f6d908c13bc8b84c3074db8e60c56_Diffuse_5_Vector3;
        float3 _AdditionalLightsCustomFunction_438f6d908c13bc8b84c3074db8e60c56_Specular_6_Vector3;
        AdditionalLights_float(_Property_1583269ec9a68c8aba285145649a2ac5_Out_0_Vector3, _Property_eb4601815121318284520396b2d3fae7_Out_0_Float, IN.WorldSpacePosition, _BranchOnInputConnection_f086b1ffa0584bc9bda364f3e240bc4e_Out_3_Vector3, IN.WorldSpaceViewDirection, _Property_a2e212aebe7a4f57982c65d053a53703_Out_0_Vector4, _AdditionalLightsCustomFunction_438f6d908c13bc8b84c3074db8e60c56_Diffuse_5_Vector3, _AdditionalLightsCustomFunction_438f6d908c13bc8b84c3074db8e60c56_Specular_6_Vector3);
        Diffuse_1 = _AdditionalLightsCustomFunction_438f6d908c13bc8b84c3074db8e60c56_Diffuse_5_Vector3;
        Specular_2 = _AdditionalLightsCustomFunction_438f6d908c13bc8b84c3074db8e60c56_Specular_6_Vector3;
        }
        
        void Unity_Saturate_float3(float3 In, out float3 Out)
        {
            Out = saturate(In);
        }
        
        void Unity_FresnelEffect_float(float3 Normal, float3 ViewDir, float Power, out float Out)
        {
            Out = pow((1.0 - saturate(dot(normalize(Normal), ViewDir))), Power);
        }
        
        void Unity_Step_float(float Edge, float In, out float Out)
        {
            Out = step(Edge, In);
        }
        
        void Unity_DotProduct_float3(float3 A, float3 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void MainLightDirection_float(out float3 Direction)
        {
            #if SHADERGRAPH_PREVIEW
            Direction = half3(-0.5, -0.5, 0);
            #else
            Direction = SHADERGRAPH_MAIN_LIGHT_DIRECTION();
            #endif
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_SampleGradientV1_float(Gradient Gradient, float Time, out float4 Out)
        {
            // convert to OkLab if we need perceptual color space.
            float3 color = lerp(Gradient.colors[0].rgb, LinearToOklab(Gradient.colors[0].rgb), Gradient.type == 2);
        
            [unroll]
            for (int c = 1; c < Gradient.colorsLength; c++)
            {
                float colorPos = saturate((Time - Gradient.colors[c - 1].w) / (Gradient.colors[c].w - Gradient.colors[c - 1].w)) * step(c, Gradient.colorsLength - 1);
                float3 color2 = lerp(Gradient.colors[c].rgb, LinearToOklab(Gradient.colors[c].rgb), Gradient.type == 2);
                color = lerp(color, color2, lerp(colorPos, step(0.01, colorPos), Gradient.type % 2)); // grad.type == 1 is fixed, 0 and 2 are blends.
            }
            color = lerp(color, OklabToLinear(color), Gradient.type == 2);
        
        #ifdef UNITY_COLORSPACE_GAMMA
            color = LinearToSRGB(color);
        #endif
        
            float alpha = Gradient.alphas[0].x;
            [unroll]
            for (int a = 1; a < Gradient.alphasLength; a++)
            {
                float alphaPos = saturate((Time - Gradient.alphas[a - 1].y) / (Gradient.alphas[a].y - Gradient.alphas[a - 1].y)) * step(a, Gradient.alphasLength - 1);
                alpha = lerp(alpha, Gradient.alphas[a].x, lerp(alphaPos, step(0.01, alphaPos), Gradient.type % 2));
            }
        
            Out = float4(color, alpha);
        }
        
        void Unity_ViewVectorWorld_float(out float3 Out, float3 WorldSpacePosition)
        {
            Out = _WorldSpaceCameraPos.xyz - GetAbsolutePositionWS(WorldSpacePosition);
            if(!IsPerspectiveProjection())
            {
                Out = GetViewForwardDir() * dot(Out, GetViewForwardDir());
            }
        }
        
        void Unity_Reflection_float3(float3 In, float3 Normal, out float3 Out)
        {
            Out = reflect(In, Normal);
        }
        
        void Unity_Normalize_float3(float3 In, out float3 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_Blend_Multiply_float4(float4 Base, float4 Blend, out float4 Out, float Opacity)
        {
            Out = Base * Blend;
            Out = lerp(Base, Out, Opacity);
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Blend_Lighten_float4(float4 Base, float4 Blend, out float4 Out, float Opacity)
        {
            Out = max(Blend, Base);
            Out = lerp(Base, Out, Opacity);
        }
        
        void Unity_Saturate_float4(float4 In, out float4 Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Blend_Multiply_float3(float3 Base, float3 Blend, out float3 Out, float Opacity)
        {
            Out = Base * Blend;
            Out = lerp(Base, Out, Opacity);
        }
        
        void Unity_Fog_float(out float4 Color, out float Density, float3 Position)
        {
            SHADERGRAPH_FOG(Position, Color, Density);
        }
        
        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Dither_float(float In, float4 ScreenPosition, out float Out)
        {
            float2 uv = ScreenPosition.xy * _ScreenParams.xy;
            float DITHER_THRESHOLDS[16] =
            {
                1.0 / 17.0,  9.0 / 17.0,  3.0 / 17.0, 11.0 / 17.0,
                13.0 / 17.0,  5.0 / 17.0, 15.0 / 17.0,  7.0 / 17.0,
                4.0 / 17.0, 12.0 / 17.0,  2.0 / 17.0, 10.0 / 17.0,
                16.0 / 17.0,  8.0 / 17.0, 14.0 / 17.0,  6.0 / 17.0
            };
            uint index = (uint(uv.x) % 4) * 4 + uint(uv.y) % 4;
            Out = In - DITHER_THRESHOLDS[index];
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_c86def888f50468da53261517e29b15b_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Emm);
            float2 _Property_65d6841d202a428882e5ac3f296bb8bd_Out_0_Vector2 = _TexAnim;
            float2 _TilingAndOffset_69ea1c8ad59c456f87e25422ad5fc046_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), _Property_65d6841d202a428882e5ac3f296bb8bd_Out_0_Vector2, _TilingAndOffset_69ea1c8ad59c456f87e25422ad5fc046_Out_3_Vector2);
            float4 _SampleTexture2D_f228ab5ff8c34398ae216c2cdf5c5381_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_c86def888f50468da53261517e29b15b_Out_0_Texture2D.tex, _Property_c86def888f50468da53261517e29b15b_Out_0_Texture2D.samplerstate, _Property_c86def888f50468da53261517e29b15b_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_69ea1c8ad59c456f87e25422ad5fc046_Out_3_Vector2) );
            float _SampleTexture2D_f228ab5ff8c34398ae216c2cdf5c5381_R_4_Float = _SampleTexture2D_f228ab5ff8c34398ae216c2cdf5c5381_RGBA_0_Vector4.r;
            float _SampleTexture2D_f228ab5ff8c34398ae216c2cdf5c5381_G_5_Float = _SampleTexture2D_f228ab5ff8c34398ae216c2cdf5c5381_RGBA_0_Vector4.g;
            float _SampleTexture2D_f228ab5ff8c34398ae216c2cdf5c5381_B_6_Float = _SampleTexture2D_f228ab5ff8c34398ae216c2cdf5c5381_RGBA_0_Vector4.b;
            float _SampleTexture2D_f228ab5ff8c34398ae216c2cdf5c5381_A_7_Float = _SampleTexture2D_f228ab5ff8c34398ae216c2cdf5c5381_RGBA_0_Vector4.a;
            float _Property_6b2d45808f5240cabd9c66bb79a20cbb_Out_0_Float = _Emmission;
            float _Property_6308d0aa301a4294b75dd7b0b1f0438b_Out_0_Float = _Mirror;
            Bindings_LinearTime_f5a6b970195e54e43a218b75fe1986be_float _LinearTime_0c0d453673314091967795f2c08fb12a;
            _LinearTime_0c0d453673314091967795f2c08fb12a.TimeParameters = IN.TimeParameters;
            float _LinearTime_0c0d453673314091967795f2c08fb12a_Loop_1_Float;
            float _LinearTime_0c0d453673314091967795f2c08fb12a_Mirror_2_Float;
            float _LinearTime_0c0d453673314091967795f2c08fb12a_Switch_3_Float;
            SG_LinearTime_f5a6b970195e54e43a218b75fe1986be_float(float(0), false, _Property_6308d0aa301a4294b75dd7b0b1f0438b_Out_0_Float, _LinearTime_0c0d453673314091967795f2c08fb12a, _LinearTime_0c0d453673314091967795f2c08fb12a_Loop_1_Float, _LinearTime_0c0d453673314091967795f2c08fb12a_Mirror_2_Float, _LinearTime_0c0d453673314091967795f2c08fb12a_Switch_3_Float);
            float2 _Property_0e6aafc8348449cfb6bdd83cea8b7c8d_Out_0_Vector2 = _MirrorMinMax;
            float _Remap_95d761278d8d42eb9882d3949fc1ab64_Out_3_Float;
            Unity_Remap_float(_LinearTime_0c0d453673314091967795f2c08fb12a_Mirror_2_Float, float2 (0, 1), _Property_0e6aafc8348449cfb6bdd83cea8b7c8d_Out_0_Vector2, _Remap_95d761278d8d42eb9882d3949fc1ab64_Out_3_Float);
            float _Multiply_8c2375418d934e84bf18321234d0d558_Out_2_Float;
            Unity_Multiply_float_float(_Property_6b2d45808f5240cabd9c66bb79a20cbb_Out_0_Float, _Remap_95d761278d8d42eb9882d3949fc1ab64_Out_3_Float, _Multiply_8c2375418d934e84bf18321234d0d558_Out_2_Float);
            float4 _Multiply_4282f5f6c0f94fed90f977175e11484c_Out_2_Vector4;
            Unity_Multiply_float4_float4(_SampleTexture2D_f228ab5ff8c34398ae216c2cdf5c5381_RGBA_0_Vector4, (_Multiply_8c2375418d934e84bf18321234d0d558_Out_2_Float.xxxx), _Multiply_4282f5f6c0f94fed90f977175e11484c_Out_2_Vector4);
            float4 _Property_246858d0d55d42238bf1ec9c057d5744_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(_EmmissionColor) : _EmmissionColor;
            float4 _Add_56137f2997d74c158d81683bcc0a9be7_Out_2_Vector4;
            Unity_Add_float4(_Multiply_4282f5f6c0f94fed90f977175e11484c_Out_2_Vector4, _Property_246858d0d55d42238bf1ec9c057d5744_Out_0_Vector4, _Add_56137f2997d74c158d81683bcc0a9be7_Out_2_Vector4);
            Bindings_AdditionalLights_f831f4743ad6aab44842def2f21aa4bd_float _AdditionalLights_f7ba0a1a7bb0474c8ebf3175e74ab453;
            _AdditionalLights_f7ba0a1a7bb0474c8ebf3175e74ab453.WorldSpaceNormal = IN.WorldSpaceNormal;
            _AdditionalLights_f7ba0a1a7bb0474c8ebf3175e74ab453.WorldSpaceViewDirection = IN.WorldSpaceViewDirection;
            _AdditionalLights_f7ba0a1a7bb0474c8ebf3175e74ab453.WorldSpacePosition = IN.WorldSpacePosition;
            float3 _AdditionalLights_f7ba0a1a7bb0474c8ebf3175e74ab453_Diffuse_1_Vector3;
            float3 _AdditionalLights_f7ba0a1a7bb0474c8ebf3175e74ab453_Specular_2_Vector3;
            SG_AdditionalLights_f831f4743ad6aab44842def2f21aa4bd_float(float3 (0, 0, 0), float(0), float3 (0, 0, 0), false, half4 (1, 1, 1, 1), _AdditionalLights_f7ba0a1a7bb0474c8ebf3175e74ab453, _AdditionalLights_f7ba0a1a7bb0474c8ebf3175e74ab453_Diffuse_1_Vector3, _AdditionalLights_f7ba0a1a7bb0474c8ebf3175e74ab453_Specular_2_Vector3);
            float3 _Saturate_500b4986a1004f658ed406f4b136ae05_Out_1_Vector3;
            Unity_Saturate_float3(_AdditionalLights_f7ba0a1a7bb0474c8ebf3175e74ab453_Diffuse_1_Vector3, _Saturate_500b4986a1004f658ed406f4b136ae05_Out_1_Vector3);
            float _FresnelEffect_9d39d09f94064143856846232a443956_Out_3_Float;
            Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, float(2), _FresnelEffect_9d39d09f94064143856846232a443956_Out_3_Float);
            float _Step_8d8a255ef75049eab220d10acff0d516_Out_2_Float;
            Unity_Step_float(float(0.5), _FresnelEffect_9d39d09f94064143856846232a443956_Out_3_Float, _Step_8d8a255ef75049eab220d10acff0d516_Out_2_Float);
            float3 _Vector3_773e48da142642c49979a2c6c6772eea_Out_0_Vector3 = float3(float(0), float(1), float(0));
            float _DotProduct_a681e669c71e4371b9e3de7face5cb13_Out_2_Float;
            Unity_DotProduct_float3(_Vector3_773e48da142642c49979a2c6c6772eea_Out_0_Vector3, IN.WorldSpaceNormal, _DotProduct_a681e669c71e4371b9e3de7face5cb13_Out_2_Float);
            float _Multiply_e4ac6dfbd85249389c17e38e9fa2d0dc_Out_2_Float;
            Unity_Multiply_float_float(_Step_8d8a255ef75049eab220d10acff0d516_Out_2_Float, _DotProduct_a681e669c71e4371b9e3de7face5cb13_Out_2_Float, _Multiply_e4ac6dfbd85249389c17e38e9fa2d0dc_Out_2_Float);
            float _Swizzle_93b43cdeb64f4e5899b2cb51ddd10c3f_Out_1_Float = IN.VertexColor.y;
            float _Multiply_c5d0075d33cb495c91372c26d044f8b1_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_e4ac6dfbd85249389c17e38e9fa2d0dc_Out_2_Float, _Swizzle_93b43cdeb64f4e5899b2cb51ddd10c3f_Out_1_Float, _Multiply_c5d0075d33cb495c91372c26d044f8b1_Out_2_Float);
            float _Property_8e6ac123d25e425d8002501d3e1a0a70_Out_0_Float = _Shine;
            float _Multiply_99a19269e30e4d54ba01ce66f389ae77_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_c5d0075d33cb495c91372c26d044f8b1_Out_2_Float, _Property_8e6ac123d25e425d8002501d3e1a0a70_Out_0_Float, _Multiply_99a19269e30e4d54ba01ce66f389ae77_Out_2_Float);
            float _Saturate_ca8ea4b18af846989ff5ee776b6d5175_Out_1_Float;
            Unity_Saturate_float(_Multiply_99a19269e30e4d54ba01ce66f389ae77_Out_2_Float, _Saturate_ca8ea4b18af846989ff5ee776b6d5175_Out_1_Float);
            float3 _Add_b15089f0c3274152b37f3f600120bd37_Out_2_Vector3;
            Unity_Add_float3(_Saturate_500b4986a1004f658ed406f4b136ae05_Out_1_Vector3, (_Saturate_ca8ea4b18af846989ff5ee776b6d5175_Out_1_Float.xxx), _Add_b15089f0c3274152b37f3f600120bd37_Out_2_Vector3);
            float3 _Add_e2402a4838c74f4c9e4f2d5aee29a960_Out_2_Vector3;
            Unity_Add_float3((_Add_56137f2997d74c158d81683bcc0a9be7_Out_2_Vector4.xyz), _Add_b15089f0c3274152b37f3f600120bd37_Out_2_Vector3, _Add_e2402a4838c74f4c9e4f2d5aee29a960_Out_2_Vector3);
            float3 _Saturate_94c61a8f72fd4000abc09e9895627b0f_Out_1_Vector3;
            Unity_Saturate_float3(IN.WorldSpacePosition, _Saturate_94c61a8f72fd4000abc09e9895627b0f_Out_1_Vector3);
            float _Split_1d40da441edd4b06bc533cced3472604_R_1_Float = _Saturate_94c61a8f72fd4000abc09e9895627b0f_Out_1_Vector3[0];
            float _Split_1d40da441edd4b06bc533cced3472604_G_2_Float = _Saturate_94c61a8f72fd4000abc09e9895627b0f_Out_1_Vector3[1];
            float _Split_1d40da441edd4b06bc533cced3472604_B_3_Float = _Saturate_94c61a8f72fd4000abc09e9895627b0f_Out_1_Vector3[2];
            float _Split_1d40da441edd4b06bc533cced3472604_A_4_Float = 0;
            float2 _Property_1f9dc875a83c49e08aa354d6730a4c0b_Out_0_Vector2 = _GroundLuminance;
            float _Remap_528359c0024147e2b4646d39dc1b6dc4_Out_3_Float;
            Unity_Remap_float(_Split_1d40da441edd4b06bc533cced3472604_G_2_Float, float2 (0, 1), _Property_1f9dc875a83c49e08aa354d6730a4c0b_Out_0_Vector2, _Remap_528359c0024147e2b4646d39dc1b6dc4_Out_3_Float);
            float3 _MainLightDirection_7e9bab457bca463187a1bc5d49bfcfd3_Direction_0_Vector3;
            MainLightDirection_float(_MainLightDirection_7e9bab457bca463187a1bc5d49bfcfd3_Direction_0_Vector3);
            float _DotProduct_dfb9ca84ad6340d9890997ebbc7cd0f9_Out_2_Float;
            Unity_DotProduct_float3(IN.WorldSpaceNormal, _MainLightDirection_7e9bab457bca463187a1bc5d49bfcfd3_Direction_0_Vector3, _DotProduct_dfb9ca84ad6340d9890997ebbc7cd0f9_Out_2_Float);
            float _Saturate_56901fbb3768470d809e42210556c54f_Out_1_Float;
            Unity_Saturate_float(_DotProduct_dfb9ca84ad6340d9890997ebbc7cd0f9_Out_2_Float, _Saturate_56901fbb3768470d809e42210556c54f_Out_1_Float);
            float _OneMinus_f4e8accb4c804175b1df3b607c99314b_Out_1_Float;
            Unity_OneMinus_float(_Saturate_56901fbb3768470d809e42210556c54f_Out_1_Float, _OneMinus_f4e8accb4c804175b1df3b607c99314b_Out_1_Float);
            float _Add_c1cd98f83c52418aaf8acf3fefe6db27_Out_2_Float;
            Unity_Add_float(_OneMinus_f4e8accb4c804175b1df3b607c99314b_Out_1_Float, _SampleTexture2D_f228ab5ff8c34398ae216c2cdf5c5381_R_4_Float, _Add_c1cd98f83c52418aaf8acf3fefe6db27_Out_2_Float);
            float _Saturate_8673d8963a004997a1a326ecf975622c_Out_1_Float;
            Unity_Saturate_float(_Add_c1cd98f83c52418aaf8acf3fefe6db27_Out_2_Float, _Saturate_8673d8963a004997a1a326ecf975622c_Out_1_Float);
            float _Multiply_db40bccfff6245de97668657ea156aff_Out_2_Float;
            Unity_Multiply_float_float(_Remap_528359c0024147e2b4646d39dc1b6dc4_Out_3_Float, _Saturate_8673d8963a004997a1a326ecf975622c_Out_1_Float, _Multiply_db40bccfff6245de97668657ea156aff_Out_2_Float);
            float4 _SampleGradient_7134b5d3664d4b6bb82e5019d5c9a2ec_Out_2_Vector4;
            Unity_SampleGradientV1_float(NewGradient(0, 2, 2, float4(0.274028, 0.3241256, 0.8652291, 0),float4(1, 0.999249, 0.8881401, 1),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0), float2(1, 0),float2(1, 1),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0)), _Multiply_db40bccfff6245de97668657ea156aff_Out_2_Float, _SampleGradient_7134b5d3664d4b6bb82e5019d5c9a2ec_Out_2_Vector4);
            float _Property_74c1e8d12f27445d8eac46fbe6b87149_Out_0_Boolean = _Metallic;
            UnityTexture2D _Property_5e98a959b1984fb284818333ed194c15_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MainTex);
            float4 _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_5e98a959b1984fb284818333ed194c15_Out_0_Texture2D.tex, _Property_5e98a959b1984fb284818333ed194c15_Out_0_Texture2D.samplerstate, _Property_5e98a959b1984fb284818333ed194c15_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_69ea1c8ad59c456f87e25422ad5fc046_Out_3_Vector2) );
            float _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_R_4_Float = _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_RGBA_0_Vector4.r;
            float _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_G_5_Float = _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_RGBA_0_Vector4.g;
            float _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_B_6_Float = _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_RGBA_0_Vector4.b;
            float _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_A_7_Float = _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_RGBA_0_Vector4.a;
            float3 _ViewVector_eb016290adcb40848f61270bbd53aa26_Out_0_Vector3;
            Unity_ViewVectorWorld_float(_ViewVector_eb016290adcb40848f61270bbd53aa26_Out_0_Vector3, IN.WorldSpacePosition);
            float3 _Reflection_d17e4b1e5c9340e9bb7009776b6e83c4_Out_2_Vector3;
            Unity_Reflection_float3(_ViewVector_eb016290adcb40848f61270bbd53aa26_Out_0_Vector3, IN.WorldSpaceNormal, _Reflection_d17e4b1e5c9340e9bb7009776b6e83c4_Out_2_Vector3);
            float3 _Normalize_abebc2e64f6c4ab7bea5cf425fe4772c_Out_1_Vector3;
            Unity_Normalize_float3(_Reflection_d17e4b1e5c9340e9bb7009776b6e83c4_Out_2_Vector3, _Normalize_abebc2e64f6c4ab7bea5cf425fe4772c_Out_1_Vector3);
            float4 _SampleGradient_550c2767695448f89a06be50b562e027_Out_2_Vector4;
            Unity_SampleGradientV1_float(NewGradient(1, 4, 2, float4(0.1873314, 0.4300665, 1, 0.2159609),float4(0.1698112, 0.1698112, 0.1698112, 0.330251),float4(0, 0, 0, 0.5319295),float4(1, 1, 1, 0.7773098),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0), float2(1, 0),float2(1, 1),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0)), (_Normalize_abebc2e64f6c4ab7bea5cf425fe4772c_Out_1_Vector3).x, _SampleGradient_550c2767695448f89a06be50b562e027_Out_2_Vector4);
            float _Split_c9a6e724099c4d45a556534434f339e4_R_1_Float = IN.VertexColor[0];
            float _Split_c9a6e724099c4d45a556534434f339e4_G_2_Float = IN.VertexColor[1];
            float _Split_c9a6e724099c4d45a556534434f339e4_B_3_Float = IN.VertexColor[2];
            float _Split_c9a6e724099c4d45a556534434f339e4_A_4_Float = IN.VertexColor[3];
            float4 _Blend_e29b181cee344b3783abacc432bbd9eb_Out_2_Vector4;
            Unity_Blend_Multiply_float4(_SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_RGBA_0_Vector4, _SampleGradient_550c2767695448f89a06be50b562e027_Out_2_Vector4, _Blend_e29b181cee344b3783abacc432bbd9eb_Out_2_Vector4, _Split_c9a6e724099c4d45a556534434f339e4_R_1_Float);
            float4 _Branch_3a8072394c3744ec80c7b9d1d982c2e5_Out_3_Vector4;
            Unity_Branch_float4(_Property_74c1e8d12f27445d8eac46fbe6b87149_Out_0_Boolean, _Blend_e29b181cee344b3783abacc432bbd9eb_Out_2_Vector4, _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_RGBA_0_Vector4, _Branch_3a8072394c3744ec80c7b9d1d982c2e5_Out_3_Vector4);
            float3 _Reflection_22756abea90642b19aba6daae7644399_Out_2_Vector3;
            Unity_Reflection_float3(float3(0, -1, 0), IN.WorldSpaceNormal, _Reflection_22756abea90642b19aba6daae7644399_Out_2_Vector3);
            float _DotProduct_46718801ec8a4870ac7948422914faae_Out_2_Float;
            Unity_DotProduct_float3(_Reflection_22756abea90642b19aba6daae7644399_Out_2_Vector3, IN.WorldSpaceViewDirection, _DotProduct_46718801ec8a4870ac7948422914faae_Out_2_Float);
            float _Property_21e80ac221db49b08eb93df484c0cb6c_Out_0_Float = _Specular;
            float _Power_1b487f1b19b04a9abab40af30d60d5af_Out_2_Float;
            Unity_Power_float(_DotProduct_46718801ec8a4870ac7948422914faae_Out_2_Float, _Property_21e80ac221db49b08eb93df484c0cb6c_Out_0_Float, _Power_1b487f1b19b04a9abab40af30d60d5af_Out_2_Float);
            float4 _SampleGradient_a7e23dfff8364ed2b7134c7218ed85c9_Out_2_Vector4;
            Unity_SampleGradientV1_float(NewGradient(0, 2, 2, float4(0, 0, 0, 0.6147097),float4(1, 1, 1, 0.885298),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0), float2(1, 0),float2(1, 1),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0)), _Power_1b487f1b19b04a9abab40af30d60d5af_Out_2_Float, _SampleGradient_a7e23dfff8364ed2b7134c7218ed85c9_Out_2_Vector4);
            float _Property_f1fa91262d794f96a966b81219fa28bc_Out_0_Float = _Fresnel;
            float _FresnelEffect_23a5335bf7634bd89dc14235dcdcf5cb_Out_3_Float;
            Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, _Property_f1fa91262d794f96a966b81219fa28bc_Out_0_Float, _FresnelEffect_23a5335bf7634bd89dc14235dcdcf5cb_Out_3_Float);
            float4 _Add_e396075f878a4d31ad51a91692d20b5e_Out_2_Vector4;
            Unity_Add_float4(_SampleGradient_a7e23dfff8364ed2b7134c7218ed85c9_Out_2_Vector4, (_FresnelEffect_23a5335bf7634bd89dc14235dcdcf5cb_Out_3_Float.xxxx), _Add_e396075f878a4d31ad51a91692d20b5e_Out_2_Vector4);
            float4 _Blend_a90d26108d0b490cab2116099bd912c9_Out_2_Vector4;
            Unity_Blend_Lighten_float4(_Branch_3a8072394c3744ec80c7b9d1d982c2e5_Out_3_Vector4, _Add_e396075f878a4d31ad51a91692d20b5e_Out_2_Vector4, _Blend_a90d26108d0b490cab2116099bd912c9_Out_2_Vector4, _Split_c9a6e724099c4d45a556534434f339e4_R_1_Float);
            float4 _Multiply_0f9b35d0e5a54476914e105943b27721_Out_2_Vector4;
            Unity_Multiply_float4_float4(_SampleGradient_7134b5d3664d4b6bb82e5019d5c9a2ec_Out_2_Vector4, _Blend_a90d26108d0b490cab2116099bd912c9_Out_2_Vector4, _Multiply_0f9b35d0e5a54476914e105943b27721_Out_2_Vector4);
            float4 _Saturate_25da087dd4294611b7bab8afd25c37a1_Out_1_Vector4;
            Unity_Saturate_float4(_Multiply_0f9b35d0e5a54476914e105943b27721_Out_2_Vector4, _Saturate_25da087dd4294611b7bab8afd25c37a1_Out_1_Vector4);
            float3 _Blend_1a96f82fa5be4657b7b755ec106468b4_Out_2_Vector3;
            Unity_Blend_Multiply_float3((_Saturate_25da087dd4294611b7bab8afd25c37a1_Out_1_Vector4.xyz), SHADERGRAPH_AMBIENT_SKY, _Blend_1a96f82fa5be4657b7b755ec106468b4_Out_2_Vector3, float(0.5));
            float3 _Add_75281d4ee5c04490b4e5596f8662e75a_Out_2_Vector3;
            Unity_Add_float3(_Add_e2402a4838c74f4c9e4f2d5aee29a960_Out_2_Vector3, _Blend_1a96f82fa5be4657b7b755ec106468b4_Out_2_Vector3, _Add_75281d4ee5c04490b4e5596f8662e75a_Out_2_Vector3);
            float4 _Fog_77cc8ad60dcb4798b7df7ec80cbed738_Color_0_Vector4;
            float _Fog_77cc8ad60dcb4798b7df7ec80cbed738_Density_1_Float;
            Unity_Fog_float(_Fog_77cc8ad60dcb4798b7df7ec80cbed738_Color_0_Vector4, _Fog_77cc8ad60dcb4798b7df7ec80cbed738_Density_1_Float, IN.ObjectSpacePosition);
            float3 _Lerp_b061b84311ab4e63a397f5b9e998a51f_Out_3_Vector3;
            Unity_Lerp_float3(_Add_75281d4ee5c04490b4e5596f8662e75a_Out_2_Vector3, (_Fog_77cc8ad60dcb4798b7df7ec80cbed738_Color_0_Vector4.xyz), (_Fog_77cc8ad60dcb4798b7df7ec80cbed738_Density_1_Float.xxx), _Lerp_b061b84311ab4e63a397f5b9e998a51f_Out_3_Vector3);
            float _Property_deeb68840c5141fa91e21ba643f3935d_Out_0_Float = _Fade;
            float _Multiply_236f6a1504d74e0eb5377f5d2cdbef74_Out_2_Float;
            Unity_Multiply_float_float(_Property_deeb68840c5141fa91e21ba643f3935d_Out_0_Float, _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_A_7_Float, _Multiply_236f6a1504d74e0eb5377f5d2cdbef74_Out_2_Float);
            float _Multiply_5fd8e20adcbe4b2aa10033e56ab81220_Out_2_Float;
            Unity_Multiply_float_float(_Split_c9a6e724099c4d45a556534434f339e4_A_4_Float, _Multiply_236f6a1504d74e0eb5377f5d2cdbef74_Out_2_Float, _Multiply_5fd8e20adcbe4b2aa10033e56ab81220_Out_2_Float);
            float _Property_2c28039c7f7941d48354c40c8c742248_Out_0_Float = _DitherAmount;
            float _Dither_4e2caf6e1eda413ca1c7cde0d8bee9b1_Out_2_Float;
            Unity_Dither_float(_Property_2c28039c7f7941d48354c40c8c742248_Out_0_Float, float4(IN.NDCPosition.xy, 0, 0), _Dither_4e2caf6e1eda413ca1c7cde0d8bee9b1_Out_2_Float);
            surface.BaseColor = _Lerp_b061b84311ab4e63a397f5b9e998a51f_Out_3_Vector3;
            surface.Alpha = _Multiply_5fd8e20adcbe4b2aa10033e56ab81220_Out_2_Float;
            surface.AlphaClipThreshold = _Dither_4e2caf6e1eda413ca1c7cde0d8bee9b1_Out_2_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        
        
            output.WorldSpaceViewDirection = GetWorldSpaceNormalizeViewDir(input.positionWS);
            output.WorldSpacePosition = input.positionWS;
            output.ObjectSpacePosition = TransformWorldToObject(input.positionWS);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.uv0 = input.texCoord0;
            output.VertexColor = input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/UnlitPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "DepthOnly"
            Tags
            {
                "LightMode" = "DepthOnly"
            }
        
        // Render State
        Cull [_Cull]
        ZTest LEqual
        ZWrite On
        ColorMask R
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float2 NDCPosition;
             float2 PixelPosition;
             float4 uv0;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
             float4 color : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            output.color.xyzw = input.color;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            output.color = input.color.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _MainTex_TexelSize;
        float4 _Emm_TexelSize;
        float _DitherAmount;
        float _Fade;
        float4 _EmmissionColor;
        float2 _TexAnim;
        float _Mirror;
        float2 _MirrorMinMax;
        float _Emmission;
        float2 _GroundLuminance;
        float _Metallic;
        float _Specular;
        float _Fresnel;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);
        TEXTURE2D(_Emm);
        SAMPLER(sampler_Emm);
        float _Shine;
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Dither_float(float In, float4 ScreenPosition, out float Out)
        {
            float2 uv = ScreenPosition.xy * _ScreenParams.xy;
            float DITHER_THRESHOLDS[16] =
            {
                1.0 / 17.0,  9.0 / 17.0,  3.0 / 17.0, 11.0 / 17.0,
                13.0 / 17.0,  5.0 / 17.0, 15.0 / 17.0,  7.0 / 17.0,
                4.0 / 17.0, 12.0 / 17.0,  2.0 / 17.0, 10.0 / 17.0,
                16.0 / 17.0,  8.0 / 17.0, 14.0 / 17.0,  6.0 / 17.0
            };
            uint index = (uint(uv.x) % 4) * 4 + uint(uv.y) % 4;
            Out = In - DITHER_THRESHOLDS[index];
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _Split_c9a6e724099c4d45a556534434f339e4_R_1_Float = IN.VertexColor[0];
            float _Split_c9a6e724099c4d45a556534434f339e4_G_2_Float = IN.VertexColor[1];
            float _Split_c9a6e724099c4d45a556534434f339e4_B_3_Float = IN.VertexColor[2];
            float _Split_c9a6e724099c4d45a556534434f339e4_A_4_Float = IN.VertexColor[3];
            float _Property_deeb68840c5141fa91e21ba643f3935d_Out_0_Float = _Fade;
            UnityTexture2D _Property_5e98a959b1984fb284818333ed194c15_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MainTex);
            float2 _Property_65d6841d202a428882e5ac3f296bb8bd_Out_0_Vector2 = _TexAnim;
            float2 _TilingAndOffset_69ea1c8ad59c456f87e25422ad5fc046_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), _Property_65d6841d202a428882e5ac3f296bb8bd_Out_0_Vector2, _TilingAndOffset_69ea1c8ad59c456f87e25422ad5fc046_Out_3_Vector2);
            float4 _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_5e98a959b1984fb284818333ed194c15_Out_0_Texture2D.tex, _Property_5e98a959b1984fb284818333ed194c15_Out_0_Texture2D.samplerstate, _Property_5e98a959b1984fb284818333ed194c15_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_69ea1c8ad59c456f87e25422ad5fc046_Out_3_Vector2) );
            float _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_R_4_Float = _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_RGBA_0_Vector4.r;
            float _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_G_5_Float = _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_RGBA_0_Vector4.g;
            float _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_B_6_Float = _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_RGBA_0_Vector4.b;
            float _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_A_7_Float = _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_RGBA_0_Vector4.a;
            float _Multiply_236f6a1504d74e0eb5377f5d2cdbef74_Out_2_Float;
            Unity_Multiply_float_float(_Property_deeb68840c5141fa91e21ba643f3935d_Out_0_Float, _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_A_7_Float, _Multiply_236f6a1504d74e0eb5377f5d2cdbef74_Out_2_Float);
            float _Multiply_5fd8e20adcbe4b2aa10033e56ab81220_Out_2_Float;
            Unity_Multiply_float_float(_Split_c9a6e724099c4d45a556534434f339e4_A_4_Float, _Multiply_236f6a1504d74e0eb5377f5d2cdbef74_Out_2_Float, _Multiply_5fd8e20adcbe4b2aa10033e56ab81220_Out_2_Float);
            float _Property_2c28039c7f7941d48354c40c8c742248_Out_0_Float = _DitherAmount;
            float _Dither_4e2caf6e1eda413ca1c7cde0d8bee9b1_Out_2_Float;
            Unity_Dither_float(_Property_2c28039c7f7941d48354c40c8c742248_Out_0_Float, float4(IN.NDCPosition.xy, 0, 0), _Dither_4e2caf6e1eda413ca1c7cde0d8bee9b1_Out_2_Float);
            surface.Alpha = _Multiply_5fd8e20adcbe4b2aa10033e56ab81220_Out_2_Float;
            surface.AlphaClipThreshold = _Dither_4e2caf6e1eda413ca1c7cde0d8bee9b1_Out_2_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.uv0 = input.texCoord0;
            output.VertexColor = input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "MotionVectors"
            Tags
            {
                "LightMode" = "MotionVectors"
            }
        
        // Render State
        Cull [_Cull]
        ZTest LEqual
        ZWrite On
        ColorMask RG
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 3.5
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_COLOR
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_MOTION_VECTORS
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float4 uv0 : TEXCOORD0;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float2 NDCPosition;
             float2 PixelPosition;
             float4 uv0;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
             float4 color : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            output.color.xyzw = input.color;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            output.color = input.color.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _MainTex_TexelSize;
        float4 _Emm_TexelSize;
        float _DitherAmount;
        float _Fade;
        float4 _EmmissionColor;
        float2 _TexAnim;
        float _Mirror;
        float2 _MirrorMinMax;
        float _Emmission;
        float2 _GroundLuminance;
        float _Metallic;
        float _Specular;
        float _Fresnel;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);
        TEXTURE2D(_Emm);
        SAMPLER(sampler_Emm);
        float _Shine;
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Dither_float(float In, float4 ScreenPosition, out float Out)
        {
            float2 uv = ScreenPosition.xy * _ScreenParams.xy;
            float DITHER_THRESHOLDS[16] =
            {
                1.0 / 17.0,  9.0 / 17.0,  3.0 / 17.0, 11.0 / 17.0,
                13.0 / 17.0,  5.0 / 17.0, 15.0 / 17.0,  7.0 / 17.0,
                4.0 / 17.0, 12.0 / 17.0,  2.0 / 17.0, 10.0 / 17.0,
                16.0 / 17.0,  8.0 / 17.0, 14.0 / 17.0,  6.0 / 17.0
            };
            uint index = (uint(uv.x) % 4) * 4 + uint(uv.y) % 4;
            Out = In - DITHER_THRESHOLDS[index];
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _Split_c9a6e724099c4d45a556534434f339e4_R_1_Float = IN.VertexColor[0];
            float _Split_c9a6e724099c4d45a556534434f339e4_G_2_Float = IN.VertexColor[1];
            float _Split_c9a6e724099c4d45a556534434f339e4_B_3_Float = IN.VertexColor[2];
            float _Split_c9a6e724099c4d45a556534434f339e4_A_4_Float = IN.VertexColor[3];
            float _Property_deeb68840c5141fa91e21ba643f3935d_Out_0_Float = _Fade;
            UnityTexture2D _Property_5e98a959b1984fb284818333ed194c15_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MainTex);
            float2 _Property_65d6841d202a428882e5ac3f296bb8bd_Out_0_Vector2 = _TexAnim;
            float2 _TilingAndOffset_69ea1c8ad59c456f87e25422ad5fc046_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), _Property_65d6841d202a428882e5ac3f296bb8bd_Out_0_Vector2, _TilingAndOffset_69ea1c8ad59c456f87e25422ad5fc046_Out_3_Vector2);
            float4 _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_5e98a959b1984fb284818333ed194c15_Out_0_Texture2D.tex, _Property_5e98a959b1984fb284818333ed194c15_Out_0_Texture2D.samplerstate, _Property_5e98a959b1984fb284818333ed194c15_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_69ea1c8ad59c456f87e25422ad5fc046_Out_3_Vector2) );
            float _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_R_4_Float = _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_RGBA_0_Vector4.r;
            float _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_G_5_Float = _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_RGBA_0_Vector4.g;
            float _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_B_6_Float = _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_RGBA_0_Vector4.b;
            float _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_A_7_Float = _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_RGBA_0_Vector4.a;
            float _Multiply_236f6a1504d74e0eb5377f5d2cdbef74_Out_2_Float;
            Unity_Multiply_float_float(_Property_deeb68840c5141fa91e21ba643f3935d_Out_0_Float, _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_A_7_Float, _Multiply_236f6a1504d74e0eb5377f5d2cdbef74_Out_2_Float);
            float _Multiply_5fd8e20adcbe4b2aa10033e56ab81220_Out_2_Float;
            Unity_Multiply_float_float(_Split_c9a6e724099c4d45a556534434f339e4_A_4_Float, _Multiply_236f6a1504d74e0eb5377f5d2cdbef74_Out_2_Float, _Multiply_5fd8e20adcbe4b2aa10033e56ab81220_Out_2_Float);
            float _Property_2c28039c7f7941d48354c40c8c742248_Out_0_Float = _DitherAmount;
            float _Dither_4e2caf6e1eda413ca1c7cde0d8bee9b1_Out_2_Float;
            Unity_Dither_float(_Property_2c28039c7f7941d48354c40c8c742248_Out_0_Float, float4(IN.NDCPosition.xy, 0, 0), _Dither_4e2caf6e1eda413ca1c7cde0d8bee9b1_Out_2_Float);
            surface.Alpha = _Multiply_5fd8e20adcbe4b2aa10033e56ab81220_Out_2_Float;
            surface.AlphaClipThreshold = _Dither_4e2caf6e1eda413ca1c7cde0d8bee9b1_Out_2_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpacePosition =                        input.positionOS;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.uv0 = input.texCoord0;
            output.VertexColor = input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/MotionVectorPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "DepthNormalsOnly"
            Tags
            {
                "LightMode" = "DepthNormalsOnly"
            }
        
        // Render State
        Cull [_Cull]
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT
        #pragma shader_feature_fragment _ _SURFACE_TYPE_TRANSPARENT
        #pragma shader_feature_local_fragment _ _ALPHAPREMULTIPLY_ON
        #pragma shader_feature_local_fragment _ _ALPHAMODULATE_ON
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHNORMALSONLY
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 normalWS;
             float4 texCoord0;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float2 NDCPosition;
             float2 PixelPosition;
             float4 uv0;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
             float4 color : INTERP1;
             float3 normalWS : INTERP2;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            output.color.xyzw = input.color;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            output.color = input.color.xyzw;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _MainTex_TexelSize;
        float4 _Emm_TexelSize;
        float _DitherAmount;
        float _Fade;
        float4 _EmmissionColor;
        float2 _TexAnim;
        float _Mirror;
        float2 _MirrorMinMax;
        float _Emmission;
        float2 _GroundLuminance;
        float _Metallic;
        float _Specular;
        float _Fresnel;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);
        TEXTURE2D(_Emm);
        SAMPLER(sampler_Emm);
        float _Shine;
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Dither_float(float In, float4 ScreenPosition, out float Out)
        {
            float2 uv = ScreenPosition.xy * _ScreenParams.xy;
            float DITHER_THRESHOLDS[16] =
            {
                1.0 / 17.0,  9.0 / 17.0,  3.0 / 17.0, 11.0 / 17.0,
                13.0 / 17.0,  5.0 / 17.0, 15.0 / 17.0,  7.0 / 17.0,
                4.0 / 17.0, 12.0 / 17.0,  2.0 / 17.0, 10.0 / 17.0,
                16.0 / 17.0,  8.0 / 17.0, 14.0 / 17.0,  6.0 / 17.0
            };
            uint index = (uint(uv.x) % 4) * 4 + uint(uv.y) % 4;
            Out = In - DITHER_THRESHOLDS[index];
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _Split_c9a6e724099c4d45a556534434f339e4_R_1_Float = IN.VertexColor[0];
            float _Split_c9a6e724099c4d45a556534434f339e4_G_2_Float = IN.VertexColor[1];
            float _Split_c9a6e724099c4d45a556534434f339e4_B_3_Float = IN.VertexColor[2];
            float _Split_c9a6e724099c4d45a556534434f339e4_A_4_Float = IN.VertexColor[3];
            float _Property_deeb68840c5141fa91e21ba643f3935d_Out_0_Float = _Fade;
            UnityTexture2D _Property_5e98a959b1984fb284818333ed194c15_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MainTex);
            float2 _Property_65d6841d202a428882e5ac3f296bb8bd_Out_0_Vector2 = _TexAnim;
            float2 _TilingAndOffset_69ea1c8ad59c456f87e25422ad5fc046_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), _Property_65d6841d202a428882e5ac3f296bb8bd_Out_0_Vector2, _TilingAndOffset_69ea1c8ad59c456f87e25422ad5fc046_Out_3_Vector2);
            float4 _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_5e98a959b1984fb284818333ed194c15_Out_0_Texture2D.tex, _Property_5e98a959b1984fb284818333ed194c15_Out_0_Texture2D.samplerstate, _Property_5e98a959b1984fb284818333ed194c15_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_69ea1c8ad59c456f87e25422ad5fc046_Out_3_Vector2) );
            float _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_R_4_Float = _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_RGBA_0_Vector4.r;
            float _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_G_5_Float = _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_RGBA_0_Vector4.g;
            float _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_B_6_Float = _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_RGBA_0_Vector4.b;
            float _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_A_7_Float = _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_RGBA_0_Vector4.a;
            float _Multiply_236f6a1504d74e0eb5377f5d2cdbef74_Out_2_Float;
            Unity_Multiply_float_float(_Property_deeb68840c5141fa91e21ba643f3935d_Out_0_Float, _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_A_7_Float, _Multiply_236f6a1504d74e0eb5377f5d2cdbef74_Out_2_Float);
            float _Multiply_5fd8e20adcbe4b2aa10033e56ab81220_Out_2_Float;
            Unity_Multiply_float_float(_Split_c9a6e724099c4d45a556534434f339e4_A_4_Float, _Multiply_236f6a1504d74e0eb5377f5d2cdbef74_Out_2_Float, _Multiply_5fd8e20adcbe4b2aa10033e56ab81220_Out_2_Float);
            float _Property_2c28039c7f7941d48354c40c8c742248_Out_0_Float = _DitherAmount;
            float _Dither_4e2caf6e1eda413ca1c7cde0d8bee9b1_Out_2_Float;
            Unity_Dither_float(_Property_2c28039c7f7941d48354c40c8c742248_Out_0_Float, float4(IN.NDCPosition.xy, 0, 0), _Dither_4e2caf6e1eda413ca1c7cde0d8bee9b1_Out_2_Float);
            surface.Alpha = _Multiply_5fd8e20adcbe4b2aa10033e56ab81220_Out_2_Float;
            surface.AlphaClipThreshold = _Dither_4e2caf6e1eda413ca1c7cde0d8bee9b1_Out_2_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.uv0 = input.texCoord0;
            output.VertexColor = input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ShadowCaster"
            Tags
            {
                "LightMode" = "ShadowCaster"
            }
        
        // Render State
        Cull [_Cull]
        ZTest LEqual
        ZWrite On
        ColorMask 0
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_SHADOWCASTER
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 normalWS;
             float4 texCoord0;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float2 NDCPosition;
             float2 PixelPosition;
             float4 uv0;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
             float4 color : INTERP1;
             float3 normalWS : INTERP2;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            output.color.xyzw = input.color;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            output.color = input.color.xyzw;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _MainTex_TexelSize;
        float4 _Emm_TexelSize;
        float _DitherAmount;
        float _Fade;
        float4 _EmmissionColor;
        float2 _TexAnim;
        float _Mirror;
        float2 _MirrorMinMax;
        float _Emmission;
        float2 _GroundLuminance;
        float _Metallic;
        float _Specular;
        float _Fresnel;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);
        TEXTURE2D(_Emm);
        SAMPLER(sampler_Emm);
        float _Shine;
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Dither_float(float In, float4 ScreenPosition, out float Out)
        {
            float2 uv = ScreenPosition.xy * _ScreenParams.xy;
            float DITHER_THRESHOLDS[16] =
            {
                1.0 / 17.0,  9.0 / 17.0,  3.0 / 17.0, 11.0 / 17.0,
                13.0 / 17.0,  5.0 / 17.0, 15.0 / 17.0,  7.0 / 17.0,
                4.0 / 17.0, 12.0 / 17.0,  2.0 / 17.0, 10.0 / 17.0,
                16.0 / 17.0,  8.0 / 17.0, 14.0 / 17.0,  6.0 / 17.0
            };
            uint index = (uint(uv.x) % 4) * 4 + uint(uv.y) % 4;
            Out = In - DITHER_THRESHOLDS[index];
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _Split_c9a6e724099c4d45a556534434f339e4_R_1_Float = IN.VertexColor[0];
            float _Split_c9a6e724099c4d45a556534434f339e4_G_2_Float = IN.VertexColor[1];
            float _Split_c9a6e724099c4d45a556534434f339e4_B_3_Float = IN.VertexColor[2];
            float _Split_c9a6e724099c4d45a556534434f339e4_A_4_Float = IN.VertexColor[3];
            float _Property_deeb68840c5141fa91e21ba643f3935d_Out_0_Float = _Fade;
            UnityTexture2D _Property_5e98a959b1984fb284818333ed194c15_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MainTex);
            float2 _Property_65d6841d202a428882e5ac3f296bb8bd_Out_0_Vector2 = _TexAnim;
            float2 _TilingAndOffset_69ea1c8ad59c456f87e25422ad5fc046_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), _Property_65d6841d202a428882e5ac3f296bb8bd_Out_0_Vector2, _TilingAndOffset_69ea1c8ad59c456f87e25422ad5fc046_Out_3_Vector2);
            float4 _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_5e98a959b1984fb284818333ed194c15_Out_0_Texture2D.tex, _Property_5e98a959b1984fb284818333ed194c15_Out_0_Texture2D.samplerstate, _Property_5e98a959b1984fb284818333ed194c15_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_69ea1c8ad59c456f87e25422ad5fc046_Out_3_Vector2) );
            float _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_R_4_Float = _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_RGBA_0_Vector4.r;
            float _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_G_5_Float = _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_RGBA_0_Vector4.g;
            float _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_B_6_Float = _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_RGBA_0_Vector4.b;
            float _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_A_7_Float = _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_RGBA_0_Vector4.a;
            float _Multiply_236f6a1504d74e0eb5377f5d2cdbef74_Out_2_Float;
            Unity_Multiply_float_float(_Property_deeb68840c5141fa91e21ba643f3935d_Out_0_Float, _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_A_7_Float, _Multiply_236f6a1504d74e0eb5377f5d2cdbef74_Out_2_Float);
            float _Multiply_5fd8e20adcbe4b2aa10033e56ab81220_Out_2_Float;
            Unity_Multiply_float_float(_Split_c9a6e724099c4d45a556534434f339e4_A_4_Float, _Multiply_236f6a1504d74e0eb5377f5d2cdbef74_Out_2_Float, _Multiply_5fd8e20adcbe4b2aa10033e56ab81220_Out_2_Float);
            float _Property_2c28039c7f7941d48354c40c8c742248_Out_0_Float = _DitherAmount;
            float _Dither_4e2caf6e1eda413ca1c7cde0d8bee9b1_Out_2_Float;
            Unity_Dither_float(_Property_2c28039c7f7941d48354c40c8c742248_Out_0_Float, float4(IN.NDCPosition.xy, 0, 0), _Dither_4e2caf6e1eda413ca1c7cde0d8bee9b1_Out_2_Float);
            surface.Alpha = _Multiply_5fd8e20adcbe4b2aa10033e56ab81220_Out_2_Float;
            surface.AlphaClipThreshold = _Dither_4e2caf6e1eda413ca1c7cde0d8bee9b1_Out_2_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.uv0 = input.texCoord0;
            output.VertexColor = input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "GBuffer"
            Tags
            {
                "LightMode" = "UniversalGBuffer"
            }
        
        // Render State
        Cull [_Cull]
        Blend [_SrcBlend] [_DstBlend], [_SrcBlendAlpha] [_DstBlendAlpha]
        ZTest [_ZTest]
        ZWrite [_ZWrite]
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles3 glcore
        #pragma multi_compile_instancing
        #pragma instancing_options renderinglayer
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
        #pragma multi_compile_fragment _ _RENDER_PASS_ENABLED
        #pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT
        #pragma multi_compile _ SHADOWS_SHADOWMASK
        #pragma shader_feature_fragment _ _SURFACE_TYPE_TRANSPARENT
        #pragma shader_feature_local_fragment _ _ALPHAPREMULTIPLY_ON
        #pragma shader_feature_local_fragment _ _ALPHAMODULATE_ON
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        #pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
        #pragma multi_compile _ _FORWARD_PLUS
        
        
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_GBUFFER
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 texCoord0;
             float4 color;
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
             float4 probeOcclusion;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpaceNormal;
             float3 WorldSpaceViewDirection;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float4 uv0;
             float4 VertexColor;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if !defined(LIGHTMAP_ON)
             float3 sh : INTERP0;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
             float4 probeOcclusion : INTERP1;
            #endif
             float4 texCoord0 : INTERP2;
             float4 color : INTERP3;
             float3 positionWS : INTERP4;
             float3 normalWS : INTERP5;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            output.probeOcclusion = input.probeOcclusion;
            #endif
            output.texCoord0.xyzw = input.texCoord0;
            output.color.xyzw = input.color;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            output.probeOcclusion = input.probeOcclusion;
            #endif
            output.texCoord0 = input.texCoord0.xyzw;
            output.color = input.color.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _MainTex_TexelSize;
        float4 _Emm_TexelSize;
        float _DitherAmount;
        float _Fade;
        float4 _EmmissionColor;
        float2 _TexAnim;
        float _Mirror;
        float2 _MirrorMinMax;
        float _Emmission;
        float2 _GroundLuminance;
        float _Metallic;
        float _Specular;
        float _Fresnel;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);
        TEXTURE2D(_Emm);
        SAMPLER(sampler_Emm);
        float _Shine;
        
        // Graph Includes
        #include_with_pragmas "Packages/com.cyanilux.shadergraph-customlighting/CustomLighting.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
        Out = A * B;
        }
        
        void Unity_Fraction_float(float In, out float Out)
        {
            Out = frac(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Minimum_float(float A, float B, out float Out)
        {
            Out = min(A, B);
        };
        
        void Unity_Round_float(float In, out float Out)
        {
            Out = round(In);
        }
        
        struct Bindings_LinearTime_f5a6b970195e54e43a218b75fe1986be_float
        {
        float3 TimeParameters;
        };
        
        void SG_LinearTime_f5a6b970195e54e43a218b75fe1986be_float(float _In, bool _In_90e9a0b0dc6344b8adaa3e14779fa2f9_IsConnected, float _Speed, Bindings_LinearTime_f5a6b970195e54e43a218b75fe1986be_float IN, out float Loop_1, out float Mirror_2, out float Switch_3)
        {
        float _Property_ccec6e839c994bbc9b8379fc232a4cb4_Out_0_Float = _In;
        bool _Property_ccec6e839c994bbc9b8379fc232a4cb4_Out_0_Float_IsConnected = _In_90e9a0b0dc6344b8adaa3e14779fa2f9_IsConnected;
        float _BranchOnInputConnection_f58c0353cb07438e8373957e727be54c_Out_3_Float = _Property_ccec6e839c994bbc9b8379fc232a4cb4_Out_0_Float_IsConnected ? _Property_ccec6e839c994bbc9b8379fc232a4cb4_Out_0_Float : IN.TimeParameters.x;
        float _Property_e45ce466129c4bee8f6fffff4f8e3234_Out_0_Float = _Speed;
        float _Multiply_4a6091052dbe4988b0d16523d257520e_Out_2_Float;
        Unity_Multiply_float_float(_BranchOnInputConnection_f58c0353cb07438e8373957e727be54c_Out_3_Float, _Property_e45ce466129c4bee8f6fffff4f8e3234_Out_0_Float, _Multiply_4a6091052dbe4988b0d16523d257520e_Out_2_Float);
        float _Fraction_42d232cf1270414ba1023756f71f0a2d_Out_1_Float;
        Unity_Fraction_float(_Multiply_4a6091052dbe4988b0d16523d257520e_Out_2_Float, _Fraction_42d232cf1270414ba1023756f71f0a2d_Out_1_Float);
        float _OneMinus_351c618a71f6456e85bc8c971f0066a9_Out_1_Float;
        Unity_OneMinus_float(_Fraction_42d232cf1270414ba1023756f71f0a2d_Out_1_Float, _OneMinus_351c618a71f6456e85bc8c971f0066a9_Out_1_Float);
        float _Minimum_782aeb76b2974423b93c59ba2d9ed533_Out_2_Float;
        Unity_Minimum_float(_Fraction_42d232cf1270414ba1023756f71f0a2d_Out_1_Float, _OneMinus_351c618a71f6456e85bc8c971f0066a9_Out_1_Float, _Minimum_782aeb76b2974423b93c59ba2d9ed533_Out_2_Float);
        float _Multiply_fd017f80dd2949fa8038202f7f5bb911_Out_2_Float;
        Unity_Multiply_float_float(_Minimum_782aeb76b2974423b93c59ba2d9ed533_Out_2_Float, 2, _Multiply_fd017f80dd2949fa8038202f7f5bb911_Out_2_Float);
        float _Round_60cd34698aad44c187a74884eca39139_Out_1_Float;
        Unity_Round_float(_Fraction_42d232cf1270414ba1023756f71f0a2d_Out_1_Float, _Round_60cd34698aad44c187a74884eca39139_Out_1_Float);
        Loop_1 = _Fraction_42d232cf1270414ba1023756f71f0a2d_Out_1_Float;
        Mirror_2 = _Multiply_fd017f80dd2949fa8038202f7f5bb911_Out_2_Float;
        Switch_3 = _Round_60cd34698aad44c187a74884eca39139_Out_1_Float;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        struct Bindings_AdditionalLights_f831f4743ad6aab44842def2f21aa4bd_float
        {
        float3 WorldSpaceNormal;
        float3 WorldSpaceViewDirection;
        float3 WorldSpacePosition;
        };
        
        void SG_AdditionalLights_f831f4743ad6aab44842def2f21aa4bd_float(float3 Vector3_209992F2, float Vector1_A38DA60E, float3 _Normal, bool _Normal_f4bf772aaae34d2f9780cff2a9b55bc8_IsConnected, half4 _Shadowmask, Bindings_AdditionalLights_f831f4743ad6aab44842def2f21aa4bd_float IN, out float3 Diffuse_1, out float3 Specular_2)
        {
        float3 _Property_1583269ec9a68c8aba285145649a2ac5_Out_0_Vector3 = Vector3_209992F2;
        float _Property_eb4601815121318284520396b2d3fae7_Out_0_Float = Vector1_A38DA60E;
        float3 _Property_adb1e03036394f8da6438aa4d7b50025_Out_0_Vector3 = _Normal;
        bool _Property_adb1e03036394f8da6438aa4d7b50025_Out_0_Vector3_IsConnected = _Normal_f4bf772aaae34d2f9780cff2a9b55bc8_IsConnected;
        float3 _BranchOnInputConnection_f086b1ffa0584bc9bda364f3e240bc4e_Out_3_Vector3 = _Property_adb1e03036394f8da6438aa4d7b50025_Out_0_Vector3_IsConnected ? _Property_adb1e03036394f8da6438aa4d7b50025_Out_0_Vector3 : IN.WorldSpaceNormal;
        half4 _Property_a2e212aebe7a4f57982c65d053a53703_Out_0_Vector4 = _Shadowmask;
        float3 _AdditionalLightsCustomFunction_438f6d908c13bc8b84c3074db8e60c56_Diffuse_5_Vector3;
        float3 _AdditionalLightsCustomFunction_438f6d908c13bc8b84c3074db8e60c56_Specular_6_Vector3;
        AdditionalLights_float(_Property_1583269ec9a68c8aba285145649a2ac5_Out_0_Vector3, _Property_eb4601815121318284520396b2d3fae7_Out_0_Float, IN.WorldSpacePosition, _BranchOnInputConnection_f086b1ffa0584bc9bda364f3e240bc4e_Out_3_Vector3, IN.WorldSpaceViewDirection, _Property_a2e212aebe7a4f57982c65d053a53703_Out_0_Vector4, _AdditionalLightsCustomFunction_438f6d908c13bc8b84c3074db8e60c56_Diffuse_5_Vector3, _AdditionalLightsCustomFunction_438f6d908c13bc8b84c3074db8e60c56_Specular_6_Vector3);
        Diffuse_1 = _AdditionalLightsCustomFunction_438f6d908c13bc8b84c3074db8e60c56_Diffuse_5_Vector3;
        Specular_2 = _AdditionalLightsCustomFunction_438f6d908c13bc8b84c3074db8e60c56_Specular_6_Vector3;
        }
        
        void Unity_Saturate_float3(float3 In, out float3 Out)
        {
            Out = saturate(In);
        }
        
        void Unity_FresnelEffect_float(float3 Normal, float3 ViewDir, float Power, out float Out)
        {
            Out = pow((1.0 - saturate(dot(normalize(Normal), ViewDir))), Power);
        }
        
        void Unity_Step_float(float Edge, float In, out float Out)
        {
            Out = step(Edge, In);
        }
        
        void Unity_DotProduct_float3(float3 A, float3 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void MainLightDirection_float(out float3 Direction)
        {
            #if SHADERGRAPH_PREVIEW
            Direction = half3(-0.5, -0.5, 0);
            #else
            Direction = SHADERGRAPH_MAIN_LIGHT_DIRECTION();
            #endif
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_SampleGradientV1_float(Gradient Gradient, float Time, out float4 Out)
        {
            // convert to OkLab if we need perceptual color space.
            float3 color = lerp(Gradient.colors[0].rgb, LinearToOklab(Gradient.colors[0].rgb), Gradient.type == 2);
        
            [unroll]
            for (int c = 1; c < Gradient.colorsLength; c++)
            {
                float colorPos = saturate((Time - Gradient.colors[c - 1].w) / (Gradient.colors[c].w - Gradient.colors[c - 1].w)) * step(c, Gradient.colorsLength - 1);
                float3 color2 = lerp(Gradient.colors[c].rgb, LinearToOklab(Gradient.colors[c].rgb), Gradient.type == 2);
                color = lerp(color, color2, lerp(colorPos, step(0.01, colorPos), Gradient.type % 2)); // grad.type == 1 is fixed, 0 and 2 are blends.
            }
            color = lerp(color, OklabToLinear(color), Gradient.type == 2);
        
        #ifdef UNITY_COLORSPACE_GAMMA
            color = LinearToSRGB(color);
        #endif
        
            float alpha = Gradient.alphas[0].x;
            [unroll]
            for (int a = 1; a < Gradient.alphasLength; a++)
            {
                float alphaPos = saturate((Time - Gradient.alphas[a - 1].y) / (Gradient.alphas[a].y - Gradient.alphas[a - 1].y)) * step(a, Gradient.alphasLength - 1);
                alpha = lerp(alpha, Gradient.alphas[a].x, lerp(alphaPos, step(0.01, alphaPos), Gradient.type % 2));
            }
        
            Out = float4(color, alpha);
        }
        
        void Unity_ViewVectorWorld_float(out float3 Out, float3 WorldSpacePosition)
        {
            Out = _WorldSpaceCameraPos.xyz - GetAbsolutePositionWS(WorldSpacePosition);
            if(!IsPerspectiveProjection())
            {
                Out = GetViewForwardDir() * dot(Out, GetViewForwardDir());
            }
        }
        
        void Unity_Reflection_float3(float3 In, float3 Normal, out float3 Out)
        {
            Out = reflect(In, Normal);
        }
        
        void Unity_Normalize_float3(float3 In, out float3 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_Blend_Multiply_float4(float4 Base, float4 Blend, out float4 Out, float Opacity)
        {
            Out = Base * Blend;
            Out = lerp(Base, Out, Opacity);
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Blend_Lighten_float4(float4 Base, float4 Blend, out float4 Out, float Opacity)
        {
            Out = max(Blend, Base);
            Out = lerp(Base, Out, Opacity);
        }
        
        void Unity_Saturate_float4(float4 In, out float4 Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Blend_Multiply_float3(float3 Base, float3 Blend, out float3 Out, float Opacity)
        {
            Out = Base * Blend;
            Out = lerp(Base, Out, Opacity);
        }
        
        void Unity_Fog_float(out float4 Color, out float Density, float3 Position)
        {
            SHADERGRAPH_FOG(Position, Color, Density);
        }
        
        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Dither_float(float In, float4 ScreenPosition, out float Out)
        {
            float2 uv = ScreenPosition.xy * _ScreenParams.xy;
            float DITHER_THRESHOLDS[16] =
            {
                1.0 / 17.0,  9.0 / 17.0,  3.0 / 17.0, 11.0 / 17.0,
                13.0 / 17.0,  5.0 / 17.0, 15.0 / 17.0,  7.0 / 17.0,
                4.0 / 17.0, 12.0 / 17.0,  2.0 / 17.0, 10.0 / 17.0,
                16.0 / 17.0,  8.0 / 17.0, 14.0 / 17.0,  6.0 / 17.0
            };
            uint index = (uint(uv.x) % 4) * 4 + uint(uv.y) % 4;
            Out = In - DITHER_THRESHOLDS[index];
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_c86def888f50468da53261517e29b15b_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Emm);
            float2 _Property_65d6841d202a428882e5ac3f296bb8bd_Out_0_Vector2 = _TexAnim;
            float2 _TilingAndOffset_69ea1c8ad59c456f87e25422ad5fc046_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), _Property_65d6841d202a428882e5ac3f296bb8bd_Out_0_Vector2, _TilingAndOffset_69ea1c8ad59c456f87e25422ad5fc046_Out_3_Vector2);
            float4 _SampleTexture2D_f228ab5ff8c34398ae216c2cdf5c5381_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_c86def888f50468da53261517e29b15b_Out_0_Texture2D.tex, _Property_c86def888f50468da53261517e29b15b_Out_0_Texture2D.samplerstate, _Property_c86def888f50468da53261517e29b15b_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_69ea1c8ad59c456f87e25422ad5fc046_Out_3_Vector2) );
            float _SampleTexture2D_f228ab5ff8c34398ae216c2cdf5c5381_R_4_Float = _SampleTexture2D_f228ab5ff8c34398ae216c2cdf5c5381_RGBA_0_Vector4.r;
            float _SampleTexture2D_f228ab5ff8c34398ae216c2cdf5c5381_G_5_Float = _SampleTexture2D_f228ab5ff8c34398ae216c2cdf5c5381_RGBA_0_Vector4.g;
            float _SampleTexture2D_f228ab5ff8c34398ae216c2cdf5c5381_B_6_Float = _SampleTexture2D_f228ab5ff8c34398ae216c2cdf5c5381_RGBA_0_Vector4.b;
            float _SampleTexture2D_f228ab5ff8c34398ae216c2cdf5c5381_A_7_Float = _SampleTexture2D_f228ab5ff8c34398ae216c2cdf5c5381_RGBA_0_Vector4.a;
            float _Property_6b2d45808f5240cabd9c66bb79a20cbb_Out_0_Float = _Emmission;
            float _Property_6308d0aa301a4294b75dd7b0b1f0438b_Out_0_Float = _Mirror;
            Bindings_LinearTime_f5a6b970195e54e43a218b75fe1986be_float _LinearTime_0c0d453673314091967795f2c08fb12a;
            _LinearTime_0c0d453673314091967795f2c08fb12a.TimeParameters = IN.TimeParameters;
            float _LinearTime_0c0d453673314091967795f2c08fb12a_Loop_1_Float;
            float _LinearTime_0c0d453673314091967795f2c08fb12a_Mirror_2_Float;
            float _LinearTime_0c0d453673314091967795f2c08fb12a_Switch_3_Float;
            SG_LinearTime_f5a6b970195e54e43a218b75fe1986be_float(float(0), false, _Property_6308d0aa301a4294b75dd7b0b1f0438b_Out_0_Float, _LinearTime_0c0d453673314091967795f2c08fb12a, _LinearTime_0c0d453673314091967795f2c08fb12a_Loop_1_Float, _LinearTime_0c0d453673314091967795f2c08fb12a_Mirror_2_Float, _LinearTime_0c0d453673314091967795f2c08fb12a_Switch_3_Float);
            float2 _Property_0e6aafc8348449cfb6bdd83cea8b7c8d_Out_0_Vector2 = _MirrorMinMax;
            float _Remap_95d761278d8d42eb9882d3949fc1ab64_Out_3_Float;
            Unity_Remap_float(_LinearTime_0c0d453673314091967795f2c08fb12a_Mirror_2_Float, float2 (0, 1), _Property_0e6aafc8348449cfb6bdd83cea8b7c8d_Out_0_Vector2, _Remap_95d761278d8d42eb9882d3949fc1ab64_Out_3_Float);
            float _Multiply_8c2375418d934e84bf18321234d0d558_Out_2_Float;
            Unity_Multiply_float_float(_Property_6b2d45808f5240cabd9c66bb79a20cbb_Out_0_Float, _Remap_95d761278d8d42eb9882d3949fc1ab64_Out_3_Float, _Multiply_8c2375418d934e84bf18321234d0d558_Out_2_Float);
            float4 _Multiply_4282f5f6c0f94fed90f977175e11484c_Out_2_Vector4;
            Unity_Multiply_float4_float4(_SampleTexture2D_f228ab5ff8c34398ae216c2cdf5c5381_RGBA_0_Vector4, (_Multiply_8c2375418d934e84bf18321234d0d558_Out_2_Float.xxxx), _Multiply_4282f5f6c0f94fed90f977175e11484c_Out_2_Vector4);
            float4 _Property_246858d0d55d42238bf1ec9c057d5744_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(_EmmissionColor) : _EmmissionColor;
            float4 _Add_56137f2997d74c158d81683bcc0a9be7_Out_2_Vector4;
            Unity_Add_float4(_Multiply_4282f5f6c0f94fed90f977175e11484c_Out_2_Vector4, _Property_246858d0d55d42238bf1ec9c057d5744_Out_0_Vector4, _Add_56137f2997d74c158d81683bcc0a9be7_Out_2_Vector4);
            Bindings_AdditionalLights_f831f4743ad6aab44842def2f21aa4bd_float _AdditionalLights_f7ba0a1a7bb0474c8ebf3175e74ab453;
            _AdditionalLights_f7ba0a1a7bb0474c8ebf3175e74ab453.WorldSpaceNormal = IN.WorldSpaceNormal;
            _AdditionalLights_f7ba0a1a7bb0474c8ebf3175e74ab453.WorldSpaceViewDirection = IN.WorldSpaceViewDirection;
            _AdditionalLights_f7ba0a1a7bb0474c8ebf3175e74ab453.WorldSpacePosition = IN.WorldSpacePosition;
            float3 _AdditionalLights_f7ba0a1a7bb0474c8ebf3175e74ab453_Diffuse_1_Vector3;
            float3 _AdditionalLights_f7ba0a1a7bb0474c8ebf3175e74ab453_Specular_2_Vector3;
            SG_AdditionalLights_f831f4743ad6aab44842def2f21aa4bd_float(float3 (0, 0, 0), float(0), float3 (0, 0, 0), false, half4 (1, 1, 1, 1), _AdditionalLights_f7ba0a1a7bb0474c8ebf3175e74ab453, _AdditionalLights_f7ba0a1a7bb0474c8ebf3175e74ab453_Diffuse_1_Vector3, _AdditionalLights_f7ba0a1a7bb0474c8ebf3175e74ab453_Specular_2_Vector3);
            float3 _Saturate_500b4986a1004f658ed406f4b136ae05_Out_1_Vector3;
            Unity_Saturate_float3(_AdditionalLights_f7ba0a1a7bb0474c8ebf3175e74ab453_Diffuse_1_Vector3, _Saturate_500b4986a1004f658ed406f4b136ae05_Out_1_Vector3);
            float _FresnelEffect_9d39d09f94064143856846232a443956_Out_3_Float;
            Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, float(2), _FresnelEffect_9d39d09f94064143856846232a443956_Out_3_Float);
            float _Step_8d8a255ef75049eab220d10acff0d516_Out_2_Float;
            Unity_Step_float(float(0.5), _FresnelEffect_9d39d09f94064143856846232a443956_Out_3_Float, _Step_8d8a255ef75049eab220d10acff0d516_Out_2_Float);
            float3 _Vector3_773e48da142642c49979a2c6c6772eea_Out_0_Vector3 = float3(float(0), float(1), float(0));
            float _DotProduct_a681e669c71e4371b9e3de7face5cb13_Out_2_Float;
            Unity_DotProduct_float3(_Vector3_773e48da142642c49979a2c6c6772eea_Out_0_Vector3, IN.WorldSpaceNormal, _DotProduct_a681e669c71e4371b9e3de7face5cb13_Out_2_Float);
            float _Multiply_e4ac6dfbd85249389c17e38e9fa2d0dc_Out_2_Float;
            Unity_Multiply_float_float(_Step_8d8a255ef75049eab220d10acff0d516_Out_2_Float, _DotProduct_a681e669c71e4371b9e3de7face5cb13_Out_2_Float, _Multiply_e4ac6dfbd85249389c17e38e9fa2d0dc_Out_2_Float);
            float _Swizzle_93b43cdeb64f4e5899b2cb51ddd10c3f_Out_1_Float = IN.VertexColor.y;
            float _Multiply_c5d0075d33cb495c91372c26d044f8b1_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_e4ac6dfbd85249389c17e38e9fa2d0dc_Out_2_Float, _Swizzle_93b43cdeb64f4e5899b2cb51ddd10c3f_Out_1_Float, _Multiply_c5d0075d33cb495c91372c26d044f8b1_Out_2_Float);
            float _Property_8e6ac123d25e425d8002501d3e1a0a70_Out_0_Float = _Shine;
            float _Multiply_99a19269e30e4d54ba01ce66f389ae77_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_c5d0075d33cb495c91372c26d044f8b1_Out_2_Float, _Property_8e6ac123d25e425d8002501d3e1a0a70_Out_0_Float, _Multiply_99a19269e30e4d54ba01ce66f389ae77_Out_2_Float);
            float _Saturate_ca8ea4b18af846989ff5ee776b6d5175_Out_1_Float;
            Unity_Saturate_float(_Multiply_99a19269e30e4d54ba01ce66f389ae77_Out_2_Float, _Saturate_ca8ea4b18af846989ff5ee776b6d5175_Out_1_Float);
            float3 _Add_b15089f0c3274152b37f3f600120bd37_Out_2_Vector3;
            Unity_Add_float3(_Saturate_500b4986a1004f658ed406f4b136ae05_Out_1_Vector3, (_Saturate_ca8ea4b18af846989ff5ee776b6d5175_Out_1_Float.xxx), _Add_b15089f0c3274152b37f3f600120bd37_Out_2_Vector3);
            float3 _Add_e2402a4838c74f4c9e4f2d5aee29a960_Out_2_Vector3;
            Unity_Add_float3((_Add_56137f2997d74c158d81683bcc0a9be7_Out_2_Vector4.xyz), _Add_b15089f0c3274152b37f3f600120bd37_Out_2_Vector3, _Add_e2402a4838c74f4c9e4f2d5aee29a960_Out_2_Vector3);
            float3 _Saturate_94c61a8f72fd4000abc09e9895627b0f_Out_1_Vector3;
            Unity_Saturate_float3(IN.WorldSpacePosition, _Saturate_94c61a8f72fd4000abc09e9895627b0f_Out_1_Vector3);
            float _Split_1d40da441edd4b06bc533cced3472604_R_1_Float = _Saturate_94c61a8f72fd4000abc09e9895627b0f_Out_1_Vector3[0];
            float _Split_1d40da441edd4b06bc533cced3472604_G_2_Float = _Saturate_94c61a8f72fd4000abc09e9895627b0f_Out_1_Vector3[1];
            float _Split_1d40da441edd4b06bc533cced3472604_B_3_Float = _Saturate_94c61a8f72fd4000abc09e9895627b0f_Out_1_Vector3[2];
            float _Split_1d40da441edd4b06bc533cced3472604_A_4_Float = 0;
            float2 _Property_1f9dc875a83c49e08aa354d6730a4c0b_Out_0_Vector2 = _GroundLuminance;
            float _Remap_528359c0024147e2b4646d39dc1b6dc4_Out_3_Float;
            Unity_Remap_float(_Split_1d40da441edd4b06bc533cced3472604_G_2_Float, float2 (0, 1), _Property_1f9dc875a83c49e08aa354d6730a4c0b_Out_0_Vector2, _Remap_528359c0024147e2b4646d39dc1b6dc4_Out_3_Float);
            float3 _MainLightDirection_7e9bab457bca463187a1bc5d49bfcfd3_Direction_0_Vector3;
            MainLightDirection_float(_MainLightDirection_7e9bab457bca463187a1bc5d49bfcfd3_Direction_0_Vector3);
            float _DotProduct_dfb9ca84ad6340d9890997ebbc7cd0f9_Out_2_Float;
            Unity_DotProduct_float3(IN.WorldSpaceNormal, _MainLightDirection_7e9bab457bca463187a1bc5d49bfcfd3_Direction_0_Vector3, _DotProduct_dfb9ca84ad6340d9890997ebbc7cd0f9_Out_2_Float);
            float _Saturate_56901fbb3768470d809e42210556c54f_Out_1_Float;
            Unity_Saturate_float(_DotProduct_dfb9ca84ad6340d9890997ebbc7cd0f9_Out_2_Float, _Saturate_56901fbb3768470d809e42210556c54f_Out_1_Float);
            float _OneMinus_f4e8accb4c804175b1df3b607c99314b_Out_1_Float;
            Unity_OneMinus_float(_Saturate_56901fbb3768470d809e42210556c54f_Out_1_Float, _OneMinus_f4e8accb4c804175b1df3b607c99314b_Out_1_Float);
            float _Add_c1cd98f83c52418aaf8acf3fefe6db27_Out_2_Float;
            Unity_Add_float(_OneMinus_f4e8accb4c804175b1df3b607c99314b_Out_1_Float, _SampleTexture2D_f228ab5ff8c34398ae216c2cdf5c5381_R_4_Float, _Add_c1cd98f83c52418aaf8acf3fefe6db27_Out_2_Float);
            float _Saturate_8673d8963a004997a1a326ecf975622c_Out_1_Float;
            Unity_Saturate_float(_Add_c1cd98f83c52418aaf8acf3fefe6db27_Out_2_Float, _Saturate_8673d8963a004997a1a326ecf975622c_Out_1_Float);
            float _Multiply_db40bccfff6245de97668657ea156aff_Out_2_Float;
            Unity_Multiply_float_float(_Remap_528359c0024147e2b4646d39dc1b6dc4_Out_3_Float, _Saturate_8673d8963a004997a1a326ecf975622c_Out_1_Float, _Multiply_db40bccfff6245de97668657ea156aff_Out_2_Float);
            float4 _SampleGradient_7134b5d3664d4b6bb82e5019d5c9a2ec_Out_2_Vector4;
            Unity_SampleGradientV1_float(NewGradient(0, 2, 2, float4(0.274028, 0.3241256, 0.8652291, 0),float4(1, 0.999249, 0.8881401, 1),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0), float2(1, 0),float2(1, 1),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0)), _Multiply_db40bccfff6245de97668657ea156aff_Out_2_Float, _SampleGradient_7134b5d3664d4b6bb82e5019d5c9a2ec_Out_2_Vector4);
            float _Property_74c1e8d12f27445d8eac46fbe6b87149_Out_0_Boolean = _Metallic;
            UnityTexture2D _Property_5e98a959b1984fb284818333ed194c15_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MainTex);
            float4 _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_5e98a959b1984fb284818333ed194c15_Out_0_Texture2D.tex, _Property_5e98a959b1984fb284818333ed194c15_Out_0_Texture2D.samplerstate, _Property_5e98a959b1984fb284818333ed194c15_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_69ea1c8ad59c456f87e25422ad5fc046_Out_3_Vector2) );
            float _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_R_4_Float = _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_RGBA_0_Vector4.r;
            float _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_G_5_Float = _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_RGBA_0_Vector4.g;
            float _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_B_6_Float = _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_RGBA_0_Vector4.b;
            float _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_A_7_Float = _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_RGBA_0_Vector4.a;
            float3 _ViewVector_eb016290adcb40848f61270bbd53aa26_Out_0_Vector3;
            Unity_ViewVectorWorld_float(_ViewVector_eb016290adcb40848f61270bbd53aa26_Out_0_Vector3, IN.WorldSpacePosition);
            float3 _Reflection_d17e4b1e5c9340e9bb7009776b6e83c4_Out_2_Vector3;
            Unity_Reflection_float3(_ViewVector_eb016290adcb40848f61270bbd53aa26_Out_0_Vector3, IN.WorldSpaceNormal, _Reflection_d17e4b1e5c9340e9bb7009776b6e83c4_Out_2_Vector3);
            float3 _Normalize_abebc2e64f6c4ab7bea5cf425fe4772c_Out_1_Vector3;
            Unity_Normalize_float3(_Reflection_d17e4b1e5c9340e9bb7009776b6e83c4_Out_2_Vector3, _Normalize_abebc2e64f6c4ab7bea5cf425fe4772c_Out_1_Vector3);
            float4 _SampleGradient_550c2767695448f89a06be50b562e027_Out_2_Vector4;
            Unity_SampleGradientV1_float(NewGradient(1, 4, 2, float4(0.1873314, 0.4300665, 1, 0.2159609),float4(0.1698112, 0.1698112, 0.1698112, 0.330251),float4(0, 0, 0, 0.5319295),float4(1, 1, 1, 0.7773098),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0), float2(1, 0),float2(1, 1),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0)), (_Normalize_abebc2e64f6c4ab7bea5cf425fe4772c_Out_1_Vector3).x, _SampleGradient_550c2767695448f89a06be50b562e027_Out_2_Vector4);
            float _Split_c9a6e724099c4d45a556534434f339e4_R_1_Float = IN.VertexColor[0];
            float _Split_c9a6e724099c4d45a556534434f339e4_G_2_Float = IN.VertexColor[1];
            float _Split_c9a6e724099c4d45a556534434f339e4_B_3_Float = IN.VertexColor[2];
            float _Split_c9a6e724099c4d45a556534434f339e4_A_4_Float = IN.VertexColor[3];
            float4 _Blend_e29b181cee344b3783abacc432bbd9eb_Out_2_Vector4;
            Unity_Blend_Multiply_float4(_SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_RGBA_0_Vector4, _SampleGradient_550c2767695448f89a06be50b562e027_Out_2_Vector4, _Blend_e29b181cee344b3783abacc432bbd9eb_Out_2_Vector4, _Split_c9a6e724099c4d45a556534434f339e4_R_1_Float);
            float4 _Branch_3a8072394c3744ec80c7b9d1d982c2e5_Out_3_Vector4;
            Unity_Branch_float4(_Property_74c1e8d12f27445d8eac46fbe6b87149_Out_0_Boolean, _Blend_e29b181cee344b3783abacc432bbd9eb_Out_2_Vector4, _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_RGBA_0_Vector4, _Branch_3a8072394c3744ec80c7b9d1d982c2e5_Out_3_Vector4);
            float3 _Reflection_22756abea90642b19aba6daae7644399_Out_2_Vector3;
            Unity_Reflection_float3(float3(0, -1, 0), IN.WorldSpaceNormal, _Reflection_22756abea90642b19aba6daae7644399_Out_2_Vector3);
            float _DotProduct_46718801ec8a4870ac7948422914faae_Out_2_Float;
            Unity_DotProduct_float3(_Reflection_22756abea90642b19aba6daae7644399_Out_2_Vector3, IN.WorldSpaceViewDirection, _DotProduct_46718801ec8a4870ac7948422914faae_Out_2_Float);
            float _Property_21e80ac221db49b08eb93df484c0cb6c_Out_0_Float = _Specular;
            float _Power_1b487f1b19b04a9abab40af30d60d5af_Out_2_Float;
            Unity_Power_float(_DotProduct_46718801ec8a4870ac7948422914faae_Out_2_Float, _Property_21e80ac221db49b08eb93df484c0cb6c_Out_0_Float, _Power_1b487f1b19b04a9abab40af30d60d5af_Out_2_Float);
            float4 _SampleGradient_a7e23dfff8364ed2b7134c7218ed85c9_Out_2_Vector4;
            Unity_SampleGradientV1_float(NewGradient(0, 2, 2, float4(0, 0, 0, 0.6147097),float4(1, 1, 1, 0.885298),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0), float2(1, 0),float2(1, 1),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0)), _Power_1b487f1b19b04a9abab40af30d60d5af_Out_2_Float, _SampleGradient_a7e23dfff8364ed2b7134c7218ed85c9_Out_2_Vector4);
            float _Property_f1fa91262d794f96a966b81219fa28bc_Out_0_Float = _Fresnel;
            float _FresnelEffect_23a5335bf7634bd89dc14235dcdcf5cb_Out_3_Float;
            Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, _Property_f1fa91262d794f96a966b81219fa28bc_Out_0_Float, _FresnelEffect_23a5335bf7634bd89dc14235dcdcf5cb_Out_3_Float);
            float4 _Add_e396075f878a4d31ad51a91692d20b5e_Out_2_Vector4;
            Unity_Add_float4(_SampleGradient_a7e23dfff8364ed2b7134c7218ed85c9_Out_2_Vector4, (_FresnelEffect_23a5335bf7634bd89dc14235dcdcf5cb_Out_3_Float.xxxx), _Add_e396075f878a4d31ad51a91692d20b5e_Out_2_Vector4);
            float4 _Blend_a90d26108d0b490cab2116099bd912c9_Out_2_Vector4;
            Unity_Blend_Lighten_float4(_Branch_3a8072394c3744ec80c7b9d1d982c2e5_Out_3_Vector4, _Add_e396075f878a4d31ad51a91692d20b5e_Out_2_Vector4, _Blend_a90d26108d0b490cab2116099bd912c9_Out_2_Vector4, _Split_c9a6e724099c4d45a556534434f339e4_R_1_Float);
            float4 _Multiply_0f9b35d0e5a54476914e105943b27721_Out_2_Vector4;
            Unity_Multiply_float4_float4(_SampleGradient_7134b5d3664d4b6bb82e5019d5c9a2ec_Out_2_Vector4, _Blend_a90d26108d0b490cab2116099bd912c9_Out_2_Vector4, _Multiply_0f9b35d0e5a54476914e105943b27721_Out_2_Vector4);
            float4 _Saturate_25da087dd4294611b7bab8afd25c37a1_Out_1_Vector4;
            Unity_Saturate_float4(_Multiply_0f9b35d0e5a54476914e105943b27721_Out_2_Vector4, _Saturate_25da087dd4294611b7bab8afd25c37a1_Out_1_Vector4);
            float3 _Blend_1a96f82fa5be4657b7b755ec106468b4_Out_2_Vector3;
            Unity_Blend_Multiply_float3((_Saturate_25da087dd4294611b7bab8afd25c37a1_Out_1_Vector4.xyz), SHADERGRAPH_AMBIENT_SKY, _Blend_1a96f82fa5be4657b7b755ec106468b4_Out_2_Vector3, float(0.5));
            float3 _Add_75281d4ee5c04490b4e5596f8662e75a_Out_2_Vector3;
            Unity_Add_float3(_Add_e2402a4838c74f4c9e4f2d5aee29a960_Out_2_Vector3, _Blend_1a96f82fa5be4657b7b755ec106468b4_Out_2_Vector3, _Add_75281d4ee5c04490b4e5596f8662e75a_Out_2_Vector3);
            float4 _Fog_77cc8ad60dcb4798b7df7ec80cbed738_Color_0_Vector4;
            float _Fog_77cc8ad60dcb4798b7df7ec80cbed738_Density_1_Float;
            Unity_Fog_float(_Fog_77cc8ad60dcb4798b7df7ec80cbed738_Color_0_Vector4, _Fog_77cc8ad60dcb4798b7df7ec80cbed738_Density_1_Float, IN.ObjectSpacePosition);
            float3 _Lerp_b061b84311ab4e63a397f5b9e998a51f_Out_3_Vector3;
            Unity_Lerp_float3(_Add_75281d4ee5c04490b4e5596f8662e75a_Out_2_Vector3, (_Fog_77cc8ad60dcb4798b7df7ec80cbed738_Color_0_Vector4.xyz), (_Fog_77cc8ad60dcb4798b7df7ec80cbed738_Density_1_Float.xxx), _Lerp_b061b84311ab4e63a397f5b9e998a51f_Out_3_Vector3);
            float _Property_deeb68840c5141fa91e21ba643f3935d_Out_0_Float = _Fade;
            float _Multiply_236f6a1504d74e0eb5377f5d2cdbef74_Out_2_Float;
            Unity_Multiply_float_float(_Property_deeb68840c5141fa91e21ba643f3935d_Out_0_Float, _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_A_7_Float, _Multiply_236f6a1504d74e0eb5377f5d2cdbef74_Out_2_Float);
            float _Multiply_5fd8e20adcbe4b2aa10033e56ab81220_Out_2_Float;
            Unity_Multiply_float_float(_Split_c9a6e724099c4d45a556534434f339e4_A_4_Float, _Multiply_236f6a1504d74e0eb5377f5d2cdbef74_Out_2_Float, _Multiply_5fd8e20adcbe4b2aa10033e56ab81220_Out_2_Float);
            float _Property_2c28039c7f7941d48354c40c8c742248_Out_0_Float = _DitherAmount;
            float _Dither_4e2caf6e1eda413ca1c7cde0d8bee9b1_Out_2_Float;
            Unity_Dither_float(_Property_2c28039c7f7941d48354c40c8c742248_Out_0_Float, float4(IN.NDCPosition.xy, 0, 0), _Dither_4e2caf6e1eda413ca1c7cde0d8bee9b1_Out_2_Float);
            surface.BaseColor = _Lerp_b061b84311ab4e63a397f5b9e998a51f_Out_3_Vector3;
            surface.Alpha = _Multiply_5fd8e20adcbe4b2aa10033e56ab81220_Out_2_Float;
            surface.AlphaClipThreshold = _Dither_4e2caf6e1eda413ca1c7cde0d8bee9b1_Out_2_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        
        
            output.WorldSpaceViewDirection = GetWorldSpaceNormalizeViewDir(input.positionWS);
            output.WorldSpacePosition = input.positionWS;
            output.ObjectSpacePosition = TransformWorldToObject(input.positionWS);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.uv0 = input.texCoord0;
            output.VertexColor = input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/UnlitGBufferPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "SceneSelectionPass"
            Tags
            {
                "LightMode" = "SceneSelectionPass"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        // GraphKeywords: <None>
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENESELECTIONPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float2 NDCPosition;
             float2 PixelPosition;
             float4 uv0;
             float4 VertexColor;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
             float4 color : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            output.color.xyzw = input.color;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            output.color = input.color.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _MainTex_TexelSize;
        float4 _Emm_TexelSize;
        float _DitherAmount;
        float _Fade;
        float4 _EmmissionColor;
        float2 _TexAnim;
        float _Mirror;
        float2 _MirrorMinMax;
        float _Emmission;
        float2 _GroundLuminance;
        float _Metallic;
        float _Specular;
        float _Fresnel;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);
        TEXTURE2D(_Emm);
        SAMPLER(sampler_Emm);
        float _Shine;
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Dither_float(float In, float4 ScreenPosition, out float Out)
        {
            float2 uv = ScreenPosition.xy * _ScreenParams.xy;
            float DITHER_THRESHOLDS[16] =
            {
                1.0 / 17.0,  9.0 / 17.0,  3.0 / 17.0, 11.0 / 17.0,
                13.0 / 17.0,  5.0 / 17.0, 15.0 / 17.0,  7.0 / 17.0,
                4.0 / 17.0, 12.0 / 17.0,  2.0 / 17.0, 10.0 / 17.0,
                16.0 / 17.0,  8.0 / 17.0, 14.0 / 17.0,  6.0 / 17.0
            };
            uint index = (uint(uv.x) % 4) * 4 + uint(uv.y) % 4;
            Out = In - DITHER_THRESHOLDS[index];
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _Split_c9a6e724099c4d45a556534434f339e4_R_1_Float = IN.VertexColor[0];
            float _Split_c9a6e724099c4d45a556534434f339e4_G_2_Float = IN.VertexColor[1];
            float _Split_c9a6e724099c4d45a556534434f339e4_B_3_Float = IN.VertexColor[2];
            float _Split_c9a6e724099c4d45a556534434f339e4_A_4_Float = IN.VertexColor[3];
            float _Property_deeb68840c5141fa91e21ba643f3935d_Out_0_Float = _Fade;
            UnityTexture2D _Property_5e98a959b1984fb284818333ed194c15_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MainTex);
            float2 _Property_65d6841d202a428882e5ac3f296bb8bd_Out_0_Vector2 = _TexAnim;
            float2 _TilingAndOffset_69ea1c8ad59c456f87e25422ad5fc046_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), _Property_65d6841d202a428882e5ac3f296bb8bd_Out_0_Vector2, _TilingAndOffset_69ea1c8ad59c456f87e25422ad5fc046_Out_3_Vector2);
            float4 _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_5e98a959b1984fb284818333ed194c15_Out_0_Texture2D.tex, _Property_5e98a959b1984fb284818333ed194c15_Out_0_Texture2D.samplerstate, _Property_5e98a959b1984fb284818333ed194c15_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_69ea1c8ad59c456f87e25422ad5fc046_Out_3_Vector2) );
            float _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_R_4_Float = _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_RGBA_0_Vector4.r;
            float _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_G_5_Float = _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_RGBA_0_Vector4.g;
            float _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_B_6_Float = _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_RGBA_0_Vector4.b;
            float _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_A_7_Float = _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_RGBA_0_Vector4.a;
            float _Multiply_236f6a1504d74e0eb5377f5d2cdbef74_Out_2_Float;
            Unity_Multiply_float_float(_Property_deeb68840c5141fa91e21ba643f3935d_Out_0_Float, _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_A_7_Float, _Multiply_236f6a1504d74e0eb5377f5d2cdbef74_Out_2_Float);
            float _Multiply_5fd8e20adcbe4b2aa10033e56ab81220_Out_2_Float;
            Unity_Multiply_float_float(_Split_c9a6e724099c4d45a556534434f339e4_A_4_Float, _Multiply_236f6a1504d74e0eb5377f5d2cdbef74_Out_2_Float, _Multiply_5fd8e20adcbe4b2aa10033e56ab81220_Out_2_Float);
            float _Property_2c28039c7f7941d48354c40c8c742248_Out_0_Float = _DitherAmount;
            float _Dither_4e2caf6e1eda413ca1c7cde0d8bee9b1_Out_2_Float;
            Unity_Dither_float(_Property_2c28039c7f7941d48354c40c8c742248_Out_0_Float, float4(IN.NDCPosition.xy, 0, 0), _Dither_4e2caf6e1eda413ca1c7cde0d8bee9b1_Out_2_Float);
            surface.Alpha = _Multiply_5fd8e20adcbe4b2aa10033e56ab81220_Out_2_Float;
            surface.AlphaClipThreshold = _Dither_4e2caf6e1eda413ca1c7cde0d8bee9b1_Out_2_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.uv0 = input.texCoord0;
            output.VertexColor = input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ScenePickingPass"
            Tags
            {
                "LightMode" = "Picking"
            }
        
        // Render State
        Cull [_Cull]
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        #pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
        #pragma multi_compile _ _FORWARD_PLUS
        
        
        
        // Defines
        
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_COLOR
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENEPICKINGPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 texCoord0;
             float4 color;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpaceNormal;
             float3 WorldSpaceViewDirection;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float4 uv0;
             float4 VertexColor;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
             float4 color : INTERP1;
             float3 positionWS : INTERP2;
             float3 normalWS : INTERP3;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            output.color.xyzw = input.color;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            output.color = input.color.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _MainTex_TexelSize;
        float4 _Emm_TexelSize;
        float _DitherAmount;
        float _Fade;
        float4 _EmmissionColor;
        float2 _TexAnim;
        float _Mirror;
        float2 _MirrorMinMax;
        float _Emmission;
        float2 _GroundLuminance;
        float _Metallic;
        float _Specular;
        float _Fresnel;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_MainTex);
        SAMPLER(sampler_MainTex);
        TEXTURE2D(_Emm);
        SAMPLER(sampler_Emm);
        float _Shine;
        
        // Graph Includes
        #include_with_pragmas "Packages/com.cyanilux.shadergraph-customlighting/CustomLighting.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
        Out = A * B;
        }
        
        void Unity_Fraction_float(float In, out float Out)
        {
            Out = frac(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Minimum_float(float A, float B, out float Out)
        {
            Out = min(A, B);
        };
        
        void Unity_Round_float(float In, out float Out)
        {
            Out = round(In);
        }
        
        struct Bindings_LinearTime_f5a6b970195e54e43a218b75fe1986be_float
        {
        float3 TimeParameters;
        };
        
        void SG_LinearTime_f5a6b970195e54e43a218b75fe1986be_float(float _In, bool _In_90e9a0b0dc6344b8adaa3e14779fa2f9_IsConnected, float _Speed, Bindings_LinearTime_f5a6b970195e54e43a218b75fe1986be_float IN, out float Loop_1, out float Mirror_2, out float Switch_3)
        {
        float _Property_ccec6e839c994bbc9b8379fc232a4cb4_Out_0_Float = _In;
        bool _Property_ccec6e839c994bbc9b8379fc232a4cb4_Out_0_Float_IsConnected = _In_90e9a0b0dc6344b8adaa3e14779fa2f9_IsConnected;
        float _BranchOnInputConnection_f58c0353cb07438e8373957e727be54c_Out_3_Float = _Property_ccec6e839c994bbc9b8379fc232a4cb4_Out_0_Float_IsConnected ? _Property_ccec6e839c994bbc9b8379fc232a4cb4_Out_0_Float : IN.TimeParameters.x;
        float _Property_e45ce466129c4bee8f6fffff4f8e3234_Out_0_Float = _Speed;
        float _Multiply_4a6091052dbe4988b0d16523d257520e_Out_2_Float;
        Unity_Multiply_float_float(_BranchOnInputConnection_f58c0353cb07438e8373957e727be54c_Out_3_Float, _Property_e45ce466129c4bee8f6fffff4f8e3234_Out_0_Float, _Multiply_4a6091052dbe4988b0d16523d257520e_Out_2_Float);
        float _Fraction_42d232cf1270414ba1023756f71f0a2d_Out_1_Float;
        Unity_Fraction_float(_Multiply_4a6091052dbe4988b0d16523d257520e_Out_2_Float, _Fraction_42d232cf1270414ba1023756f71f0a2d_Out_1_Float);
        float _OneMinus_351c618a71f6456e85bc8c971f0066a9_Out_1_Float;
        Unity_OneMinus_float(_Fraction_42d232cf1270414ba1023756f71f0a2d_Out_1_Float, _OneMinus_351c618a71f6456e85bc8c971f0066a9_Out_1_Float);
        float _Minimum_782aeb76b2974423b93c59ba2d9ed533_Out_2_Float;
        Unity_Minimum_float(_Fraction_42d232cf1270414ba1023756f71f0a2d_Out_1_Float, _OneMinus_351c618a71f6456e85bc8c971f0066a9_Out_1_Float, _Minimum_782aeb76b2974423b93c59ba2d9ed533_Out_2_Float);
        float _Multiply_fd017f80dd2949fa8038202f7f5bb911_Out_2_Float;
        Unity_Multiply_float_float(_Minimum_782aeb76b2974423b93c59ba2d9ed533_Out_2_Float, 2, _Multiply_fd017f80dd2949fa8038202f7f5bb911_Out_2_Float);
        float _Round_60cd34698aad44c187a74884eca39139_Out_1_Float;
        Unity_Round_float(_Fraction_42d232cf1270414ba1023756f71f0a2d_Out_1_Float, _Round_60cd34698aad44c187a74884eca39139_Out_1_Float);
        Loop_1 = _Fraction_42d232cf1270414ba1023756f71f0a2d_Out_1_Float;
        Mirror_2 = _Multiply_fd017f80dd2949fa8038202f7f5bb911_Out_2_Float;
        Switch_3 = _Round_60cd34698aad44c187a74884eca39139_Out_1_Float;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        struct Bindings_AdditionalLights_f831f4743ad6aab44842def2f21aa4bd_float
        {
        float3 WorldSpaceNormal;
        float3 WorldSpaceViewDirection;
        float3 WorldSpacePosition;
        };
        
        void SG_AdditionalLights_f831f4743ad6aab44842def2f21aa4bd_float(float3 Vector3_209992F2, float Vector1_A38DA60E, float3 _Normal, bool _Normal_f4bf772aaae34d2f9780cff2a9b55bc8_IsConnected, half4 _Shadowmask, Bindings_AdditionalLights_f831f4743ad6aab44842def2f21aa4bd_float IN, out float3 Diffuse_1, out float3 Specular_2)
        {
        float3 _Property_1583269ec9a68c8aba285145649a2ac5_Out_0_Vector3 = Vector3_209992F2;
        float _Property_eb4601815121318284520396b2d3fae7_Out_0_Float = Vector1_A38DA60E;
        float3 _Property_adb1e03036394f8da6438aa4d7b50025_Out_0_Vector3 = _Normal;
        bool _Property_adb1e03036394f8da6438aa4d7b50025_Out_0_Vector3_IsConnected = _Normal_f4bf772aaae34d2f9780cff2a9b55bc8_IsConnected;
        float3 _BranchOnInputConnection_f086b1ffa0584bc9bda364f3e240bc4e_Out_3_Vector3 = _Property_adb1e03036394f8da6438aa4d7b50025_Out_0_Vector3_IsConnected ? _Property_adb1e03036394f8da6438aa4d7b50025_Out_0_Vector3 : IN.WorldSpaceNormal;
        half4 _Property_a2e212aebe7a4f57982c65d053a53703_Out_0_Vector4 = _Shadowmask;
        float3 _AdditionalLightsCustomFunction_438f6d908c13bc8b84c3074db8e60c56_Diffuse_5_Vector3;
        float3 _AdditionalLightsCustomFunction_438f6d908c13bc8b84c3074db8e60c56_Specular_6_Vector3;
        AdditionalLights_float(_Property_1583269ec9a68c8aba285145649a2ac5_Out_0_Vector3, _Property_eb4601815121318284520396b2d3fae7_Out_0_Float, IN.WorldSpacePosition, _BranchOnInputConnection_f086b1ffa0584bc9bda364f3e240bc4e_Out_3_Vector3, IN.WorldSpaceViewDirection, _Property_a2e212aebe7a4f57982c65d053a53703_Out_0_Vector4, _AdditionalLightsCustomFunction_438f6d908c13bc8b84c3074db8e60c56_Diffuse_5_Vector3, _AdditionalLightsCustomFunction_438f6d908c13bc8b84c3074db8e60c56_Specular_6_Vector3);
        Diffuse_1 = _AdditionalLightsCustomFunction_438f6d908c13bc8b84c3074db8e60c56_Diffuse_5_Vector3;
        Specular_2 = _AdditionalLightsCustomFunction_438f6d908c13bc8b84c3074db8e60c56_Specular_6_Vector3;
        }
        
        void Unity_Saturate_float3(float3 In, out float3 Out)
        {
            Out = saturate(In);
        }
        
        void Unity_FresnelEffect_float(float3 Normal, float3 ViewDir, float Power, out float Out)
        {
            Out = pow((1.0 - saturate(dot(normalize(Normal), ViewDir))), Power);
        }
        
        void Unity_Step_float(float Edge, float In, out float Out)
        {
            Out = step(Edge, In);
        }
        
        void Unity_DotProduct_float3(float3 A, float3 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void MainLightDirection_float(out float3 Direction)
        {
            #if SHADERGRAPH_PREVIEW
            Direction = half3(-0.5, -0.5, 0);
            #else
            Direction = SHADERGRAPH_MAIN_LIGHT_DIRECTION();
            #endif
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_SampleGradientV1_float(Gradient Gradient, float Time, out float4 Out)
        {
            // convert to OkLab if we need perceptual color space.
            float3 color = lerp(Gradient.colors[0].rgb, LinearToOklab(Gradient.colors[0].rgb), Gradient.type == 2);
        
            [unroll]
            for (int c = 1; c < Gradient.colorsLength; c++)
            {
                float colorPos = saturate((Time - Gradient.colors[c - 1].w) / (Gradient.colors[c].w - Gradient.colors[c - 1].w)) * step(c, Gradient.colorsLength - 1);
                float3 color2 = lerp(Gradient.colors[c].rgb, LinearToOklab(Gradient.colors[c].rgb), Gradient.type == 2);
                color = lerp(color, color2, lerp(colorPos, step(0.01, colorPos), Gradient.type % 2)); // grad.type == 1 is fixed, 0 and 2 are blends.
            }
            color = lerp(color, OklabToLinear(color), Gradient.type == 2);
        
        #ifdef UNITY_COLORSPACE_GAMMA
            color = LinearToSRGB(color);
        #endif
        
            float alpha = Gradient.alphas[0].x;
            [unroll]
            for (int a = 1; a < Gradient.alphasLength; a++)
            {
                float alphaPos = saturate((Time - Gradient.alphas[a - 1].y) / (Gradient.alphas[a].y - Gradient.alphas[a - 1].y)) * step(a, Gradient.alphasLength - 1);
                alpha = lerp(alpha, Gradient.alphas[a].x, lerp(alphaPos, step(0.01, alphaPos), Gradient.type % 2));
            }
        
            Out = float4(color, alpha);
        }
        
        void Unity_ViewVectorWorld_float(out float3 Out, float3 WorldSpacePosition)
        {
            Out = _WorldSpaceCameraPos.xyz - GetAbsolutePositionWS(WorldSpacePosition);
            if(!IsPerspectiveProjection())
            {
                Out = GetViewForwardDir() * dot(Out, GetViewForwardDir());
            }
        }
        
        void Unity_Reflection_float3(float3 In, float3 Normal, out float3 Out)
        {
            Out = reflect(In, Normal);
        }
        
        void Unity_Normalize_float3(float3 In, out float3 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_Blend_Multiply_float4(float4 Base, float4 Blend, out float4 Out, float Opacity)
        {
            Out = Base * Blend;
            Out = lerp(Base, Out, Opacity);
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Blend_Lighten_float4(float4 Base, float4 Blend, out float4 Out, float Opacity)
        {
            Out = max(Blend, Base);
            Out = lerp(Base, Out, Opacity);
        }
        
        void Unity_Saturate_float4(float4 In, out float4 Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Blend_Multiply_float3(float3 Base, float3 Blend, out float3 Out, float Opacity)
        {
            Out = Base * Blend;
            Out = lerp(Base, Out, Opacity);
        }
        
        void Unity_Fog_float(out float4 Color, out float Density, float3 Position)
        {
            SHADERGRAPH_FOG(Position, Color, Density);
        }
        
        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Dither_float(float In, float4 ScreenPosition, out float Out)
        {
            float2 uv = ScreenPosition.xy * _ScreenParams.xy;
            float DITHER_THRESHOLDS[16] =
            {
                1.0 / 17.0,  9.0 / 17.0,  3.0 / 17.0, 11.0 / 17.0,
                13.0 / 17.0,  5.0 / 17.0, 15.0 / 17.0,  7.0 / 17.0,
                4.0 / 17.0, 12.0 / 17.0,  2.0 / 17.0, 10.0 / 17.0,
                16.0 / 17.0,  8.0 / 17.0, 14.0 / 17.0,  6.0 / 17.0
            };
            uint index = (uint(uv.x) % 4) * 4 + uint(uv.y) % 4;
            Out = In - DITHER_THRESHOLDS[index];
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_c86def888f50468da53261517e29b15b_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_Emm);
            float2 _Property_65d6841d202a428882e5ac3f296bb8bd_Out_0_Vector2 = _TexAnim;
            float2 _TilingAndOffset_69ea1c8ad59c456f87e25422ad5fc046_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), _Property_65d6841d202a428882e5ac3f296bb8bd_Out_0_Vector2, _TilingAndOffset_69ea1c8ad59c456f87e25422ad5fc046_Out_3_Vector2);
            float4 _SampleTexture2D_f228ab5ff8c34398ae216c2cdf5c5381_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_c86def888f50468da53261517e29b15b_Out_0_Texture2D.tex, _Property_c86def888f50468da53261517e29b15b_Out_0_Texture2D.samplerstate, _Property_c86def888f50468da53261517e29b15b_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_69ea1c8ad59c456f87e25422ad5fc046_Out_3_Vector2) );
            float _SampleTexture2D_f228ab5ff8c34398ae216c2cdf5c5381_R_4_Float = _SampleTexture2D_f228ab5ff8c34398ae216c2cdf5c5381_RGBA_0_Vector4.r;
            float _SampleTexture2D_f228ab5ff8c34398ae216c2cdf5c5381_G_5_Float = _SampleTexture2D_f228ab5ff8c34398ae216c2cdf5c5381_RGBA_0_Vector4.g;
            float _SampleTexture2D_f228ab5ff8c34398ae216c2cdf5c5381_B_6_Float = _SampleTexture2D_f228ab5ff8c34398ae216c2cdf5c5381_RGBA_0_Vector4.b;
            float _SampleTexture2D_f228ab5ff8c34398ae216c2cdf5c5381_A_7_Float = _SampleTexture2D_f228ab5ff8c34398ae216c2cdf5c5381_RGBA_0_Vector4.a;
            float _Property_6b2d45808f5240cabd9c66bb79a20cbb_Out_0_Float = _Emmission;
            float _Property_6308d0aa301a4294b75dd7b0b1f0438b_Out_0_Float = _Mirror;
            Bindings_LinearTime_f5a6b970195e54e43a218b75fe1986be_float _LinearTime_0c0d453673314091967795f2c08fb12a;
            _LinearTime_0c0d453673314091967795f2c08fb12a.TimeParameters = IN.TimeParameters;
            float _LinearTime_0c0d453673314091967795f2c08fb12a_Loop_1_Float;
            float _LinearTime_0c0d453673314091967795f2c08fb12a_Mirror_2_Float;
            float _LinearTime_0c0d453673314091967795f2c08fb12a_Switch_3_Float;
            SG_LinearTime_f5a6b970195e54e43a218b75fe1986be_float(float(0), false, _Property_6308d0aa301a4294b75dd7b0b1f0438b_Out_0_Float, _LinearTime_0c0d453673314091967795f2c08fb12a, _LinearTime_0c0d453673314091967795f2c08fb12a_Loop_1_Float, _LinearTime_0c0d453673314091967795f2c08fb12a_Mirror_2_Float, _LinearTime_0c0d453673314091967795f2c08fb12a_Switch_3_Float);
            float2 _Property_0e6aafc8348449cfb6bdd83cea8b7c8d_Out_0_Vector2 = _MirrorMinMax;
            float _Remap_95d761278d8d42eb9882d3949fc1ab64_Out_3_Float;
            Unity_Remap_float(_LinearTime_0c0d453673314091967795f2c08fb12a_Mirror_2_Float, float2 (0, 1), _Property_0e6aafc8348449cfb6bdd83cea8b7c8d_Out_0_Vector2, _Remap_95d761278d8d42eb9882d3949fc1ab64_Out_3_Float);
            float _Multiply_8c2375418d934e84bf18321234d0d558_Out_2_Float;
            Unity_Multiply_float_float(_Property_6b2d45808f5240cabd9c66bb79a20cbb_Out_0_Float, _Remap_95d761278d8d42eb9882d3949fc1ab64_Out_3_Float, _Multiply_8c2375418d934e84bf18321234d0d558_Out_2_Float);
            float4 _Multiply_4282f5f6c0f94fed90f977175e11484c_Out_2_Vector4;
            Unity_Multiply_float4_float4(_SampleTexture2D_f228ab5ff8c34398ae216c2cdf5c5381_RGBA_0_Vector4, (_Multiply_8c2375418d934e84bf18321234d0d558_Out_2_Float.xxxx), _Multiply_4282f5f6c0f94fed90f977175e11484c_Out_2_Vector4);
            float4 _Property_246858d0d55d42238bf1ec9c057d5744_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(_EmmissionColor) : _EmmissionColor;
            float4 _Add_56137f2997d74c158d81683bcc0a9be7_Out_2_Vector4;
            Unity_Add_float4(_Multiply_4282f5f6c0f94fed90f977175e11484c_Out_2_Vector4, _Property_246858d0d55d42238bf1ec9c057d5744_Out_0_Vector4, _Add_56137f2997d74c158d81683bcc0a9be7_Out_2_Vector4);
            Bindings_AdditionalLights_f831f4743ad6aab44842def2f21aa4bd_float _AdditionalLights_f7ba0a1a7bb0474c8ebf3175e74ab453;
            _AdditionalLights_f7ba0a1a7bb0474c8ebf3175e74ab453.WorldSpaceNormal = IN.WorldSpaceNormal;
            _AdditionalLights_f7ba0a1a7bb0474c8ebf3175e74ab453.WorldSpaceViewDirection = IN.WorldSpaceViewDirection;
            _AdditionalLights_f7ba0a1a7bb0474c8ebf3175e74ab453.WorldSpacePosition = IN.WorldSpacePosition;
            float3 _AdditionalLights_f7ba0a1a7bb0474c8ebf3175e74ab453_Diffuse_1_Vector3;
            float3 _AdditionalLights_f7ba0a1a7bb0474c8ebf3175e74ab453_Specular_2_Vector3;
            SG_AdditionalLights_f831f4743ad6aab44842def2f21aa4bd_float(float3 (0, 0, 0), float(0), float3 (0, 0, 0), false, half4 (1, 1, 1, 1), _AdditionalLights_f7ba0a1a7bb0474c8ebf3175e74ab453, _AdditionalLights_f7ba0a1a7bb0474c8ebf3175e74ab453_Diffuse_1_Vector3, _AdditionalLights_f7ba0a1a7bb0474c8ebf3175e74ab453_Specular_2_Vector3);
            float3 _Saturate_500b4986a1004f658ed406f4b136ae05_Out_1_Vector3;
            Unity_Saturate_float3(_AdditionalLights_f7ba0a1a7bb0474c8ebf3175e74ab453_Diffuse_1_Vector3, _Saturate_500b4986a1004f658ed406f4b136ae05_Out_1_Vector3);
            float _FresnelEffect_9d39d09f94064143856846232a443956_Out_3_Float;
            Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, float(2), _FresnelEffect_9d39d09f94064143856846232a443956_Out_3_Float);
            float _Step_8d8a255ef75049eab220d10acff0d516_Out_2_Float;
            Unity_Step_float(float(0.5), _FresnelEffect_9d39d09f94064143856846232a443956_Out_3_Float, _Step_8d8a255ef75049eab220d10acff0d516_Out_2_Float);
            float3 _Vector3_773e48da142642c49979a2c6c6772eea_Out_0_Vector3 = float3(float(0), float(1), float(0));
            float _DotProduct_a681e669c71e4371b9e3de7face5cb13_Out_2_Float;
            Unity_DotProduct_float3(_Vector3_773e48da142642c49979a2c6c6772eea_Out_0_Vector3, IN.WorldSpaceNormal, _DotProduct_a681e669c71e4371b9e3de7face5cb13_Out_2_Float);
            float _Multiply_e4ac6dfbd85249389c17e38e9fa2d0dc_Out_2_Float;
            Unity_Multiply_float_float(_Step_8d8a255ef75049eab220d10acff0d516_Out_2_Float, _DotProduct_a681e669c71e4371b9e3de7face5cb13_Out_2_Float, _Multiply_e4ac6dfbd85249389c17e38e9fa2d0dc_Out_2_Float);
            float _Swizzle_93b43cdeb64f4e5899b2cb51ddd10c3f_Out_1_Float = IN.VertexColor.y;
            float _Multiply_c5d0075d33cb495c91372c26d044f8b1_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_e4ac6dfbd85249389c17e38e9fa2d0dc_Out_2_Float, _Swizzle_93b43cdeb64f4e5899b2cb51ddd10c3f_Out_1_Float, _Multiply_c5d0075d33cb495c91372c26d044f8b1_Out_2_Float);
            float _Property_8e6ac123d25e425d8002501d3e1a0a70_Out_0_Float = _Shine;
            float _Multiply_99a19269e30e4d54ba01ce66f389ae77_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_c5d0075d33cb495c91372c26d044f8b1_Out_2_Float, _Property_8e6ac123d25e425d8002501d3e1a0a70_Out_0_Float, _Multiply_99a19269e30e4d54ba01ce66f389ae77_Out_2_Float);
            float _Saturate_ca8ea4b18af846989ff5ee776b6d5175_Out_1_Float;
            Unity_Saturate_float(_Multiply_99a19269e30e4d54ba01ce66f389ae77_Out_2_Float, _Saturate_ca8ea4b18af846989ff5ee776b6d5175_Out_1_Float);
            float3 _Add_b15089f0c3274152b37f3f600120bd37_Out_2_Vector3;
            Unity_Add_float3(_Saturate_500b4986a1004f658ed406f4b136ae05_Out_1_Vector3, (_Saturate_ca8ea4b18af846989ff5ee776b6d5175_Out_1_Float.xxx), _Add_b15089f0c3274152b37f3f600120bd37_Out_2_Vector3);
            float3 _Add_e2402a4838c74f4c9e4f2d5aee29a960_Out_2_Vector3;
            Unity_Add_float3((_Add_56137f2997d74c158d81683bcc0a9be7_Out_2_Vector4.xyz), _Add_b15089f0c3274152b37f3f600120bd37_Out_2_Vector3, _Add_e2402a4838c74f4c9e4f2d5aee29a960_Out_2_Vector3);
            float3 _Saturate_94c61a8f72fd4000abc09e9895627b0f_Out_1_Vector3;
            Unity_Saturate_float3(IN.WorldSpacePosition, _Saturate_94c61a8f72fd4000abc09e9895627b0f_Out_1_Vector3);
            float _Split_1d40da441edd4b06bc533cced3472604_R_1_Float = _Saturate_94c61a8f72fd4000abc09e9895627b0f_Out_1_Vector3[0];
            float _Split_1d40da441edd4b06bc533cced3472604_G_2_Float = _Saturate_94c61a8f72fd4000abc09e9895627b0f_Out_1_Vector3[1];
            float _Split_1d40da441edd4b06bc533cced3472604_B_3_Float = _Saturate_94c61a8f72fd4000abc09e9895627b0f_Out_1_Vector3[2];
            float _Split_1d40da441edd4b06bc533cced3472604_A_4_Float = 0;
            float2 _Property_1f9dc875a83c49e08aa354d6730a4c0b_Out_0_Vector2 = _GroundLuminance;
            float _Remap_528359c0024147e2b4646d39dc1b6dc4_Out_3_Float;
            Unity_Remap_float(_Split_1d40da441edd4b06bc533cced3472604_G_2_Float, float2 (0, 1), _Property_1f9dc875a83c49e08aa354d6730a4c0b_Out_0_Vector2, _Remap_528359c0024147e2b4646d39dc1b6dc4_Out_3_Float);
            float3 _MainLightDirection_7e9bab457bca463187a1bc5d49bfcfd3_Direction_0_Vector3;
            MainLightDirection_float(_MainLightDirection_7e9bab457bca463187a1bc5d49bfcfd3_Direction_0_Vector3);
            float _DotProduct_dfb9ca84ad6340d9890997ebbc7cd0f9_Out_2_Float;
            Unity_DotProduct_float3(IN.WorldSpaceNormal, _MainLightDirection_7e9bab457bca463187a1bc5d49bfcfd3_Direction_0_Vector3, _DotProduct_dfb9ca84ad6340d9890997ebbc7cd0f9_Out_2_Float);
            float _Saturate_56901fbb3768470d809e42210556c54f_Out_1_Float;
            Unity_Saturate_float(_DotProduct_dfb9ca84ad6340d9890997ebbc7cd0f9_Out_2_Float, _Saturate_56901fbb3768470d809e42210556c54f_Out_1_Float);
            float _OneMinus_f4e8accb4c804175b1df3b607c99314b_Out_1_Float;
            Unity_OneMinus_float(_Saturate_56901fbb3768470d809e42210556c54f_Out_1_Float, _OneMinus_f4e8accb4c804175b1df3b607c99314b_Out_1_Float);
            float _Add_c1cd98f83c52418aaf8acf3fefe6db27_Out_2_Float;
            Unity_Add_float(_OneMinus_f4e8accb4c804175b1df3b607c99314b_Out_1_Float, _SampleTexture2D_f228ab5ff8c34398ae216c2cdf5c5381_R_4_Float, _Add_c1cd98f83c52418aaf8acf3fefe6db27_Out_2_Float);
            float _Saturate_8673d8963a004997a1a326ecf975622c_Out_1_Float;
            Unity_Saturate_float(_Add_c1cd98f83c52418aaf8acf3fefe6db27_Out_2_Float, _Saturate_8673d8963a004997a1a326ecf975622c_Out_1_Float);
            float _Multiply_db40bccfff6245de97668657ea156aff_Out_2_Float;
            Unity_Multiply_float_float(_Remap_528359c0024147e2b4646d39dc1b6dc4_Out_3_Float, _Saturate_8673d8963a004997a1a326ecf975622c_Out_1_Float, _Multiply_db40bccfff6245de97668657ea156aff_Out_2_Float);
            float4 _SampleGradient_7134b5d3664d4b6bb82e5019d5c9a2ec_Out_2_Vector4;
            Unity_SampleGradientV1_float(NewGradient(0, 2, 2, float4(0.274028, 0.3241256, 0.8652291, 0),float4(1, 0.999249, 0.8881401, 1),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0), float2(1, 0),float2(1, 1),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0)), _Multiply_db40bccfff6245de97668657ea156aff_Out_2_Float, _SampleGradient_7134b5d3664d4b6bb82e5019d5c9a2ec_Out_2_Vector4);
            float _Property_74c1e8d12f27445d8eac46fbe6b87149_Out_0_Boolean = _Metallic;
            UnityTexture2D _Property_5e98a959b1984fb284818333ed194c15_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_MainTex);
            float4 _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_5e98a959b1984fb284818333ed194c15_Out_0_Texture2D.tex, _Property_5e98a959b1984fb284818333ed194c15_Out_0_Texture2D.samplerstate, _Property_5e98a959b1984fb284818333ed194c15_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_69ea1c8ad59c456f87e25422ad5fc046_Out_3_Vector2) );
            float _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_R_4_Float = _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_RGBA_0_Vector4.r;
            float _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_G_5_Float = _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_RGBA_0_Vector4.g;
            float _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_B_6_Float = _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_RGBA_0_Vector4.b;
            float _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_A_7_Float = _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_RGBA_0_Vector4.a;
            float3 _ViewVector_eb016290adcb40848f61270bbd53aa26_Out_0_Vector3;
            Unity_ViewVectorWorld_float(_ViewVector_eb016290adcb40848f61270bbd53aa26_Out_0_Vector3, IN.WorldSpacePosition);
            float3 _Reflection_d17e4b1e5c9340e9bb7009776b6e83c4_Out_2_Vector3;
            Unity_Reflection_float3(_ViewVector_eb016290adcb40848f61270bbd53aa26_Out_0_Vector3, IN.WorldSpaceNormal, _Reflection_d17e4b1e5c9340e9bb7009776b6e83c4_Out_2_Vector3);
            float3 _Normalize_abebc2e64f6c4ab7bea5cf425fe4772c_Out_1_Vector3;
            Unity_Normalize_float3(_Reflection_d17e4b1e5c9340e9bb7009776b6e83c4_Out_2_Vector3, _Normalize_abebc2e64f6c4ab7bea5cf425fe4772c_Out_1_Vector3);
            float4 _SampleGradient_550c2767695448f89a06be50b562e027_Out_2_Vector4;
            Unity_SampleGradientV1_float(NewGradient(1, 4, 2, float4(0.1873314, 0.4300665, 1, 0.2159609),float4(0.1698112, 0.1698112, 0.1698112, 0.330251),float4(0, 0, 0, 0.5319295),float4(1, 1, 1, 0.7773098),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0), float2(1, 0),float2(1, 1),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0)), (_Normalize_abebc2e64f6c4ab7bea5cf425fe4772c_Out_1_Vector3).x, _SampleGradient_550c2767695448f89a06be50b562e027_Out_2_Vector4);
            float _Split_c9a6e724099c4d45a556534434f339e4_R_1_Float = IN.VertexColor[0];
            float _Split_c9a6e724099c4d45a556534434f339e4_G_2_Float = IN.VertexColor[1];
            float _Split_c9a6e724099c4d45a556534434f339e4_B_3_Float = IN.VertexColor[2];
            float _Split_c9a6e724099c4d45a556534434f339e4_A_4_Float = IN.VertexColor[3];
            float4 _Blend_e29b181cee344b3783abacc432bbd9eb_Out_2_Vector4;
            Unity_Blend_Multiply_float4(_SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_RGBA_0_Vector4, _SampleGradient_550c2767695448f89a06be50b562e027_Out_2_Vector4, _Blend_e29b181cee344b3783abacc432bbd9eb_Out_2_Vector4, _Split_c9a6e724099c4d45a556534434f339e4_R_1_Float);
            float4 _Branch_3a8072394c3744ec80c7b9d1d982c2e5_Out_3_Vector4;
            Unity_Branch_float4(_Property_74c1e8d12f27445d8eac46fbe6b87149_Out_0_Boolean, _Blend_e29b181cee344b3783abacc432bbd9eb_Out_2_Vector4, _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_RGBA_0_Vector4, _Branch_3a8072394c3744ec80c7b9d1d982c2e5_Out_3_Vector4);
            float3 _Reflection_22756abea90642b19aba6daae7644399_Out_2_Vector3;
            Unity_Reflection_float3(float3(0, -1, 0), IN.WorldSpaceNormal, _Reflection_22756abea90642b19aba6daae7644399_Out_2_Vector3);
            float _DotProduct_46718801ec8a4870ac7948422914faae_Out_2_Float;
            Unity_DotProduct_float3(_Reflection_22756abea90642b19aba6daae7644399_Out_2_Vector3, IN.WorldSpaceViewDirection, _DotProduct_46718801ec8a4870ac7948422914faae_Out_2_Float);
            float _Property_21e80ac221db49b08eb93df484c0cb6c_Out_0_Float = _Specular;
            float _Power_1b487f1b19b04a9abab40af30d60d5af_Out_2_Float;
            Unity_Power_float(_DotProduct_46718801ec8a4870ac7948422914faae_Out_2_Float, _Property_21e80ac221db49b08eb93df484c0cb6c_Out_0_Float, _Power_1b487f1b19b04a9abab40af30d60d5af_Out_2_Float);
            float4 _SampleGradient_a7e23dfff8364ed2b7134c7218ed85c9_Out_2_Vector4;
            Unity_SampleGradientV1_float(NewGradient(0, 2, 2, float4(0, 0, 0, 0.6147097),float4(1, 1, 1, 0.885298),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0),float4(0, 0, 0, 0), float2(1, 0),float2(1, 1),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0),float2(0, 0)), _Power_1b487f1b19b04a9abab40af30d60d5af_Out_2_Float, _SampleGradient_a7e23dfff8364ed2b7134c7218ed85c9_Out_2_Vector4);
            float _Property_f1fa91262d794f96a966b81219fa28bc_Out_0_Float = _Fresnel;
            float _FresnelEffect_23a5335bf7634bd89dc14235dcdcf5cb_Out_3_Float;
            Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, _Property_f1fa91262d794f96a966b81219fa28bc_Out_0_Float, _FresnelEffect_23a5335bf7634bd89dc14235dcdcf5cb_Out_3_Float);
            float4 _Add_e396075f878a4d31ad51a91692d20b5e_Out_2_Vector4;
            Unity_Add_float4(_SampleGradient_a7e23dfff8364ed2b7134c7218ed85c9_Out_2_Vector4, (_FresnelEffect_23a5335bf7634bd89dc14235dcdcf5cb_Out_3_Float.xxxx), _Add_e396075f878a4d31ad51a91692d20b5e_Out_2_Vector4);
            float4 _Blend_a90d26108d0b490cab2116099bd912c9_Out_2_Vector4;
            Unity_Blend_Lighten_float4(_Branch_3a8072394c3744ec80c7b9d1d982c2e5_Out_3_Vector4, _Add_e396075f878a4d31ad51a91692d20b5e_Out_2_Vector4, _Blend_a90d26108d0b490cab2116099bd912c9_Out_2_Vector4, _Split_c9a6e724099c4d45a556534434f339e4_R_1_Float);
            float4 _Multiply_0f9b35d0e5a54476914e105943b27721_Out_2_Vector4;
            Unity_Multiply_float4_float4(_SampleGradient_7134b5d3664d4b6bb82e5019d5c9a2ec_Out_2_Vector4, _Blend_a90d26108d0b490cab2116099bd912c9_Out_2_Vector4, _Multiply_0f9b35d0e5a54476914e105943b27721_Out_2_Vector4);
            float4 _Saturate_25da087dd4294611b7bab8afd25c37a1_Out_1_Vector4;
            Unity_Saturate_float4(_Multiply_0f9b35d0e5a54476914e105943b27721_Out_2_Vector4, _Saturate_25da087dd4294611b7bab8afd25c37a1_Out_1_Vector4);
            float3 _Blend_1a96f82fa5be4657b7b755ec106468b4_Out_2_Vector3;
            Unity_Blend_Multiply_float3((_Saturate_25da087dd4294611b7bab8afd25c37a1_Out_1_Vector4.xyz), SHADERGRAPH_AMBIENT_SKY, _Blend_1a96f82fa5be4657b7b755ec106468b4_Out_2_Vector3, float(0.5));
            float3 _Add_75281d4ee5c04490b4e5596f8662e75a_Out_2_Vector3;
            Unity_Add_float3(_Add_e2402a4838c74f4c9e4f2d5aee29a960_Out_2_Vector3, _Blend_1a96f82fa5be4657b7b755ec106468b4_Out_2_Vector3, _Add_75281d4ee5c04490b4e5596f8662e75a_Out_2_Vector3);
            float4 _Fog_77cc8ad60dcb4798b7df7ec80cbed738_Color_0_Vector4;
            float _Fog_77cc8ad60dcb4798b7df7ec80cbed738_Density_1_Float;
            Unity_Fog_float(_Fog_77cc8ad60dcb4798b7df7ec80cbed738_Color_0_Vector4, _Fog_77cc8ad60dcb4798b7df7ec80cbed738_Density_1_Float, IN.ObjectSpacePosition);
            float3 _Lerp_b061b84311ab4e63a397f5b9e998a51f_Out_3_Vector3;
            Unity_Lerp_float3(_Add_75281d4ee5c04490b4e5596f8662e75a_Out_2_Vector3, (_Fog_77cc8ad60dcb4798b7df7ec80cbed738_Color_0_Vector4.xyz), (_Fog_77cc8ad60dcb4798b7df7ec80cbed738_Density_1_Float.xxx), _Lerp_b061b84311ab4e63a397f5b9e998a51f_Out_3_Vector3);
            float _Property_deeb68840c5141fa91e21ba643f3935d_Out_0_Float = _Fade;
            float _Multiply_236f6a1504d74e0eb5377f5d2cdbef74_Out_2_Float;
            Unity_Multiply_float_float(_Property_deeb68840c5141fa91e21ba643f3935d_Out_0_Float, _SampleTexture2D_f4fb208adab04f38ab9eceb88e8b208a_A_7_Float, _Multiply_236f6a1504d74e0eb5377f5d2cdbef74_Out_2_Float);
            float _Multiply_5fd8e20adcbe4b2aa10033e56ab81220_Out_2_Float;
            Unity_Multiply_float_float(_Split_c9a6e724099c4d45a556534434f339e4_A_4_Float, _Multiply_236f6a1504d74e0eb5377f5d2cdbef74_Out_2_Float, _Multiply_5fd8e20adcbe4b2aa10033e56ab81220_Out_2_Float);
            float _Property_2c28039c7f7941d48354c40c8c742248_Out_0_Float = _DitherAmount;
            float _Dither_4e2caf6e1eda413ca1c7cde0d8bee9b1_Out_2_Float;
            Unity_Dither_float(_Property_2c28039c7f7941d48354c40c8c742248_Out_0_Float, float4(IN.NDCPosition.xy, 0, 0), _Dither_4e2caf6e1eda413ca1c7cde0d8bee9b1_Out_2_Float);
            surface.BaseColor = _Lerp_b061b84311ab4e63a397f5b9e998a51f_Out_3_Vector3;
            surface.Alpha = _Multiply_5fd8e20adcbe4b2aa10033e56ab81220_Out_2_Float;
            surface.AlphaClipThreshold = _Dither_4e2caf6e1eda413ca1c7cde0d8bee9b1_Out_2_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        
        
            output.WorldSpaceViewDirection = GetWorldSpaceNormalizeViewDir(input.positionWS);
            output.WorldSpacePosition = input.positionWS;
            output.ObjectSpacePosition = TransformWorldToObject(input.positionWS);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.uv0 = input.texCoord0;
            output.VertexColor = input.color;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
    }
    CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
    CustomEditorForRenderPipeline "UnityEditor.ShaderGraphUnlitGUI" "UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset"
    FallBack "Hidden/Shader Graph/FallbackError"
}