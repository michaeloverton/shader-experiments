Shader "Custom/BlackWhite" {
    Properties {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Color Multiply", Color) = (1,1,1,1)
        _Tweaker ("Tweaker", Range(0,10)) = 1
    }

    SubShader {

        Pass {
            CGPROGRAM
            #pragma vertex vp
            #pragma fragment fp

            #include "UnityCG.cginc"

            struct VertexData {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vp(VertexData v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
            float _Tweaker;
            float4 _Color;

            fixed4 fp(v2f i) : SV_Target {
                float4 col = tex2D( _MainTex, i.uv);
                float avg = (col.x + col.y + col.z) / 3;
                float4 white = float4(1,1,1,1);
                float4 preColor = white * (round(avg * _Tweaker) / _Tweaker);
                return preColor * _Color;
            }
            ENDCG
        }
    }
}