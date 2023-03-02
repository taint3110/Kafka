// producer.js

const kafka = require("kafka-node");

const client = new kafka.KafkaClient({ kafkaHost: "128.199.136.62:29092" });
const producer = new kafka.Producer(client);

const km = new kafka.KeyedMessage("key", "message");
const payloads = [
  { topic: "topic1", messages: "hi", partition: 0 },
  { topic: "topic2", messages: ["hello", "world", km] },
];
producer.on("ready", function () {
  producer.send(payloads, function (err, data) {
    console.log("🚀 ~ file: producer.js:40 ~ data:", data);
    console.log("🚀 ~ file: producer.js:40 ~ err:", err);
  });
});

producer.on("error", function (err) {
  console.log("🚀 ~ file: producer.js:48 ~ err:", err);
});