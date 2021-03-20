import React from "react";
import { Card } from "semantic-ui-react";
import CustomCard from "./Card";

export default function EventsFeed({ events }) {
  return (
    <Card.Group itemsPerRow={4}>
      {events.map((singleCard: any) => {
        console.log(singleCard);
        return <CustomCard card={singleCard} />;
      })}
    </Card.Group>
  );
}
