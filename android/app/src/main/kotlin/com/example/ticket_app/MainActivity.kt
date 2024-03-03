package com.example.ticket_app

import android.util.Log
import com.google.firebase.firestore.FirebaseFirestore
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity(){
    override fun onDestroy() {
        super.onDestroy()
        Log.e("aaa", "onDestroy: ", )
    }


}
