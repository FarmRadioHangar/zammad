class AudioReply
  @action: (actions, ticket, article, ui) ->
    actions

  @perform: (articleContainer, type, ticket, article, ui) ->
    true

  @articleTypes: (articleTypes, ticket, ui) ->
    return articleTypes if !ui.permissionCheck('ticket.agent')
    articleTypes.push {
      name:       'audio'
      icon:       'reply'
      attributes: ['audio']
      internal:   false,
      features:   ['attachment']
    }
    articleTypes

App.Config.set('300-AudioReply', AudioReply, 'TicketZoomArticleAction')
