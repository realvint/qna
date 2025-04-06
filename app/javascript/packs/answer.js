document.addEventListener("turbolinks:load", () => {
  document.addEventListener("click", e => {
    if (e.target.matches(".edit-answer-link")) {
      e.preventDefault()
      e.target.parentElement.style.display = "none"
      const answerId = e.target.dataset.answerId
      document.querySelector(`form#edit-answer-${answerId}`).classList.remove("hidden")
    }
  })
})
