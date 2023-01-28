Shader "Custom/ToonFresnel"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Gloss ("Gloss", Range(0,1)) = 1
        _Color ("Color", Color) = (1,1,1,1)
        _ShadowThreshold ("Shadow Threshold", Range(0,1)) = 0.5
        _SpecularThreshold ("Specular Threshold", Range(0,1)) = 0.5
        _FresnelColor ("Fresnel Color", Color) = (1,1,1,1)
        _FresnelPower ("Fresnel Power", Range(0.5,8.0)) = 3.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"
            #include "UnityLightingCommon.cginc"

            struct MeshData
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct Interpolators
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : TEXCOORD1;
                float3 wPos : TEXCOORD2;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Gloss;
            float4 _Color;
            float _ShadowThreshold;
            float _SpecularThreshold;
            float4 _FresnelColor;
            float _FresnelPower;

            Interpolators vert (MeshData v)
            {
                Interpolators o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.wPos = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }

            float4 frag (Interpolators i) : SV_Target
            {
                // Diffuse lighting.
                float3 N = normalize( i.normal );
                float3 L = _WorldSpaceLightPos0.xyz;
                float3 lambert = saturate( dot( N, L ) );
                lambert = step(_ShadowThreshold, lambert);
                float3 diffuseLight = lambert * _LightColor0.xyz;
                // return float4(diffuseLight.xyz, 1); // This is the end of simple diffuse.

                // Specular lighting.
                float3 V = normalize(_WorldSpaceCameraPos - i.wPos);
                float3 H = normalize(L + V);
                // float3 R = reflect(-L, N); // Used for simple Phong.

                float3 specularLight = saturate( dot( H, N ) ) * (lambert > 0);
                float specularExponent = exp2( _Gloss * 11 ) + 2;
                specularLight = pow( specularLight, specularExponent );
                specularLight = step(_SpecularThreshold, specularLight);
                specularLight *= _LightColor0.xyz;

                float rim = 1 - saturate( dot( V, N ) );
                float4 fresnel = float4(_FresnelColor.rgb * pow (rim, _FresnelPower), 1);
                // return c;

                return float4( diffuseLight * _Color + specularLight.xyz, 1) + fresnel;
            }
            ENDCG
        }

        // Pass to render object as a shadow caster
        Pass
        {
            Name "ShadowCaster"
            Tags { "LightMode" = "ShadowCaster" }
            LOD 80
            Cull [_Culling]
            Offset [_Offset], [_Offset]
            ZWrite [_ZWrite]
            ZTest [_ZTest]
           
            CGPROGRAM
            #pragma vertex vertShadow
            #pragma fragment fragShadow
            #pragma target 2.0
            #pragma multi_compile_shadowcaster

            struct v2fShadow {
                V2F_SHADOW_CASTER;
                UNITY_VERTEX_OUTPUT_STEREO
            };

            v2fShadow vertShadow( appdata_base v )
            {
                v2fShadow o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
                return o;
            }
        
            float4 fragShadow( v2fShadow i ) : SV_Target
            {
                SHADOW_CASTER_FRAGMENT(i)
            }

            ENDCG
        }
    }
}
