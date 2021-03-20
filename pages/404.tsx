import React from "react";
import { Header, Image, Grid, Segment } from "semantic-ui-react";

export default function Custom404() {
  return (
    <Grid centered columns={1} verticalAlign="middle">
      <Segment
        raised
        style={{
          padding: "5%",
          //   margin: "15% 0% 0% 0%",
          width: "100%",
        }}
        textAlign="center"
      >
        <Header as="h1">
          That page seems to not exist...
          <Header.Subheader>
            Press the image/button to take you home
          </Header.Subheader>
        </Header>
        <Image
          src="https://www.dolgroup.in/wp-content/uploads/2019/02/dolgroup-404.gif"
          verticalAlign="middle"
          href="/"
        />
      </Segment>
    </Grid>
  );
}
