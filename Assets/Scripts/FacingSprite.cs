using UnityEngine;

public class FacingSprite : MonoBehaviour
{
    Animator animator;
    Camera cam;
    private void Start()
    {
        animator = GetComponent<Animator>();
        cam = Camera.main;
    }
    // Update is called once per frame
    void Update()
    {
        if (animator && cam)
        {
            animator.SetFloat("Facing", Vector3.Dot(transform.forward, cam.transform.forward));
            animator.SetFloat("FacingSides", Vector3.Dot(transform.right, cam.transform.forward));
        }
    }
}