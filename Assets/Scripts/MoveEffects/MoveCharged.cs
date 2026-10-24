using UnityEngine;

[CreateAssetMenu(fileName = "MoveCharged", menuName = "Oly/Move/MoveEffectors/Charged")]
public class MoveCharged : MoveEffectBase
{
    public int turnsToCharge = 1;
    public GameObject _chargeFX;
    public bool UseDefaultEffect=true;
    [HideInInspector]
    public string _chargeFXRef;
    [HideInInspector]
    public string BundlePath;
    public SecondaryEffect[] chargeEffect;
    public override void PrintJson()
    {
        _chargeFXRef=_chargeFX.name;
        base.PrintJson();
    }
}