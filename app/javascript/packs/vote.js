document.addEventListener('ajax:success', function (e) {
  const form = e.target.closest('form')
  if (form && form.closest('.vote')) {
    const data = e.detail[0]
    const klass = data.klass
    const id = data.id
    const rating = data.rating

    const resourceId = `${klass.toLowerCase()}-${id}`;
    const ratingElement = document.querySelector(`.vote[data-resource-id="${resourceId}"] .rating`);

    if (ratingElement) {
      ratingElement.textContent = rating
    }
  }
})

document.addEventListener('ajax:error', function (e) {
  const error = e.detail[0]
  alert(typeof error === 'string' ? error : JSON.stringify(error))
})
