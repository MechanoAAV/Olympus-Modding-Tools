using PrimeTween;
using System.Collections.Generic;
using System.Linq;
using Unity.Cinemachine;
using UnityEngine;

public class ModelData : MonoBehaviour
{
    public CinemachineTargetGroup Target { get; private set; }
    public Animation Anim { get;private set; }
    public Transform DMG { get; set; }
    [SerializeField] public List<Transform> _beam=new();
     public List<Transform> Beam =>_beam;
    public Transform Wave { get;private set; }
    public List<Material> Materials { get; private set; } = new();

    //float randomTint;
    //readonly int tintID = Shader.PropertyToID("_RandomTint");
    readonly int emmID = Shader.PropertyToID("_EmmissionColor");
    private void Awake()
    {
        SetCamData();
        if(!Anim)
        Anim = GetComponentInChildren<Animation>();
        if(!Wave)
        Wave = FindTransform(transform, "b_wave");
        if (!Wave) Wave = transform;
        DMG = FindTransform(transform, "b_dmg");
        if (!DMG) DMG = transform;
        GetBeamSpawnPoints();
        GetMaterials();
    }
    public void SetCamData(float radius)
    {
        if (!Target)
            Target = GetComponentInChildren<CinemachineTargetGroup>();
        if (Target.Targets.Count == 0)
        {
            Target.AddMember(FindTransform(transform, "b_cam"), 1, radius);
        }
        else
        {
            if (!Target.Targets[0].Object)
                Target.Targets[0].Object = FindTransform(transform, "b_cam");
        }
    }
    public void SetCamData()
    {
        if (!Target)
        {
            Target = GetComponentInChildren<CinemachineTargetGroup>();
            if (Target.Targets.Count == 0) return;
            if (!Target.Targets[0].Object)
                Target.Targets[0].Object = FindTransform(transform, "b_cam");
        }
    }
    void GetMaterials()
    {
        if (Materials.Count == 0)
        {
            List<Material> materials = new();
            var rends = GetComponentsInChildren<Renderer>();
            for (int i = 0; i < rends.Length; i++)
            {
                materials.Clear();
                materials = new(rends[i].materials);
                rends[i].SetMaterials(materials);
                for (int j = 0; j < rends[i].materials.Length; j++)
                {
                    Materials.Add(rends[i].materials[j]);
                }
            }
        }
       
    }
    public void Flash()
    {
        for (int i = 0; i < Materials.Count; i++)
        {
            Tween.MaterialProperty(Materials[i], emmID, endValue: Color.black, startValue: emmissiveColor, duration: 1);
        }
    }
    void GetBeamSpawnPoints()
    {
        if (_beam.Count == 0||_beam.Any(x=>x==null))
        {
            _beam.Clear();
            var beam = FindTransform(transform, $"b_beam");
            if (beam)
                _beam.Add(beam);
            var beamL = FindTransform(transform, $"b_beam.L");
            if (beamL)
                _beam.Add(beamL);
            var beamR = FindTransform(transform, $"b_beam.R");
            if (beamR)
                _beam.Add(beamR);
            for (int i = 0; i < 6; i++)
            {
                beam = FindTransform(transform, $"b_beam{i}");
                if (beam)
                _beam.Add(beam);
            }
            if (_beam.Count == 0) _beam.Add(transform);
        }
    }
    [ColorUsage(hdr:true, showAlpha:false)]
    Color emmissiveColor = new(1,1,1,1.2f);
    public void RetreatFade()
    {
        for (int i = 0; i < Materials.Count; i++)
        {
            Tween.MaterialProperty(Materials[i], emmID, endValue: emmissiveColor, startValue: Color.black, duration: .5f);
        }
    }
    public void Glow(TweenSettings<Vector4> settings)
    {
        for (int i = 0; i < Materials.Count; i++)
        {
            Tween.MaterialProperty(Materials[i], emmID, settings);
        }
    }
public static Transform FindTransform(Transform parent, string name)
{
    if (parent.name.Contains(name)) return parent;
    foreach (Transform child in parent)
    {
        Transform result = FindTransform(child, name);
        if (result != null) return result;
    }
    return null;
}
}