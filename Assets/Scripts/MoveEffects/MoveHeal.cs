using UnityEngine;

[CreateAssetMenu(fileName = "MoveHeal", menuName = "Oly/Move/MoveEffectors/Heal")]
public class MoveHeal : MoveEffectBase
{
    public bool recoverDamage;
    [Range(1, 100)] public int _healPercent = 30;
    public GameObject _healFX;
    public bool UseDefaultEffect = true;
    [HideInInspector]
    public string _healFXRef;
    [HideInInspector]
    public string BundlePath;
    public override void PrintJson()
    {
        _healFXRef=_healFX.name;
        base.PrintJson();
    }
}