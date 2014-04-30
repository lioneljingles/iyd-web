window.App = {

  Utils: {

    isValidEmail: (email) ->
      re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
      re.test(email)
    
    isValidUrl: (url) ->
      re = /^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/
      re.test(url)
  
    isEmpty: (object) ->
      (i for own i of object).length == 0

  }
  
}

