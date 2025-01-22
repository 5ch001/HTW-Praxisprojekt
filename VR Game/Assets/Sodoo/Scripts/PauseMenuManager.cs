using UnityEngine;
using UnityEngine.XR;
using UnityEngine.XR.Interaction.Toolkit;
using UnityEngine.UI;
public class PauseMenuManager : MonoBehaviour
{
    public GameObject pauseMenuCanvas; // Assign your Canvas in the Inspector
    private bool isPaused = false; // Tracks pause state

    void Update()
    {
        // Check for input from the left hand (e.g., X button)
        InputDevice leftHandDevice = InputDevices.GetDeviceAtXRNode(XRNode.LeftHand);

        if (leftHandDevice.TryGetFeatureValue(CommonUsages.primaryButton, out bool isXPressed) && isXPressed)
        {
            TogglePause(); // Toggle the pause state
        }
    }

    public void TogglePause()
    {
        isPaused = !isPaused;

        if (isPaused)
        {
            PauseGame();
        }
        else
        {
            ResumeGame();
        }
    }

    private void PauseGame()
    {
        pauseMenuCanvas.SetActive(true); // Show the pause menu
        Time.timeScale = 0f; // Freeze time
        Debug.Log("Game Paused");
    }

    private void ResumeGame()
    {
        pauseMenuCanvas.SetActive(false); // Hide the pause menu
        Time.timeScale = 1f; // Resume time
        Debug.Log("Game Resumed");
    }

    public void QuitGame()
    {
        Debug.Log("Quitting Game...");
        Application.Quit();
    }
}
