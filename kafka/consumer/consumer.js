const { Kafka } = require("kafkajs");

const kafka = new Kafka({
  clientId: "my-app",
  brokers: ["broker:9092"],
});

const consumer = kafka.consumer({ groupId: "test-group" });

async function runConsumer() {
  // Consuming
  await consumer.connect();
  await consumer.subscribe({ topic: "my-topic", fromBeginning: true });

  await consumer.run({
    eachMessage: async ({ topic, partition, message }) => {
      console.log({
        value: message.value.toString(),
      });
    },
  });
}

runConsumer().catch(console.error);