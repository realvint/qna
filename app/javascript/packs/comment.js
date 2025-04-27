document.addEventListener("turbolinks:load", () => {
  document.addEventListener("click", e => {
    if (e.target.matches(".add-comment-link")) {
      e.preventDefault()
      e.target.style.display = "none"
      const form = e.target.nextElementSibling
      if (form && form.classList.contains("comment-form")) {
        form.classList.remove("hidden")
        const textarea = form.querySelector('textarea')
        if (textarea) { textarea.value = "" }
      }
    }
  })
})
