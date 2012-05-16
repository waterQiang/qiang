###
static function initial in the head->
the h2o team coding tools
autor : Qiang
###
setcookie_ = (c_name, value, expiredays, domain)->
  exdate = new Date()
  if domain
    domain = ";domain=" + domain
  else
    domain = ""
  thedate = exdate.getDate()
  exdate.setDate(thedate + expiredays)
  more = if expiredays is null then "" else ";expires=" + exdate.toGMTString() + ";path=/" + domain
  document.cookie = c_name + "=" + escape(value) + more

clearthecookie_ = (c_name)->
  if h2o.COOKIE.cookieDomain
      domain = ";domain=" + h2o.COOKIE.cookieDomain
  else
      domain = ""
  exp = new Date()
  exp.setTime exp.getTime() - 1
  cval = h2o.getCookie c_name
  if cval isnt null 
    document.cookie = c_name + "='';expires=" + exp.toGMTString() + ";path=/" + domain

getcookie_ = (cookiename)->
  if document.cookie.length > 0
    c_start = document.cookie.indexOf(cookiename + "=");
    if c_start isnt -1
      c_start = c_start + cookiename.length + 1;
      c_end = document.cookie.indexOf(";", c_start);
      c_end = document.cookie.length if c_end is -1
      return unescape(document.cookie.substring(c_start, c_end));
  return 0
###
cookie function gallery <-
###

clientConect_ = (to)->
  ctype = getclienttype_()
  to.params = decodeURI(to.params)
  if ctype is 'iPad' or ctype is 'iPhone'
    window.location.href = 'lk:'+to.functioname+'?'+to.params;
  else if ctype is 'Android'
    lk[to.functioname] to.params
  else if ctype is 'WinPho'
    window.external.Notify '{"fname":"'+to.functioname+'","param":"'+JSON.stringify(to.params)+'"}'
  else
    alert 'don\'t suport client'


###
token error handler
###
tokenerror_ = ()->
  if h2o.EMBED
    clientConect_({
      functioname : 'tokenerror',
      params : ''
    });
  else
    window.location.href = '/sess/login?rt='+encodeURIComponent window.location.href     

login_ = ()->
  alert '调用login中...'
  if h2o.EMBED
    clientConect_({
      functioname : 'login',
      params : ''
    })
  else
    window.location.href = '/sess/login?rt='+encodeURIComponent window.location.href   

###
client type
###
getclienttype_ = ()->
  if navigator.userAgent.indexOf("Windows Phone OS") > 0
      return 'WinPho';
  else if navigator.userAgent.indexOf("Window") > 0
      return "Windows";
  else if navigator.userAgent.indexOf("iPhone") > 0
      return "iPhone";
  else if navigator.userAgent.indexOf("iPad") > 0
      return "iPad";
  else if navigator.userAgent.indexOf("Android") > 0
      return "Android";
  else if navigator.userAgent.indexOf("Mac OS X") > 0
      return "Mac";
  else if navigator.userAgent.indexOf("Linux") > 0
      return "Linux";
  else
      return "NUll";
      
###
get client code
###
getclientcode_ = ()->
  table = {
    'winPho':3,
    'Windows':61,
    'iPhone':1,
    'iPad':10,
    'Android':2,
    'Mac':61,
    'Linux':61,
    'NUll':71
    }
  ct1 = getclienttype_();
  return table[ct1] 

###
lk auth info set
###

lkauth_ = ()->
  if !getcookie_ 'leme_did'
    return false;
  else if !getcookie_ 'leme_token'
    return false;
  else if !getcookie_ 'leme_dtype'
    return false;
  else
    return {
      auth_token : getcookie_('leme_token'),
      auth_id : getcookie_('leme_did'),
      device_type : getcookie_('leme_dtype')
    }

###
get the http get params
###

getparam_ = (name)->
  reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
  r = decodeURI(window.location.search).substr(1).match(reg);
  if r isnt null
      return unescape(r[2])
  return 0
  
###
static function initialend<-
###

h2o = h2o or {}

companyinfo_ = '.lemeleme.lk'

h2o.clientinfo_ = {}

h2o.BASEURL = '/'

h2o.DEBUG = true

h2o.AUTH = lkauth_()

h2o.EMBED = getparam_ 'embed'

h2o.REST = false

h2o.USECACHE = false 

h2o.COOKIE =
  expireDays : 365,
  cookieDomain : null
 
h2o.global = this

###
controle and safety the console log
###
h2o.log = (logs...)->
  if @DEBUG
    return console.log(logs...) if console
  else
    return false

###
cache control
###
h2o.cache = {}

h2o.cache.app = window.applicationCache

h2o.cache.statusList = [
  'UNCACHED',
  'IDEL',
  'CHEKING',
  'DOWNLOADING',
  'UPDATEREADY',
  'OBSOLETE'
]

h2o.cache.eventlistener = ()->
  h2o.cache.app.onupdateready = ()->
#    h2o.cache.app.update()
    if confirm '程序已更新，是否重新载入'
      h2o.cache.app.swapCache()
      window.location.reload()
    h2o.log('updateready event')
  h2o.cache.app.onnoupdate = ()->
    h2o.log('noupdate event')
  h2o.cache.app.onchached = ()->
    h2o.log('cached event')
  h2o.cache.app.onerror = ()->
    h2o.log('error event')
  h2o.cache.app.onchecking = ()->
    h2o.log('checking event')
  h2o.cache.app.ondownloading = ()->
    h2o.log('downloading event')
  h2o.cache.app.onprogress = ()->
    h2o.log('progress event',event)
  h2o.cache.app.onobsolete = ()->
    h2o.log('obsolete event')
  
h2o.cache.checkstatus = ()->
  h2o.cach.statusList[h2o.cache.app.status]
  
h2o.cache.h2oDo = ()->

  
    


###
something like log for errors
###
h2o.error = (errors...)->
  if @DEBUG
    return console.error(errors...) if console
  else
    return false

###
the cookie tools of get
###
h2o.getCookie = getcookie_

###
the cookie tools of get
###  
h2o.setCookie = (c_name, value)->
  setcookie_ c_name, value, this.COOKIE.expireDays, this.COOKIE.cookieDomain

###
the cookie tools of clear
###
h2o.clearCookie = ()->
  cookie1 = document.cookie.split(';')
  for ck in cookie1
    clearthecookie_ ck.split('=')[0].replace(/\s/,'')

###
the get elements
###
h2o.getParam = getparam_

###
conect to native program
###
h2o.clientConect = clientConect_
 
###
the post handler
###
h2o.post = (options)->
  param = 
    base : 0,
    path : 0,
    method : 0,
    data : {},
    dataType : 'json',
    needlogin : true,
    both : ()-> ,
    ok : ()-> ,
    error : ()->
  $.extend param, options
  if !h2o.REST
    if param.base
      posturl = 'bridge_post.php?posturl='+encodeURIComponent param.base+param.path
    else
      posturl = param.path
    sendData =
      id:4061,
      method: param.method,
      params: param.data,
      client_info:h2o.clientinfo_
    if param.needlogin
      auth = lkauth_()
      if auth
        sendData.auth = auth
      else
        login_()
        return false
    h2o.log sendData
    h2o.log posturl
    sendData = JSON.stringify sendData
    return $.post(
            posturl,
            {data:sendData},
            (d)=>
              if d.rst is 'ok'
                h2o.log d
                param.ok d
              else
                h2o.error d
                param.error d
                tokenerror_() if d.error_code is 415 or d.error_code is 416 or d.error_code is 401
              param.both d
            ,param.dataType)
  else
    sendData = param.data[0]
    h2o.log sendData
    if param.needlogin
      auth = lkauth_()
      if auth
        $.extend sendData, auth
      else
        login_()
        return false
    if param.base
      posturl = 'bridge_post.php?posturl='+encodeURIComponent param.base+param.path+param.method
    else
      posturl = param.path+'/'+param.method
    h2o.log posturl
    h2o.log sendData
    return $.post(
            posturl,
            sendData,
            (d)=>
              if d.rst is 'ok'
                h2o.log d
                param.ok d
              else
                h2o.error d
                param.error d
                tokenerror_() if d.error_code is 415 or d.error_code is 416 or d.error_code is 401
              param.both d
            ,param.dataType)

###
localstorage globle control
###
h2o.localData = {}

h2o.localData.set = (obj)->
  if window.localStorage
    window.localStorage.setItem(obj.pre+obj.name+obj.after,obj.val)
  else
    alert('localstorage do not suport')
h2o.localData.get = (obj)->
  if window.localStorage
    window.localStorage.getItem(obj.pre+obj.name+obj.after)
  else
    alert('localstorage do not suport')  
    

### 
init params 
type object
object params 'appname,baseurl,debug'
###
h2o.init = (obj)->
  h2o.clientinfo_.bondleid = obj.appname+companyinfo_
  h2o.BASEURL = 'http://' + window.location.host + obj.baseurl
  h2o.DEBUG = obj.debug
  h2o.USECACHE = true if typeof obj.cache isnt 'undefined' and obj.cache is true
  if h2o.USECACHE
    h2o.cache.eventlistener()
  if !obj.scroll
    if $('#container').length > 0 and $('#container').css('-webkit-overflow-scrolling')
      $('#container').css {
        'position':'absolute',
        'top':'0',
        'left':'0',
        'right':'0',
        'bottom':'0'
        }
  obj
window.h2o = h2o
window.h2o2 = (pa)-> 
    h2o2[pa.functioname](pa.params);