package com.example.ticket_app
import android.app.Application
import android.util.Log
import com.google.firebase.firestore.FirebaseFirestore

class MyApp : Application() {
    override fun onTerminate() {
        FirebaseFirestore.getInstance().collection("Cinemas")
            .document("An Giang")
            .collection("Galaxy")
            .document("ChIJXzLHf9ZzCjERifaEdxV7owU")
            .collection("23-2-2024")
            .document("CUZ1RsCfegXi3qsz6uQZ")
            .collection("18:00 - 20:12 - room1")
            .document("A1")
            .update("status", 0, "booked", "")
        super.onTerminate()
    }
}