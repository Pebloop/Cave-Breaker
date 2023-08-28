using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using FirebaseWebGL.Scripts.FirebaseBridge;
using FirebaseWebGL.Examples.Utils;
using FirebaseWebGL.Scripts.Objects;

public class NetworkManager : MonoBehaviour
{

    public Database db;

    [SerializeField]
    private StartGame startGame;

    // Start is called before the first frame update
    void Start()
    {
        if (Application.platform != RuntimePlatform.WebGLPlayer)
        {
            Debug.Log("The code is not running on a WebGL build; as such, the Javascript functions will not be recognized.");
            return;
        }
        FirebaseAuth.OnAuthStateChanged(gameObject.name, "DisplayUserInfo", "DisplayInfo");
        GetFromFirebase();
    }

    public void DisplayUserInfo(string user)
    {
        var parsedUser = StringSerializationAPI.Deserialize(typeof(FirebaseUser), user) as FirebaseUser;
        Debug.Log($"Email: {parsedUser.email}, UserId: {parsedUser.uid}, EmailVerified: {parsedUser.isEmailVerified}");
        startGame.displayInformationText();

    }

    public void DisplayInfo(string info)
    {
        Debug.Log(info);
        startGame.displayConnectButton();
    }

    public void SignedInCallback(string user)
    {
    }

    public void SignedInFallback(string info)
    {
    }


    public void GetFromFirebase()
    {
        Proyecto26.RestClient.Get<Database>("https://cave-breaker-77485578-default-rtdb.firebaseio.com/user.json").Then(response =>
        {
            db = response;
        }).Catch(err => Debug.Log(err.Message));
    }

    public void PostToFirebase()
    {
        Proyecto26.RestClient.Put<Database>("https://cave-breaker-77485578-default-rtdb.firebaseio.com/user.json", db).Then(response =>
        {
            Debug.Log("Successfully posted to Firebase");
        }).Catch(err => Debug.Log(err.Message));
    }

    public void ConnectWithGoogle()
    {
        FirebaseAuth.SignInWithGoogle(gameObject.name, "SignedInCallback", "SignedInFallback");
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
