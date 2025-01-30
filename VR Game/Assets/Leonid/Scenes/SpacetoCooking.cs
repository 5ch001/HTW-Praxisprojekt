using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.XR.Interaction.Toolkit;

public class SpacetoCooking : MonoBehaviour
{
    public string sceneToLoad = "CookingScene"; // Set this to your correct scene name
    private bool isActivated = false;

    private void Start()
    {
        Debug.Log("DoorInteraction script loaded.");
    }

    public void OnDoorClick(SelectEnterEventArgs args)
    {
        if (isActivated) return;  // Prevents double activation
        isActivated = true;

        Debug.Log("✅ Door clicked! Attempting to load scene: " + sceneToLoad);

        // Load Scene
        SceneManager.LoadScene(sceneToLoad);
        SoundManager.Instance.PlayDoorSound();
        
    }
}

