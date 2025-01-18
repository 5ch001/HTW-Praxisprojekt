using System.Collections;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.SceneManagement;

public class VRTriggerButton : MonoBehaviour
{
    public float deadTime = 1.0f;
    private bool deadTimerActive = false;
    public UnityEvent onPressed, onReleased;

    private void OnTriggerEnter(Collider other)
    {
        if(other.tag == "Button") {
            onPressed?.Invoke();
            Debug.Log("Button pressed");
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if(other.tag == "Button" && !deadTimerActive) {
            onReleased?.Invoke();
            Debug.Log("Button released");
            StartCoroutine(DeadTimer());
            SceneManager.LoadScene("SpaceScene");
        }
    }
    IEnumerator DeadTimer()
    {
        deadTimerActive = true;
        yield return new WaitForSeconds(deadTime);
        deadTimerActive = false;
    }
}
