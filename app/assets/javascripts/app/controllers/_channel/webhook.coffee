class Index extends App.ControllerSubContent
  constructor: ->
    super
    @render()

  render: (data) ->
    @html App.view('webhook/index')(
      channels: []
    )

App.Config.set('Webhook', {
  prio: 3100,
  name: 'Webhook',
  parent: '#channels',
  target: '#channels/webhook',
  controller: Index,
  permission: ['admin.channel_webhook']
}, 'NavBarAdmin')
