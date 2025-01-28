using System.Collections;
using System.Collections.Generic;
using UnityEngine;

using UnityEngine.SceneManagement;

public class DoorInteraction : MonoBehaviour
{
    public string sceneToLoad = "MarsScene"; 
    public GameObject tooltipUI; 
    public Transform door; // (for animations or effects)
    public AudioClip doorSound; // Sound effect 
    private AudioSource audioSource;
    private bool isActivated = false; 

    void Start()
    {
        if (tooltipUI != null)
            tooltipUI.SetActive(false); 

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
        if (isActivated) return; 
        isActivated = true;

        
        if (audioSource != null)
            audioSource.Play();

       
        if (door != null)
        {
            StartCoroutine(OpenDoorAnimation());
        }

        // Load the next scene
        StartCoroutine(LoadSceneAfterDelay(1.5f)); 
    }

    private IEnumerator OpenDoorAnimation()
    {
        float duration = 1.0f; 
        Quaternion initialRotation = door.rotation;
        Quaternion targetRotation = Quaternion.Euler(door.eulerAngles + new Vector3(0, 90, 0)); 

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
