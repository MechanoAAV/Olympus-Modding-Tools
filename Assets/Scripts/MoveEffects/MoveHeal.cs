using System.Collections;
using UnityEngine;
using UnityEngine.Localization;

[CreateAssetMenu(fileName = "MoveHeal", menuName = "Unna/Move/MoveEffectors/Heal")]
public class MoveHeal : MoveEffectBase
{
    public bool recoverDamage;
    [Range(1, 10)] public float _healPercent = 3;
    public GameObject _healFX;
    public bool UseDefaultEffect = true;
    [HideInInspector]
    public string _healFXRef;
    [HideInInspector]
    public string BundlePath;
    public LocalizedString _healMessage;
    public override void PrintJson()
    {
        _healFXRef=_healFX.name;
        base.PrintJson();
    }
}