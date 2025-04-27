import { createConsumer } from "@rails/actioncable"

const consumer = createConsumer()

document.addEventListener("turbolinks:load", function () {
  const questionElement = document.querySelector(".question.my-3")
  const questionId = questionElement?.dataset.questionId

  if (questionId) {
    consumer.subscriptions.create("CommentsChannel", {
      connected() {
        this.perform("subscribed")
      },

      received(data) {
        if (gon.user_id !== data.user_id) {
          const commentableId = data.commentable_id
          const commentableType = data.commentable_type
          const commentsList = document.querySelector(`#${commentableType.toLowerCase()}-${commentableId}-comments ul`)

          if (commentsList) {
            commentsList.insertAdjacentHTML("beforeend", data.html)
          }
        }
      }
    })
  }
})
