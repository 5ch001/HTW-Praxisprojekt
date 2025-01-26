using System.Collections;
using System.Collections.Generic;
using UnityEngine;

using UnityEngine.SceneManagement;

public class DoorInteraction : MonoBehaviour
{
    public string sceneToLoad = "Lobby"; // Scene name for the lobby
    public GameObject tooltipUI; // Optional: Tooltip to inform the player
    public Transform door; // Reference to the door object (for animations or effects)
    public AudioClip doorSound; // Optional: Sound effect for the door interaction
    private AudioSource audioSource;
    private bool isActivated = false; // To prevent multiple activations

    void Start()
    {
        if (tooltipUI != null)
            tooltipUI.SetActive(false); // Hide tooltip initially

        if (doorSound != null)
        {
            audioSource = gameObject.AddComponent<AudioSource>();
            audioSource.clip = doorSound;
        }
    }

    public void OnHoverEnter(UnityEngine.XR.Interaction.Toolkit.Interactors.XRBaseInteractor interactor)
    {
        // Show tooltip when the player hovers near the door
        if (tooltipUI != null)
            tooltipUI.SetActive(true);
    }

    public void OnHoverExit(UnityEngine.XR.Interaction.Toolkit.Interactors.XRBaseInteractor interactor)
    {
        // Hide tooltip when the player moves away from the door
        if (tooltipUI != null)
            tooltipUI.SetActive(false);
    }

    public void OnDoorClick(UnityEngine.XR.Interaction.Toolkit.Interactors.XRBaseInteractor interactor)
    {
        if (isActivated) return; // Prevent multiple clicks
        isActivated = true;

        // Play door sound if available
        if (audioSource != null)
            audioSource.Play();

        // Optional: Animate the door opening
        if (door != null)
        {
            StartCoroutine(OpenDoorAnimation());
        }

        // Load the next scene
        StartCoroutine(LoadSceneAfterDelay(1.5f)); // Adjust delay to match the door animation
    }

    private IEnumerator OpenDoorAnimation()
    {
        float duration = 1.0f; // Duration of the animation
        Quaternion initialRotation = door.rotation;
        Quaternion targetRotation = Quaternion.Euler(door.eulerAngles + new Vector3(0, 90, 0)); // Open by 90 degrees

        float elapsed = 0;
        while (elapsed < duration)
        {
            elapsed += Time.deltaTime;
            door.rotation = Quaternion.Slerp(initialRotation, targetRotation, elapsed / duration);
            yield return null;
        }

        door.rotation = targetRotation;
    }

    private IEnumerator LoadSceneAfterDelay(float delay)
    {
        yield return new WaitForSeconds(delay);
        SceneManager.LoadScene(sceneToLoad);
    }
}
