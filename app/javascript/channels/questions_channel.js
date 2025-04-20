import { createConsumer } from "@rails/actioncable"

const consumer = createConsumer()

consumer.subscriptions.create("QuestionsChannel", {
  received(data) {
    const questionHTML = data.html
    const questions = document.querySelector(".questions")
    if (questions) {
      questions.insertAdjacentHTML("afterbegin", questionHTML)
    }
  }
})

export default consumer
