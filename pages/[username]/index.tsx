import React from "react";
import { Card, Grid, Header } from "semantic-ui-react";

import { getUserWithUsername, fixDate } from "../../lib/firebase";
import EventModal from "../../components/EventModal";
import EventsFeed from "../../components/EventsFeed";

export async function getServerSideProps({ query }) {
  const { username } = query;
  console.log("f", username);
  const userDoc = await getUserWithUsername(username);
  if (!userDoc) {
    return {
      notFound: true,
    };
  }

  var user = null;
  var events = null;

  if (userDoc) {
    user = userDoc.data();
    const eventRef = userDoc.ref
      .collection("events")
      .orderBy("createdAt", "desc");

    events = (await eventRef.get()).docs.map(fixDate);
  }

  return {
    props: { user, events },
  };
}

export default function UserPage({ user, events }) {
  //   console.log(events);
  return (
    <Grid centered style={{ padding: "0% 3% 0% 3%" }}>
      <Grid.Row centered columns={1}>
        <Grid.Column textAlign="right">
          <EventModal />
        </Grid.Column>
      </Grid.Row>
      <Grid.Row centered columns={1} textAlign="left">
        <Header as="h1">Your Petitions</Header>

        <EventsFeed events={events} />
      </Grid.Row>
    </Grid>
  );
}
