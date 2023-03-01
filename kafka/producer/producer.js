const { Kafka } = require("kafkajs");

const kafka = new Kafka({
  clientId: "my-app",
  brokers: ["broker:9092"],
});

const producer = kafka.producer();

async function runProducer() {
  // Producing
  await producer.connect();
  await producer.send({
    topic: "my-topic",
    messages: [{ value: "Hello KafkaJS user! hehe" }],
  });

  await producer.disconnect();
}

runProducer().catch(console.error);