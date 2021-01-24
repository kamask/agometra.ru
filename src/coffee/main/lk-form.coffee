import { lkFormHandler } from './ago-lib.js'
{ el } =  window.ago.ksk

lkFormLink = el '.nav-top .lk-client>.link'
lkForm = el '.nav-top .lk-client form'

lkFormHandler lkForm, lkFormLink, 'navtop'

