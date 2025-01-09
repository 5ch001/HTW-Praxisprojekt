using UnityEngine;

public class FadeIn : MonoBehaviour
{
    [SerializeField] Animator transitionAnim;

    // Start is called before the first frame update
    void Start()
    {
        transitionAnim.SetTrigger("Start");
    }

    void Update()
    {

    }
}