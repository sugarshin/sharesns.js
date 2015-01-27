$ = require 'jquery'
Popup = require 'popup.js'

class ShareSNS extends Popup
  "use strict"

  _metaTags = document.getElementsByTagName 'meta'

  @getMeta: ->
    _metaTags = document.getElementsByTagName 'meta'

  _defaults:
    width: 640
    height: 480
    url: null
    name: 'popup'
    type: ''

  constructor: (@el, opts) ->
    @opts = $.extend {}, @_defaults, opts
    @$el = $(@el)
    @setParam()
    @setURL()
    @addEvent()

  setURL: ->
    if @opts.type is 'twitter'
      @_setTwitterURL()
    else if @opts.type is 'facebook'
      @_setFacebookURL()

  addEvent: ->
    @$el.on 'click', (ev) =>
      ev.preventDefault()
      @open()

  _setTwitterURL: ->
    for meta in _metaTags
      if meta.getAttribute 'property'
        metaProp = meta.getAttribute 'property'
        if metaProp is 'og:url'
          shareUrl = meta.getAttribute 'content'
        else if metaProp is 'og:title'
          shareTitle = meta.getAttribute 'content'

    maxLength = 140 - (shareUrl.length + 1)
    if shareTitle.length > maxLength
      shareTitle = "#{shareTitle.substr(0, (maxLength - 3))}..."
    @_url = "https://twitter.com/share?url=#{encodeURI(shareUrl)}&text=#{encodeURI(shareTitle)}"
    return this

  _setFacebookURL: ->
    for meta in _metaTags
      if meta.getAttribute 'property'
        metaProp = meta.getAttribute 'property'
        if metaProp is 'og:url'
          shareUrl = meta.getAttribute 'content'

    @_url = "https://www.facebook.com/sharer.php?u=#{shareUrl}"
    return this

if typeof define is 'function' and define.amd
  define -> ShareSNS
else if typeof module isnt 'undefined' and module.exports
  module.exports = ShareSNS
else
  window.ShareSNS or= ShareSNS
