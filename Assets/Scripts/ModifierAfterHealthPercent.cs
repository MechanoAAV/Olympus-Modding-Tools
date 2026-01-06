using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
[CreateAssetMenu(fileName = "ModAfterHPPercent_", menuName = "Unna/Modifier/BoostOnHealthPercent")]
public class ModifierAfterHealthPercent : ModifierSO
{
    public StatBoost[] Boost;
    public StatBoost[] DefaultNerf;
    [Range(0, 1)] public float percent;
}