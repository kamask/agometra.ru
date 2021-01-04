preloaderContainer = document.getElementById('preloaderContainer')
document.addEventListener 'DOMContentLoaded', ->
  logoSVG = document.getElementById('logo-svg')
  logoSVGPreloader = logoSVG.cloneNode(true)
  logoSVGPreloader.id = 'logo-svg-preloader'
  logoSVGPreloader.style.width = '300px'
  setTimeout (->
    preloaderContainer.append(logoSVGPreloader)
    return
    ), 1000
  return
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