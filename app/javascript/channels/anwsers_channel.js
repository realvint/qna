import { createConsumer } from "@rails/actioncable"

const consumer = createConsumer()

document.addEventListener("turbolinks:load", () => {
  const question = document.querySelector(".question")
  const questionId = question?.dataset.questionId

  if (questionId) {
    const subscription = consumer.subscriptions.create({ channel: "AnswersChannel", question_id: questionId }, {
      received(data) {

        if (gon.user_id !== data.user_id) {
          fetch(`/answers/${data.answer_id}`, {
            method: "GET",
            headers: {
              "Accept": "text/html"
            }
          })
            .then(response => response.text())
            .then(html => {
              const answers = document.querySelector(".answers")
              if (answers) {
                answers.insertAdjacentHTML("beforeend", html)
              }
            }
          )
        }
      }
    })

    window.addEventListener('beforeunload', () => {
      subscription.unsubscribe()
    })
  }
})

export default consumer
