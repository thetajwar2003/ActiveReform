import React from "react";
import {
  Image,
  Grid,
  Header,
  Advertisement,
  Progress,
  Form,
  Segment,
  Divider,
  Label,
} from "semantic-ui-react";
import { getUserWithUsername, fixDate } from "../../lib/firebase";

export async function getServerSideProps({ query }) {
  const { username, event } = query;
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
      .where("title", "==", event);

    events = (await eventRef.get()).docs.map(fixDate)[0];
  }

  return {
    props: { user, events },
  };
}

export default function EventPage({ user, events }) {
  console.log(events);
  return (
    <Grid centered style={{ padding: "0% 3% 0% 3%" }}>
      <Grid.Row>
        <Header as="h1">{events.title}</Header>
      </Grid.Row>
      <Grid.Row columns={2}>
        <Grid.Column>
          <Image
            src="https://cdn.pixabay.com/photo/2017/05/13/15/18/dear-2309801_1280.jpg"
            size="huge"
          />
          <Grid.Row style={{ padding: "3% 0% 3% 0%" }}>
            Type:<Label>{events.type}</Label>
            <br />
            <br />
            Topic:<Label>{events.topic}</Label>
          </Grid.Row>
          {events.description}
        </Grid.Column>
        <Grid.Column textAlign="left">
          <Grid.Row>
            <Progress percent={74} indicating />
          </Grid.Row>
          <Grid.Row>
            <Header as="h1" textAlign="center">
              50,944 have signed. Getting close to 75,000!
            </Header>
          </Grid.Row>
          <Grid.Row style={{ margin: "4%" }}>
            <Segment style={{ padding: "4%" }}>
              <Form>
                <Header as="h2" textAlign="center">
                  Sign the Petition!
                  <Divider />
                </Header>
                <Form.Field required>
                  <label>Full Name</label>
                  <input placeholder="Full Name" />
                </Form.Field>

                <Form.Field>
                  <label>Email</label>
                  <input placeholder="Email" />
                </Form.Field>
              </Form>
            </Segment>
          </Grid.Row>
        </Grid.Column>
      </Grid.Row>
    </Grid>
  );
}
