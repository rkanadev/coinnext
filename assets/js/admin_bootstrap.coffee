$(document).ready ()->
  $.tmpload.defaults.tplWrapper = _.template
  $(document).ajaxSend (ev, xhr)->
    xhr.setRequestHeader "X-CSRF-Token", CONFIG.csrf
  window.App = window.App or {}
  
  rootUrl = "/administratie"
  
  $btcBankBalance = $("#bank-balance-BTC")
  if $btcBankBalance.length
    updateBankBalance = ()->
      for currency in CONFIG.currencies
        $.getJSON "#{rootUrl}/banksaldo/#{currency}", (response)->
          balance = if _.isNumber(response.balance) then _.str.numberFormat(response.balance, 3) else response.balance
          $("#bank-balance-#{response.currency}").text balance
    setInterval updateBankBalance, 60000
    updateBankBalance()

    $(".show-wallet-info-bt").click (ev)->
      ev.preventDefault()
      currency = $(ev.target).data "currency"
      $cnt = $("#wallet-info-cnt-#{currency}")
      console.log $cnt.hasClass "hidden"
      if not $cnt.hasClass("hidden")
        $cnt.addClass "hidden"
      else
        $.post "#{rootUrl}/wallet_info", {currency: currency}, (response)->
          $("#wallet-address-#{currency}").html response.address
          $("#wallet-info-#{currency}").html window.App.Helpers.JSON.toHTML response.info
          $cnt.removeClass "hidden"


  $searchUserForm = $("#search-user-form")
  if $searchUserForm.length
    $searchUserForm.submit (ev)->
      ev.preventDefault()
      $.post "#{rootUrl}/search_user", $(ev.target).serialize(), (response)->
        if response.id
          $("#search-user-result")
          .attr("href", "#{rootUrl}/user/#{response.id}")
          .text "#{response.id} - #{response.email}"
        else
          alert "User could not be found."
