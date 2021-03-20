import React, { useState } from "react";
import {
  Modal,
  Popup,
  Button,
  Icon,
  Form,
  TextArea,
  Dropdown,
  Radio,
  Label,
  Grid,
} from "semantic-ui-react";
import { useRouter } from "next/router";

import { TOPIC_OPTIONS } from "../constants/topic";
import { auth, firestore, serverTimestamp } from "../lib/firebase";

// import CreateClass from "./CreateClass";

export default function EventModal(props) {
  const router = useRouter();

  const [open, setOpen] = useState(false);
  const [title, setTitle] = useState("");
  const [topic, setTopic] = useState("");
  const [type, setType] = useState("");
  const [tag, setTag] = useState("");

  const tags = [];

  const handleSubmit = async (e) => {
    e.preventDefault();
    const uid = auth.currentUser.uid;
    const ref = firestore
      .collection("users")
      .doc(uid)
      .collection("events")
      .doc(title);

    const data = {
      title,
      topic,
      type,
      createdAt: serverTimestamp(),
    };

    await ref.set(data).then(() => {
      router.reload();
    });
  };

  return (
    <Modal
      dimmer={false}
      closeOnDimmerClick={false}
      closeIcon={{
        style: { top: "1.0535rem", right: "1rem" },
        color: "black",
        name: "close",
      }}
      size="small"
      open={open}
      trigger={
        <Popup
          trigger={
            <Button
              style={{ background: "#ffffff", paddingBottom: "0%" }}
              onClick={() => setOpen(true)}
            >
              <Icon name="plus" circular />
            </Button>
          }
          content="Create An Event!"
          basic
          on="hover"
          position="bottom center"
          mouseEnterDelay={500}
          inverted
        />
      }
      onClose={() => setOpen(false)}
      onOpen={() => setOpen(true)}
      centered
    >
      <Modal.Header>Create An Event</Modal.Header>
      <Modal.Content>
        <Form onSubmit={handleSubmit}>
          <Form.Field required>
            <label>Topic</label>
            <Dropdown
              name="type"
              selection
              options={TOPIC_OPTIONS}
              placeholder="Topics"
              onChange={(e, { value }: any) => {
                e.preventDefault();
                setTopic(value);
              }}
            />
          </Form.Field>
          <Form.Field required>
            <label>Event Title</label>
            <input
              placeholder="Title"
              name="title"
              onChange={(e) => setTitle(e.target.value)}
            />
          </Form.Field>
          <Form.Field>
            <label>Type of Event</label>
            <Radio
              label="Fundraiser"
              name="type"
              value="Fundraiser"
              checked={type === "Fundraiser"}
              onChange={(e, { value }: any) => setType(value)}
            />
          </Form.Field>
          <Form.Field>
            <Radio
              label="Petition"
              name="type"
              value="Petition"
              checked={type === "Petition"}
              onChange={(e, { value }: any) => setType(value)}
            />
          </Form.Field>
          <Form.Field>
            <label>Event Description</label>
            <TextArea placeholder="Description" name="description" />
          </Form.Field>
          {/* <Form.Field required>
            <label>Hashtags</label>
            <div>
              {!(tags.length == 0) ? (
                tags.map((t) => {
                  return <Label>{t}</Label>;
                })
              ) : (
                <label>No Tags added</label>
              )}

              <Grid columns={2}>
                <Grid.Column width={15} style={{ paddingRight: "0%" }}>
                  <input
                    placeholder="Enter Hashtag"
                    onChange={(e) => setTag(e.target.value)}
                  />
                </Grid.Column>
                <Grid.Column width={1}>
                  <button
                    style={{ background: "#ffffff", padding: "0%" }}
                    onClick={() => {
                      console.log("h");
                      tags.push(tag);
                      setTag("");
                    }}
                  >
                    <Icon name="plus" size="large" />
                  </button>
                </Grid.Column>
              </Grid>
            </div>
          </Form.Field> */}

          <Button type="submit" style={{ marginTop: "2%" }} positive>
            Create Event!
          </Button>
        </Form>
      </Modal.Content>
    </Modal>
  );
}
