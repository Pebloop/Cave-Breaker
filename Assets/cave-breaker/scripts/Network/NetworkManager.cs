using UnityEngine;
using FirebaseWebGL.Scripts.FirebaseBridge;
using FirebaseWebGL.Examples.Utils;
using FirebaseWebGL.Scripts.Objects;

public class NetworkManager : MonoBehaviour
{
    [SerializeField]
    public Database db;

    [SerializeField]
    private StartGame startGame;

    // Start is called before the first frame update
    void Start()
    {
        if (Application.platform == RuntimePlatform.WebGLPlayer)
        {
            FirebaseAuth.OnAuthStateChanged(gameObject.name, "StartLoadingGame", "ConnexionError");
        } else if (Application.platform == RuntimePlatform.Android)
        {
            Debug.LogError("Android connexion not yet implemented.");
        } else if (Application.isEditor)
        {
            startGame.displayInformationText();
            startGame.loadGame();
        } else
        {
            Debug.LogError("Unimplemented platform.");
        }
        
    }

    /**
     * Execute after succesfull connxexion : retrieve the user data and load and launch game
     **/
    public void StartLoadingGame(string user)
    {
        var parsedUser = StringSerializationAPI.Deserialize(typeof(FirebaseUser), user) as FirebaseUser;
        db.userId = parsedUser.providerData[0].uid;
        GetFromFirebase();
        db.displayName = parsedUser.displayName;
        db.profilePicture = parsedUser.providerData[0].photoUrl;
        PostToFirebase();
        startGame.displayInformationText();
        startGame.loadGame();
    }

    /**
     * An error occured during the connexion attempt
     **/
    public void ConnexionError(string info)
    {
        Debug.Log(info);
        startGame.displayConnectButton();
    }

    /**
     * Callback for methods that do nothing 
     */
    public void CallBackDoNothing(string info)
    {
    }

    public void CallBackPrintInfo(string info)
    {
        Debug.Log(info);
    }


    public void GetFromFirebase()
    {
        FirebaseDatabase.GetJSON("users/" + db.userId, gameObject.name, "RetrieveDatabaseDatas", "CallBackDoNothing");
    }

    private void RetrieveDatabaseDatas(string data)
    {
        var parsedData = StringSerializationAPI.Deserialize(typeof(Database), data) as Database;
        db = parsedData;
    }

    public void PostToFirebase()
    {
        string dbSierialized = StringSerializationAPI.Serialize(typeof(Database), db);

        FirebaseDatabase.PostJSON(
            "users/" + db.userId,
            dbSierialized, gameObject.name, "CallBackDoNothing", "CallBackDoNothing"
            );
    }

    public void ConnectWithGoogle()
    {
        FirebaseAuth.SignInWithGoogle(gameObject.name, "CallBackDoNothing", "CallBackDoNothing");
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
