document.addEventListener("turbolinks:load", () => {
  document.addEventListener("click", e => {
    if (e.target.matches(".edit-question-link")) {
      e.preventDefault()
      e.target.parentElement.style.display = "none"
      const questionId = e.target.dataset.questionId
      document.querySelector(`form#edit-question-${questionId}`).classList.remove("hidden")
    }
  })
})
