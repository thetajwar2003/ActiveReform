import firebase from "firebase/app";
import "firebase/auth";
import "firebase/firestore";
import "firebase/storage";

const firebaseConfig = {
  apiKey: "AIzaSyAWygXA4e3lmGdxKgv3mj-Jp9ak7cezSxY",
  authDomain: "activereform-ba45d.firebaseapp.com",
  projectId: "activereform-ba45d",
  storageBucket: "activereform-ba45d.appspot.com",
  messagingSenderId: "815786734039",
  appId: "1:815786734039:web:59cedd9f74b001dabc5b92",
  measurementId: "G-JXK1M315EF",
};

if (!firebase.apps.length) {
  firebase.initializeApp(firebaseConfig);
}

export const auth = firebase.auth();
export const googleAuthProvider = new firebase.auth.GoogleAuthProvider();

export const firestore = firebase.firestore();
export const storage = firebase.storage();

export const serverTimestamp = firebase.firestore.FieldValue.serverTimestamp;

export async function getUserWithUsername(username) {
  const usersRef = firestore.collection("users");
  const query = usersRef.where("username", "==", username).limit(1);
  const userDoc = (await query.get()).docs[0];
  console.log("Here", userDoc);
  return userDoc;
}

export function fixDate(doc) {
  const data = doc.data();
  return {
    ...data,
    createdAt: data.createdAt.toMillis(),
  };
}
