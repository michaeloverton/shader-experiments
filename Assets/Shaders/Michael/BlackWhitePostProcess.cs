using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BlackWhitePostProcess : MonoBehaviour {
    public Shader bwShader;
    public Color colorMultiply;
    [Range(0, 10)]
    public float tweaker = 1.0f;
    private Material bwMat;
    
    void OnEnable() {
        bwMat = new Material(bwShader);
        bwMat.hideFlags = HideFlags.HideAndDontSave;
    }

    void OnRenderImage(RenderTexture source, RenderTexture destination) {
        // bwShader.SetFloat4(1,1,1,1);
        bwMat.SetColor("_Color", colorMultiply);
        bwMat.SetFloat("_Tweaker", tweaker);
        Graphics.Blit(source, destination, bwMat);
    }

    void OnDisable() {
        bwMat = null;
    }
}