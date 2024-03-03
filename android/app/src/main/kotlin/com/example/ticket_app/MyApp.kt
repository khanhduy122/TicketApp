package com.example.ticket_app
import android.app.Application
import android.util.Log
import com.google.firebase.firestore.FirebaseFirestore

class MyApp : Application() {
    override fun onTerminate() {
        Log.e("aaa", "onTerminate: ", )
        super.onTerminate()
    }
}