using System.Collections;
using UnityEngine;
[CreateAssetMenu(fileName = "ModLifeAttack_", menuName = "Unna/Modifier/LifeOnAttack")]
public class ModifierHurtOnAttack : ModifierSO
{
    [Range(0, 50)] public float percent;
    public bool Regen;
}