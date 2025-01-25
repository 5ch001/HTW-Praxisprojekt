using UnityEngine;
using UnityEngine.XR;

public class CookWithController : MonoBehaviour
{
    public CauldronCooking cauldronCooking; // Reference to your CauldronCooking script

    void Update()
    {
        // Get the right hand device
        InputDevice rightHandDevice = InputDevices.GetDeviceAtXRNode(XRNode.RightHand);

        // Check if the primary button (e.g., A on Meta Quest) is pressed
        if (rightHandDevice.TryGetFeatureValue(CommonUsages.primaryButton, out bool isPressed) && isPressed)
        {
            Debug.Log("Cook button pressed!");
            Cook();
        }
    }

    void Cook()
    {
        if (cauldronCooking != null)
        {
            // Call the cooking logic in CauldronCooking
            cauldronCooking.Cook();
        }
        else
        {
            Debug.LogError("CauldronCooking script is not assigned!");
        }
    }
}
