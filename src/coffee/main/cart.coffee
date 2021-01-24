export cart = window.ago.ksk.makeObserveble {
  count: 0
  add: (calcState) ->
    console.log calcState
    return
}