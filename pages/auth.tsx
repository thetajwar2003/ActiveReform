import React, { useContext, useState, useCallback, useEffect } from "react";
import Link from "next/link";
import { useRouter } from "next/router";

import { Button, Form, Grid, Header, Icon, Segment } from "semantic-ui-react";
import { auth, firestore, googleAuthProvider } from "../lib/firebase";
import debounce from "lodash.debounce";
import { UserContext } from "../lib/context";

export default function AuthPage() {
  const { user, username } = useContext(UserContext);
  return (
    <Grid
      centered
      column={1}
      style={{
        padding: "0% 10% 0% 10%",
        margin: "15% 0% 20% 0%",
        width: "100%",
      }}
      verticalAlign="middle"
    >
      <Segment
        raised
        style={{
          padding: "10%",
          //   margin: "15% 0% 0% 0%",
          width: "50%",
        }}
        textAlign="center"
      >
        <main>
          {user ? (
            !username ? (
              <UsernameForm />
            ) : (
              <SignOutButton />
            )
          ) : (
            <SignInButton />
          )}
        </main>
      </Segment>
    </Grid>
  );
}

// sign in with google button
function SignInButton() {
  const signInWithGoogle = async () => {
    await auth.signInWithPopup(googleAuthProvider);
  };
  return (
    <Button color="google plus" onClick={signInWithGoogle}>
      <Icon name="google" />
      Sign In With Google
    </Button>
  );
}

// sign out
function SignOutButton() {
  return (
    <Button primary onClick={() => auth.signOut()}>
      Sign Out
    </Button>
  );
}

function UsernameForm() {
  const router = useRouter();

  const [formValue, setFormValue] = useState("");
  const [highSchool, setHighSchool] = useState("");
  const [isValid, setIsValid] = useState(false);
  const [loading, setLoading] = useState(false);

  const { user, username } = useContext(UserContext);

  useEffect(() => {
    checkUsername(formValue);
  }, [formValue]);

  const checkUsername = useCallback(
    debounce(async (username) => {
      if (username.length >= 3) {
        const ref = firestore.doc(`usernames/${username}`);
        const { exists } = await ref.get();
        console.log("Firestore read executed");
        setIsValid(!exists);
        setLoading(false);
      }
    }, 500),
    []
  );

  const onChange = (e) => {
    const val = e.target.value.toLowerCase();
    const regex = /^(?=[a-zA-Z0-9._]{3,15}$)(?!.*[_.]{2})[^_.].*[^_.]$/;

    if (val.length < 3) {
      setFormValue(val);
      setLoading(false);
      setIsValid(false);
    }
    if (regex.test(val)) {
      setFormValue(val);
      setLoading(true);
      setIsValid(false);
    }
  };

  const onSubmit = async (e) => {
    e.preventDefault();

    const userDoc = firestore.doc(`users/${user.uid}`);
    const usernameDoc = firestore.doc(`usernames/${formValue}`);

    const batch = firestore.batch();
    batch.set(userDoc, {
      username: formValue,
      photoURL: user.photoURL,
      displayName: user.displayName,
      highSchool,
    });
    batch.set(usernameDoc, { uid: user.uid });

    await batch.commit().then(() => router.push("/"));
  };

  return (
    !username && (
      <>
        <Form onSubmit={onSubmit}>
          <Form.Field>
            <Header as="h2">Create a Username</Header>
            <input
              name="username"
              placeholder="Enter Username"
              value={formValue}
              onChange={onChange}
            />
            <UsernameMessage
              username={formValue}
              isValid={isValid}
              loading={loading}
            />
          </Form.Field>
          <Form.Field>
            <Header as="h2">Which Highschool Do You Go To</Header>
            <input
              name="username"
              placeholder="Enter Highschool"
              value={highSchool}
              onChange={(e) => setHighSchool(e.target.value)}
            />
          </Form.Field>

          <Button type="submit" positive disabled={!isValid}>
            Continue
          </Button>
        </Form>
      </>
    )
  );
}

function UsernameMessage({ username, isValid, loading }) {
  if (loading) {
    return <p>Checking...</p>;
  } else if (isValid) {
    return <p className="text-success">{username} is available!</p>;
  } else if (username && !isValid) {
    return <p className="text-danger">That username is taken!</p>;
  } else {
    return <p></p>;
  }
}
