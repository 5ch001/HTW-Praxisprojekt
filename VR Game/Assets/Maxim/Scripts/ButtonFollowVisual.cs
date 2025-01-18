using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR.Interaction.Toolkit;
using UnityEngine.XR.Interaction.Toolkit.Interactables;
using UnityEngine.XR.Interaction.Toolkit.Interactors;
using UnityEngine.SceneManagement;

public class ButtonFollowVisual : MonoBehaviour
{
    public Transform visualTarget;
    public Vector3 localAxis;
    public float resetSpeed = 5;
    public float followAngleThreshold = 45;
    public float activationThreshold = 0.1f; // Threshold for activation
    private bool freeze = false;
    private Vector3 initialLocalPos;
    private Vector3 offset;
    private Transform pokeAttachTransform;
    private XRBaseInteractable interactable;
    private bool isFollowing = false;
    private bool isActivated = false;

    // Start is called before the first frame update
    void Start()
    {
        initialLocalPos = visualTarget.localPosition;

        interactable = GetComponent<XRBaseInteractable>();
        interactable.hoverEntered.AddListener(Follow);
        interactable.hoverExited.AddListener(Reset);
        interactable.selectEntered.AddListener(Freeze);
        interactable.selectEntered.AddListener(ChangeScene);
    }

    public void Follow(BaseInteractionEventArgs hover)
    {
        if(hover.interactorObject is XRDirectInteractor)
        {
            Debug.Log("Follow method called");
            isFollowing = true;

            pokeAttachTransform = hover.interactorObject.GetAttachTransform(interactable);
            offset = visualTarget.position - pokeAttachTransform.position;

            float pokeAngle = Vector3.Angle(offset, visualTarget.TransformDirection(localAxis));

            if(pokeAngle > followAngleThreshold)
            {
                isFollowing = false;
                freeze = true;
                Debug.Log("Poke angle exceeded threshold, freezing");
            }
        }
    }

    public void ChangeScene(BaseInteractionEventArgs args)
    {
        Debug.Log("ChangeScene method called");
        SceneManager.LoadScene("SpaceScene");
    }

    public void Reset(BaseInteractionEventArgs hover)
    {
        if(hover.interactorObject is XRDirectInteractor)
        {
            Debug.Log("Reset method called");
            isFollowing = false;
            freeze = false;
            isActivated = false;
        }
    }

    public void Freeze(BaseInteractionEventArgs hover)
    {
        if(hover.interactorObject is XRDirectInteractor)
        {
            Debug.Log("Freeze method called");
            freeze = true;
        }
    }

    // Update is called once per frame
    void Update()
    {
        if(freeze)
            return;

        if(isFollowing)
        {
            Vector3 localTargetPosition = visualTarget.InverseTransformPoint(pokeAttachTransform.position + offset);
            Vector3 constrainedLocalTargetPosition = Vector3.Project(localTargetPosition, localAxis);

            visualTarget.position = visualTarget.TransformPoint(constrainedLocalTargetPosition);

            // Check if the button is pushed down to the activation threshold
            if (!isActivated && Vector3.Distance(visualTarget.localPosition, initialLocalPos) > activationThreshold)
            {
                isActivated = true;
                Debug.Log("Button activated");
                ChangeScene(null); // Call ChangeScene method
            }
        }
        else
        {
            visualTarget.localPosition = Vector3.Lerp(visualTarget.localPosition, initialLocalPos, Time.deltaTime * resetSpeed);
        }
    }
}