link = document.createElement('link')
link.href = chrome.extension.getURL('dotsies.css')
link.type = 'text/css'
link.rel = 'stylesheet'

update = (enabled) ->
  if enabled
    document.documentElement.insertBefore(link, null)
  else if link.parentNode
    link.parentNode.removeChild(link)

chrome.extension.onRequest.addListener (request) ->
  update(request.enabled) if request.enabled?

chrome.extension.sendRequest { want: 'togglestate' }, (response) ->
  update(response.togglestate)
