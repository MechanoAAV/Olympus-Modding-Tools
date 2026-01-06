using UnityEngine;
using UnityEngine.Events;
public class ParticleAttackEvent : MonoBehaviour
{
    [SerializeField] UnityEvent AttackEvent;
    [SerializeField] MoveEffectsHandler _effectHandler;
    [SerializeField] ParticleHitTrigger _effectTrigger;
    public ParticleHitTrigger EffectTrigger=>_effectTrigger;
}
