get_togglestate = ->
  localStorage["enabled"] ||= "true"
  return (localStorage["enabled"] == "true")

initialize = ->
  """Inject into tabs which are extant at the point of plugin installation."""
  chrome.tabs.query {}, (tabs) ->
    for tab in tabs
      chrome.tabs.executeScript(tab.id, file: "inject.js")

update = ->
  """Update tabs and icon to reflect current togglestate."""
  enabled = get_togglestate()
  chrome.tabs.query {}, (tabs) ->
    for tab in tabs
      chrome.tabs.sendRequest(tab.id, { enabled: enabled })
  if enabled
    chrome.browserAction.setBadgeText(text: "")
  else
    chrome.browserAction.setBadgeText(text: "off")

toggle = ->
  """Flip plugin togglestate and update."""
  localStorage["enabled"] = !get_togglestate()
  update()

chrome.extension.onRequest.addListener (request, sender, respond) ->
  if request.want == 'togglestate'
    respond(togglestate: get_togglestate())

chrome.browserAction.onClicked.addListener (tab) ->
  toggle()

initialize()
update()
