import Head from "next/head";
import styles from "../styles/Home.module.css";
import { Item, Grid } from "semantic-ui-react";
import { firestore, fixDate } from "../lib/firebase";

export async function getServerSideProps(context) {
  const eventQuery = firestore
    .collectionGroup("events")
    .orderBy("createdAt", "desc");

  const events = (await eventQuery.get()).docs.map(fixDate);
  return {
    props: { events },
  };
}

export default function Home({ events }) {
  console.log(events);
  return (
    <Grid centered style={{ padding: "0% 3% 0% 3%" }}>
      <Grid.Row centered columns={1}>
        <Item.Group>
          {events.map((e) => {
            return (
              <Item.Content>
                <Item.Header>
                  {events.title} | {events.type}
                </Item.Header>
                <Item.Meta>{events.createdAt}</Item.Meta>
                <Item.Description>{events.description}</Item.Description>
                <Item.Extra>Topic: {events.topic}</Item.Extra>
              </Item.Content>
            );
          })}
        </Item.Group>
      </Grid.Row>
    </Grid>
  );
}
