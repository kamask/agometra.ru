export el = (selector, parrent = document) ->
  parrent.querySelector selector

export els = (selector, parrent = document) ->
  parrent.querySelectorAll selector

export ev = (el, event, handler) ->
  el.addEventListener event, handler
  return

export log = (t...) ->
  console.log t...
  return

export text = (el, text) ->
  el.innerText = text
  return

export newEl = (el) ->
  document.createElement el

export findParent = (where, parent) ->
  if typeof parent == 'string'
    for i in els parent
      findElem = findParent where, i
      if findElem
        return findElem
    return false
  unless where
    return false
  if where.parentElement == parent then parent else findParent where.parentElement, parent

window.requestAnimFrame = (->
  window.requestAnimationFrame ||
  window.webkitRequestAnimationFrame ||
  window.mozRequestAnimationFrame ||
  (callback) ->
    window.setTimeout callback, 1000 / 60
    return
)()

export animation = (current, moveVal, duration, setNewVal, timing = 'linear',
  animateIdForCancel = null) ->
    start = do performance.now
    if animateIdForCancel
      cancelAnimationFrame animateIdForCancel
    
    funcs = {
      linear: (t) -> t
      quad: (t, x = 2) -> Math.pow t, x
      circ: (t) -> 1 - Math.sin Math.acos t
      back: (t, x = 1.5) -> (Math.pow t, x) * ((x + 1) * t -x)
      bounce: (t) ->
        a = 0
        b = 1
        while 1
          if t >= (7 - 4 * a) / 11
            return (-Math.pow (11 - 6 * a - 11 * t) / 4, 2) + Math.pow b, 2
          a += b
          b /= 2
      elastic: (t, x = 1.5) ->
        (Math.pow 2, 10 * (t - 1)) * (Math.cos (20 * Math.PI * x / 3 * t))
    }

    if /out$/.test timing
      timingFucn = (t) -> 1 - funcs[(timing.split '-')[0]] (1 - t)
    else if /inout$/.test timing
      timingFucn = (t) ->
        if t < .5
          return funcs[timing] ((2 * t) / 2)
        else
          return ((2 - (funcs[timing] (2 * (1 - t)))) / 2)
    else
      timingFuncs = funcs[timing]

    animate = (time) ->
      tF = (time - start) / duration
      if tF > 1
        tF = 1
      setNewVal (current + (moveVal * (timingFucn tF)))
      if tF < 1
        requestAnimFrame animate
      return
  
    return requestAnimFrame animate

export makeObserveble = (obj) ->
  observers = []
  obj.addObserver = (cb) ->
    observers.push cb
    return
  new Proxy obj, {
    set: (target, property, value, receiver) ->
      old = target[property]
      Reflect.set target, property, value, receiver
      for h in observers
        h target, property, value, old
      return true
  }

export nodeObserver = (node, opt, cb) ->
  observer = new MutationObserver (mutationRecords) ->
    for mr in mutationRecords
      cb mr
    return

  observer.observe node, opt
  return

export imgWithWebp = (url, webp = null, alt = 'image') ->
  $picture = document.createElement 'picture'
  if webp
    $webp = document.createElement 'source'
    $webp.setAttribute 'srcset', webp
    $webp.setAttribute 'type', 'image/webp'
    $picture.append $webp
  $img = document.createElement 'img'
  $img.setAttribute 'src', url
  $img.setAttribute 'alt', alt
  $picture.append $img
  return $picture