import { makeObserveble, log } from '/js/ksk-lib.js'

export cart = makeObserveble {
  count: 0
  add: (calcState) ->
    log calcState
    return
}