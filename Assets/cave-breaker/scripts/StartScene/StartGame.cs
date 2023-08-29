using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StartGame : MonoBehaviour
{
    [SerializeField]
    private TMPro.TMP_Text informationText = null;

    [SerializeField]
    private GameObject connectButton = null;

    [SerializeField]
    private NetworkManager networkManager = null;

    //[SerializeField]
    //private GameObject loadingAnimation = null;

    void changeInformationText(string text)
    {
        informationText.text = text;
    }

    void launchGame()
    {
        changeInformationText("Launching game");
        UnityEngine.SceneManagement.SceneManager.LoadScene("MainMenuScene");
    }

    public void loadGame()
    {
        changeInformationText("Welcome " + networkManager.db.displayName + " !");   
        launchGame();
    }

    public void displayInformationText()
    {
        informationText.gameObject.SetActive(true);
    }

    public void displayConnectButton()
    {
        connectButton.SetActive(true);
    }

    // Start is called before the first frame update
    void Start()
    {
        informationText.gameObject.SetActive(false);
        connectButton.SetActive(false);
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
