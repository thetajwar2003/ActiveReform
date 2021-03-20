import React from "react";
import { Card, Button } from "semantic-ui-react";
import Link from "next/link";
import { useRouter } from "next/router";

export default function CustomCard({ card }) {
  const router = useRouter();
  const { username } = router.query;
  return (
    <Link href={`${username}/${card.title}`}>
      <Card>
        <Card.Content>
          <Card.Header
            style={{
              height: "100px",
              backgroundImage: `url(https://cdn.pixabay.com/photo/2017/05/13/15/18/dear-2309801_1280.jpg)`,
              backgroundSize: "cover",
              color: "#ffffff",
              padding: "7%",
              borderRadius: "10px",
            }}
          >
            {card.title}
          </Card.Header>
          <Card.Meta textAlign="left" style={{ paddingTop: "1%" }}>
            {new Date(card.createdAt).toISOString().split("T")[0]}
          </Card.Meta>
        </Card.Content>
        <Card.Content extra textAlign="right">
          <Button color="red">Delete</Button>
        </Card.Content>
      </Card>
    </Link>
  );
}
