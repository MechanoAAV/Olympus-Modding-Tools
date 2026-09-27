using System.Collections;
using UnityEngine;
[CreateAssetMenu(fileName = "PillHP_", menuName = "Oly/Pill/HP")]
public class ModifierHurtOnAttack : ModifierSO
{
    [Range(0, 50)] public float percent;
    public bool Regen;
}