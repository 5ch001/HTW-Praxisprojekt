using UnityEngine;
using UnityEngine.UI;


public class PlayerNameDisplay : MonoBehaviour
{
  public Text playerNameText;

   void Start()
    {
        UpdatePlayerName(); // Set initial name
    }

    public void UpdatePlayerName()
    {
        string playerName = PlayerPrefs.GetString("LastPlayerName", "Player-HTW0");
        playerNameText.text = playerName;
    }
}
