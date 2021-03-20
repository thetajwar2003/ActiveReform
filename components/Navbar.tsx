import React, { useContext } from "react";
import { useRouter } from "next/router";
import Link from "next/link";
import { auth, googleAuthProvider, firestore } from "../lib/firebase";
import { Button, Menu, Image, Icon } from "semantic-ui-react";

import { UserContext } from "../lib/context";

export default function Navbar() {
  const router = useRouter();
  const { user, username } = useContext(UserContext);

  const lost = router.pathname === "/404";

  const signOut = () => {
    auth.signOut();
    router.push("/index", "/");
    router.reload();
  };

  return (
    <>
      <Menu>
        {!lost && user && username && (
          <>
            <Menu.Item position="right">
              <Button onClick={signOut}>Sign Out</Button>
            </Menu.Item>
            <Menu.Item>
              <Image
                href={`/${username}`}
                src={user.photoURL}
                circular
                size="mini"
              />
            </Menu.Item>
          </>
        )}
        {!lost && !user && (
          <>
            <Menu.Item position="right" style={{ padding: "1%" }}>
              <SignInButton />
            </Menu.Item>
            <Menu.Item>
              <Link href="/auth">
                <Button secondary>
                  <Icon name="sign in" /> Sign Up
                </Button>
              </Link>
            </Menu.Item>
          </>
        )}
        {lost && (
          <>
            <Menu.Item position="right">
              <Link href="/">
                <Button primary>Take Me Home, Country Roads</Button>
              </Link>
            </Menu.Item>
          </>
        )}
      </Menu>
    </>
  );
}

function SignInButton() {
  const router = useRouter();

  const signInWithGoogle = async () => {
    await auth.signInWithPopup(googleAuthProvider).then(async (res: any) => {
      const ref: any = firestore.doc(`users/${res.user.uid}`);
      const doc = await ref.get();

      if (doc.exists) {
        const link = doc.data().username;
        router.push("/");
      } else {
        router.push("/auth");
      }
    });
  };
  return (
    <Button color="google plus" onClick={signInWithGoogle}>
      <Icon name="google" /> Log In
    </Button>
  );
}
