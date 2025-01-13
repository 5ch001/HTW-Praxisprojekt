using UnityEngine;
using UnityEngine.SceneManagement;

public class PauseMenuScript : MonoBehaviour
{
    public GameObject pauseMenu; // Verweise auf das Panel im Editor

    private bool isPaused = false;

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Escape)) // ESC-Taste pausiert das Spiel
        {
            if (isPaused)
                ResumeGame();
            else
                PauseGame();
        }
    }

    public void ResumeGame()
    {
        pauseMenu.SetActive(false); // Deaktiviere das Pause-Menü
        Time.timeScale = 1f;       // Setzt das Spiel fort
        isPaused = false;
    }

    public void QuitGame()
    {
        Application.Quit(); // Beendet das Spiel
        Debug.Log("Spiel wird beendet..."); // Funktioniert nur im Build, nicht im Editor
    }

    public void RestartGame()
    {
        Time.timeScale = 1f; // Normalisiert die Spielgeschwindigkeit
        SceneManager.LoadScene(SceneManager.GetActiveScene().name); // Lädt die aktuelle Szene neu
    }

    private void PauseGame()
    {
        pauseMenu.SetActive(true); // Aktiviere das Pause-Menü
        Time.timeScale = 0f;      // Pausiert das Spiel
        isPaused = true;
    }
}
