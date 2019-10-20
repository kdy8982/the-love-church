/*
 * JavaScript Load Image Demo JS
 * https://github.com/blueimp/JavaScript-Load-Image
 *
 * Copyright 2013, Sebastian Tschan
 * https://blueimp.net
 *
 * Licensed under the MIT license:
 * https://opensource.org/licenses/MIT
 */

/* global loadImage, $ */

$(function() {
  'use strict'

  var result = $('.write_box');
  var currentFile
  function updateResults(img, data) {
    var fileName = currentFile.name
    var content;
    content = $('<div>').append(img)
    result.append(content)
  }

  function displayImage(file, options) {
    currentFile = file
    loadImage(file, updateResults, options);
  }

  /**
   * Handles drop and file selection change events
   *
   * @param {event} event Drop or file selection change event
   */
  function dropChangeHandler(event) {
    alert("asdfasdf")
    event.preventDefault()
    var originalEvent = event.originalEvent
    var target = originalEvent.dataTransfer || originalEvent.target
    var file = target && target.files && target.files[0]
    var options = {
      maxWidth: result.width(),
      pixelRatio: window.devicePixelRatio,
      downsamplingRatio: 0.5,
      orientation: true
    }
    if (!file) {
      return
    }
    displayImage(file, options)
  }

  $("input[type='file']").on('change', dropChangeHandler)

})
