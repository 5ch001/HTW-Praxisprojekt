using UnityEngine;
using UnityEngine.InputSystem;

public class LeftGripChange : MonoBehaviour
{

    Animator myAnimator;
    public InputActionReference gripInputActionReference;
    public InputActionReference triggerInputActionReference;
    private float gripValue;
    private float triggerValue;
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
     myAnimator = GetComponent<Animator>();   
    }

    // Update is called once per frame
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
