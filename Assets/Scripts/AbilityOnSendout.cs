using System.Collections;
using UnityEngine;

[CreateAssetMenu(fileName = "Ability_", menuName = "Oly/Ability/OnSendout")]
public class AbilityOnSendout : AbilityBase
{
    [SerializeField] AbilityDefeatEffect _effects;
    [SerializeField] bool _assistOnly;
}