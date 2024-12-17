using UnityEngine;
using UnityEngine.InputSystem;

public class LeftGripChange : MonoBehaviour
{

    Animator myAnimator;
    public InputActionReference gripInputActionReference;
    public InputActionReference triggerInputActionReference;
    private float gripValue;
    private float triggerValue;
    void Start()
    {
     myAnimator = GetComponent<Animator>();   
    }

    void Update()
    {
        AnimateGrip();
        AnimateTrigger();
    }

    private void AnimateGrip() {
        gripValue = gripInputActionReference.action.ReadValue<float>();
        myAnimator.SetFloat("Grip", gripValue);
    }
    private void AnimateTrigger() {
        triggerValue = triggerInputActionReference.action.ReadValue<float>();
        myAnimator.SetFloat("Trigger", triggerValue);
    }
}
