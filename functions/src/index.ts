import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

export const updateFirestoreData = functions.https.onRequest(async (req, res) => {
    const firestore = admin.firestore();

    try {
        // Lấy tham số từ request nếu cần
        const dataToUpdate = req.body; // Giả sử dữ liệu cần cập nhật được truyền qua request body
        // Thực hiện các thao tác cập nhật dữ liệu trên Firestore
        const documentRef = firestore.collection('your_collection').doc('your_document');
        await documentRef.update(dataToUpdate);

        res.status(200).send('Data updated successfully.');
    } catch (error) {
        console.error('Error updating data:', error);
        res.status(500).send('Error updating data.');
    }
});
