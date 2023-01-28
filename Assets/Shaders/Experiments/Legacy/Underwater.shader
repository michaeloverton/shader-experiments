Shader "Custom/Underwater" {
    Properties {
        _MainTex ("Main Texture", 2D) = "white" {}
        _Distortion ("Distortion", Range(0, 1)) = 0.1
        _Blur ("Blur", Range(0, 1)) = 0.1
        _Color ("Color", Color) = (1,1,1,1)
    }

    SubShader {
        // Tags {"Queue"="PostProcess" "RenderType"="PostProcess"}
        LOD 200

        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float _Distortion;
            float _Blur;
            float4 _Color;

            v2f vert (appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target {
                fixed4 col = tex2D(_MainTex, i.uv);
                // col.rgb += _Color.rgb;
                float2 distortedUv = i.uv + _Distortion * tex2D(_MainTex, i.uv).rgb;
                col.rgb += _Blur * tex2D(_MainTex, distortedUv).rgb;
                return col;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}