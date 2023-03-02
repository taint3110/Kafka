// consumer.js
const kafka = require("kafka-node");

const client = new kafka.KafkaClient({ kafkaHost: "128.199.136.62:29092" });
const consumer = new kafka.Consumer(
  client,
  [{ topic: "topic1" }, { topic: "topic2" }]
  // { autoCommit: false }
);

consumer.on("message", function (message) {
  console.log(message);
});
consumer.on("error", function (err) {
  console.log("🚀 ~ file: consumer.js:19 ~ err:", err);
});
