using UnityEngine;

public class MoveEffectsHandler : MonoBehaviour
{
    Transform _trackingTarget;
    [SerializeField] bool _trackDefender;
    [Tooltip("Always track the defender")][SerializeField] bool _always = true;
    [Tooltip("position managers to initialize")][SerializeField] TweenPosition[] _position;
}