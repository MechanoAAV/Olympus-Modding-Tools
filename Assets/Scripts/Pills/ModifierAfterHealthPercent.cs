using UnityEngine;
[CreateAssetMenu(fileName = "PillAfterHPPercent_", menuName = "Oly/Pill/BoostOnHealthPercent")]
public class ModifierAfterHealthPercent : ModifierSO
{
    public StatBoost[] Boost;
    public StatBoost[] DefaultNerf;
    [Range(0, 1)] public float percent;
}