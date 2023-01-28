Shader "Custom/Waves"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Color", Color) = (1,1,1,1)
        _Brightness ("Brightness", Range(0,1)) = 0.8
        _WaveAmp ("Wave Amplitude", Range(0,100)) = 1
        _WaveCount ("Wave Count", Integer) = 5
        _Speed ("Speed", Range(0,1)) = 0.1
        _DropOne ("Drop One Location", Vector) = (0,0,0,0)
        _DropOneOn ("Drop One On", Integer) = 1
        _DropTwo ("Drop Two Location", Vector) = (0,0,0,0)
        _DropTwoOn ("Drop Two On", Integer) = 1
        _DropThree ("Drop Three Location", Vector) = (0,0,0,0)
        _DropThreeOn ("Drop Three On", Integer) = 1
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

            #define TAU 6.28318530718

            struct MeshData
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct Interpolators
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 normal: TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _WaveAmp;
            float4 _Color;
            float _Brightness;
            int _WaveCount;
            float _Speed;
            float2 _DropOne;
            int _DropOneOn;
            float2 _DropTwo;
            int _DropTwoOn;
            float2 _DropThree;
            int _DropThreeOn;

            float GetWave( float2 uv ) {
                float2 distanceToDropOne = distance(uv, _DropOne.xy);
                float wave1 = cos( (distanceToDropOne - _Time.y * _Speed ) * TAU * _WaveCount ) * 0.5 + 0.5;
                wave1 *= (1 - distanceToDropOne) * _DropOneOn;

                float2 distanceToDropTwo = distance(uv, _DropTwo.xy);
                float wave2 = cos( (distanceToDropTwo - _Time.y * _Speed ) * TAU * _WaveCount ) * 0.5 + 0.5;
                wave2 *= (1 - distanceToDropTwo) * _DropTwoOn;

                float2 distanceToDropThree = distance(uv, _DropThree.xy);
                float wave3 = cos( (distanceToDropThree - _Time.y * _Speed ) * TAU * _WaveCount ) * 0.5 + 0.5;
                wave3 *= (1 - distanceToDropThree) * _DropThreeOn;

                return wave1 + wave2 + wave3;
            }

            Interpolators vert (MeshData v)
            {
                Interpolators o;

                v.vertex.y = GetWave(v.uv) * _WaveAmp;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                // o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv = v.uv;
                return o;
            }

            float InverseLerp( float a, float b, float v ) {
                return (v-a)/(b-a);
            }

            float4 frag (Interpolators i) : SV_Target
            {
                float remappedWave = GetWave(i.uv) *_Brightness + _Brightness;
                return remappedWave * _Color;
            }
            ENDCG
        }
    }
}
