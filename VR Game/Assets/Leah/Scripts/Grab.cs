using UnityEngine;
using UnityEngine.XR.Interaction.Toolkit.Filtering; 
using UnityEngine.XR.Interaction.Toolkit.Interactables; 
using UnityEngine.XR.Interaction.Toolkit.Interactors; 


public class Grab : MonoBehaviour, IXRHoverFilter
{
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    
        public float maxInteractDistance = 0.1f;
        public bool canProcess => isActiveAndEnabled;  

        public bool Process(IXRHoverInteractor interactor, IXRHoverInteractable interactable)
        {
            bool canHover = true; 
            float dist = (interactor.transform.position - interactable.transform.position).magnitude;
            canHover = canHover && dist <= maxInteractDistance; 

            return canHover;
        }
 
}
