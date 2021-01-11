preloaderContainer = document.getElementById('preloaderContainer')
windowLoadHandler = ->
  preloaderContainer.style.opacity = '0'
  setTimeout (->
    # document.body.classList.remove('preload')
    preloaderContainer.remove()
    window.removeEventListener 'load', windowLoadHandler
    return
    ), 200
  return
window.addEventListener 'load', windowLoadHandler
