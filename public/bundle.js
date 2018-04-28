(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
const axios=require("axios"),apiEndpoint="/api/",app=window.Elm.Main.embed(document.getElementById("app"),{apiEndpoint:"/api/",env:"production"});document.addEventListener("animationstart",t=>{const e={textField:function(){window.M.updateTextFields()},sidenav:function(t){return new window.M.Sidenav(t,{})}};if("nodeInserted"===t.animationName){const a=t.target,n=a.getAttribute("data-js-component");n&&e[n](a)}},!1),document.addEventListener("click",t=>{const e=t.target.getAttribute("data-link")||t.target.parentNode&&t.target.parentNode.getAttribute&&t.target.parentNode.getAttribute("data-link");e&&(t.preventDefault(),app.ports.navigate.send(e))}),app.ports.uploadQuestImage.subscribe(t=>{const e=document.getElementById(t);if(!e)return;const a=new FormData;a.append("file",e.files[0]),axios({method:"POST",url:"/api/upload",data:a,withCredentials:!0}).then(t=>{app.ports.uploadQuestImageFinished.send([!0,t.data.file])}).catch(()=>{app.ports.uploadQuestImageFinished.send([!1,"error"])})});

},{"axios":2}],2:[function(require,module,exports){
module.exports=require("./lib/axios");

},{"./lib/axios":4}],3:[function(require,module,exports){
(function (process){
"use strict";var utils=require("./../utils"),settle=require("./../core/settle"),buildURL=require("./../helpers/buildURL"),parseHeaders=require("./../helpers/parseHeaders"),isURLSameOrigin=require("./../helpers/isURLSameOrigin"),createError=require("../core/createError"),btoa="undefined"!=typeof window&&window.btoa&&window.btoa.bind(window)||require("./../helpers/btoa");module.exports=function(e){return new Promise(function(r,t){var s=e.data,o=e.headers;utils.isFormData(s)&&delete o["Content-Type"];var n=new XMLHttpRequest,i="onreadystatechange",a=!1;if("test"===process.env.NODE_ENV||"undefined"==typeof window||!window.XDomainRequest||"withCredentials"in n||isURLSameOrigin(e.url)||(n=new window.XDomainRequest,i="onload",a=!0,n.onprogress=function(){},n.ontimeout=function(){}),e.auth){var u=e.auth.username||"",d=e.auth.password||"";o.Authorization="Basic "+btoa(u+":"+d)}if(n.open(e.method.toUpperCase(),buildURL(e.url,e.params,e.paramsSerializer),!0),n.timeout=e.timeout,n[i]=function(){if(n&&(4===n.readyState||a)&&(0!==n.status||n.responseURL&&0===n.responseURL.indexOf("file:"))){var s="getAllResponseHeaders"in n?parseHeaders(n.getAllResponseHeaders()):null,o={data:e.responseType&&"text"!==e.responseType?n.response:n.responseText,status:1223===n.status?204:n.status,statusText:1223===n.status?"No Content":n.statusText,headers:s,config:e,request:n};settle(r,t,o),n=null}},n.onerror=function(){t(createError("Network Error",e,null,n)),n=null},n.ontimeout=function(){t(createError("timeout of "+e.timeout+"ms exceeded",e,"ECONNABORTED",n)),n=null},utils.isStandardBrowserEnv()){var l=require("./../helpers/cookies"),p=(e.withCredentials||isURLSameOrigin(e.url))&&e.xsrfCookieName?l.read(e.xsrfCookieName):void 0;p&&(o[e.xsrfHeaderName]=p)}if("setRequestHeader"in n&&utils.forEach(o,function(e,r){void 0===s&&"content-type"===r.toLowerCase()?delete o[r]:n.setRequestHeader(r,e)}),e.withCredentials&&(n.withCredentials=!0),e.responseType)try{n.responseType=e.responseType}catch(r){if("json"!==e.responseType)throw r}"function"==typeof e.onDownloadProgress&&n.addEventListener("progress",e.onDownloadProgress),"function"==typeof e.onUploadProgress&&n.upload&&n.upload.addEventListener("progress",e.onUploadProgress),e.cancelToken&&e.cancelToken.promise.then(function(e){n&&(n.abort(),t(e),n=null)}),void 0===s&&(s=null),n.send(s)})};

}).call(this,require('_process'))
},{"../core/createError":10,"./../core/settle":13,"./../helpers/btoa":17,"./../helpers/buildURL":18,"./../helpers/cookies":20,"./../helpers/isURLSameOrigin":22,"./../helpers/parseHeaders":24,"./../utils":26,"_process":28}],4:[function(require,module,exports){
"use strict";var utils=require("./utils"),bind=require("./helpers/bind"),Axios=require("./core/Axios"),defaults=require("./defaults");function createInstance(e){var r=new Axios(e),s=bind(Axios.prototype.request,r);return utils.extend(s,Axios.prototype,r),utils.extend(s,r),s}var axios=createInstance(defaults);axios.Axios=Axios,axios.create=function(e){return createInstance(utils.merge(defaults,e))},axios.Cancel=require("./cancel/Cancel"),axios.CancelToken=require("./cancel/CancelToken"),axios.isCancel=require("./cancel/isCancel"),axios.all=function(e){return Promise.all(e)},axios.spread=require("./helpers/spread"),module.exports=axios,module.exports.default=axios;

},{"./cancel/Cancel":5,"./cancel/CancelToken":6,"./cancel/isCancel":7,"./core/Axios":8,"./defaults":15,"./helpers/bind":16,"./helpers/spread":25,"./utils":26}],5:[function(require,module,exports){
"use strict";function Cancel(e){this.message=e}Cancel.prototype.toString=function(){return"Cancel"+(this.message?": "+this.message:"")},Cancel.prototype.__CANCEL__=!0,module.exports=Cancel;

},{}],6:[function(require,module,exports){
"use strict";var Cancel=require("./Cancel");function CancelToken(e){if("function"!=typeof e)throw new TypeError("executor must be a function.");var n;this.promise=new Promise(function(e){n=e});var o=this;e(function(e){o.reason||(o.reason=new Cancel(e),n(o.reason))})}CancelToken.prototype.throwIfRequested=function(){if(this.reason)throw this.reason},CancelToken.source=function(){var e;return{token:new CancelToken(function(n){e=n}),cancel:e}},module.exports=CancelToken;

},{"./Cancel":5}],7:[function(require,module,exports){
"use strict";module.exports=function(t){return!(!t||!t.__CANCEL__)};

},{}],8:[function(require,module,exports){
"use strict";var defaults=require("./../defaults"),utils=require("./../utils"),InterceptorManager=require("./InterceptorManager"),dispatchRequest=require("./dispatchRequest");function Axios(e){this.defaults=e,this.interceptors={request:new InterceptorManager,response:new InterceptorManager}}Axios.prototype.request=function(e){"string"==typeof e&&(e=utils.merge({url:arguments[0]},arguments[1])),(e=utils.merge(defaults,this.defaults,{method:"get"},e)).method=e.method.toLowerCase();var t=[dispatchRequest,void 0],r=Promise.resolve(e);for(this.interceptors.request.forEach(function(e){t.unshift(e.fulfilled,e.rejected)}),this.interceptors.response.forEach(function(e){t.push(e.fulfilled,e.rejected)});t.length;)r=r.then(t.shift(),t.shift());return r},utils.forEach(["delete","get","head","options"],function(e){Axios.prototype[e]=function(t,r){return this.request(utils.merge(r||{},{method:e,url:t}))}}),utils.forEach(["post","put","patch"],function(e){Axios.prototype[e]=function(t,r,s){return this.request(utils.merge(s||{},{method:e,url:t,data:r}))}}),module.exports=Axios;

},{"./../defaults":15,"./../utils":26,"./InterceptorManager":9,"./dispatchRequest":11}],9:[function(require,module,exports){
"use strict";var utils=require("./../utils");function InterceptorManager(){this.handlers=[]}InterceptorManager.prototype.use=function(e,t){return this.handlers.push({fulfilled:e,rejected:t}),this.handlers.length-1},InterceptorManager.prototype.eject=function(e){this.handlers[e]&&(this.handlers[e]=null)},InterceptorManager.prototype.forEach=function(e){utils.forEach(this.handlers,function(t){null!==t&&e(t)})},module.exports=InterceptorManager;

},{"./../utils":26}],10:[function(require,module,exports){
"use strict";var enhanceError=require("./enhanceError");module.exports=function(r,e,n,o,a){var c=new Error(r);return enhanceError(c,e,n,o,a)};

},{"./enhanceError":12}],11:[function(require,module,exports){
"use strict";var utils=require("./../utils"),transformData=require("./transformData"),isCancel=require("../cancel/isCancel"),defaults=require("../defaults"),isAbsoluteURL=require("./../helpers/isAbsoluteURL"),combineURLs=require("./../helpers/combineURLs");function throwIfCancellationRequested(e){e.cancelToken&&e.cancelToken.throwIfRequested()}module.exports=function(e){return throwIfCancellationRequested(e),e.baseURL&&!isAbsoluteURL(e.url)&&(e.url=combineURLs(e.baseURL,e.url)),e.headers=e.headers||{},e.data=transformData(e.data,e.headers,e.transformRequest),e.headers=utils.merge(e.headers.common||{},e.headers[e.method]||{},e.headers||{}),utils.forEach(["delete","get","head","post","put","patch","common"],function(a){delete e.headers[a]}),(e.adapter||defaults.adapter)(e).then(function(a){return throwIfCancellationRequested(e),a.data=transformData(a.data,a.headers,e.transformResponse),a},function(a){return isCancel(a)||(throwIfCancellationRequested(e),a&&a.response&&(a.response.data=transformData(a.response.data,a.response.headers,e.transformResponse))),Promise.reject(a)})};

},{"../cancel/isCancel":7,"../defaults":15,"./../helpers/combineURLs":19,"./../helpers/isAbsoluteURL":21,"./../utils":26,"./transformData":14}],12:[function(require,module,exports){
"use strict";module.exports=function(e,o,r,s,t){return e.config=o,r&&(e.code=r),e.request=s,e.response=t,e};

},{}],13:[function(require,module,exports){
"use strict";var createError=require("./createError");module.exports=function(t,r,e){var s=e.config.validateStatus;e.status&&s&&!s(e.status)?r(createError("Request failed with status code "+e.status,e.config,null,e.request,e)):t(e)};

},{"./createError":10}],14:[function(require,module,exports){
"use strict";var utils=require("./../utils");module.exports=function(t,u,r){return utils.forEach(r,function(r){t=r(t,u)}),t};

},{"./../utils":26}],15:[function(require,module,exports){
(function (process){
"use strict";var utils=require("./utils"),normalizeHeaderName=require("./helpers/normalizeHeaderName"),DEFAULT_CONTENT_TYPE={"Content-Type":"application/x-www-form-urlencoded"};function setContentTypeIfUnset(e,t){!utils.isUndefined(e)&&utils.isUndefined(e["Content-Type"])&&(e["Content-Type"]=t)}function getDefaultAdapter(){var e;return"undefined"!=typeof XMLHttpRequest?e=require("./adapters/xhr"):"undefined"!=typeof process&&(e=require("./adapters/http")),e}var defaults={adapter:getDefaultAdapter(),transformRequest:[function(e,t){return normalizeHeaderName(t,"Content-Type"),utils.isFormData(e)||utils.isArrayBuffer(e)||utils.isBuffer(e)||utils.isStream(e)||utils.isFile(e)||utils.isBlob(e)?e:utils.isArrayBufferView(e)?e.buffer:utils.isURLSearchParams(e)?(setContentTypeIfUnset(t,"application/x-www-form-urlencoded;charset=utf-8"),e.toString()):utils.isObject(e)?(setContentTypeIfUnset(t,"application/json;charset=utf-8"),JSON.stringify(e)):e}],transformResponse:[function(e){if("string"==typeof e)try{e=JSON.parse(e)}catch(e){}return e}],timeout:0,xsrfCookieName:"XSRF-TOKEN",xsrfHeaderName:"X-XSRF-TOKEN",maxContentLength:-1,validateStatus:function(e){return e>=200&&e<300},headers:{common:{Accept:"application/json, text/plain, */*"}}};utils.forEach(["delete","get","head"],function(e){defaults.headers[e]={}}),utils.forEach(["post","put","patch"],function(e){defaults.headers[e]=utils.merge(DEFAULT_CONTENT_TYPE)}),module.exports=defaults;

}).call(this,require('_process'))
},{"./adapters/http":3,"./adapters/xhr":3,"./helpers/normalizeHeaderName":23,"./utils":26,"_process":28}],16:[function(require,module,exports){
"use strict";module.exports=function(r,n){return function(){for(var t=new Array(arguments.length),e=0;e<t.length;e++)t[e]=arguments[e];return r.apply(n,t)}};

},{}],17:[function(require,module,exports){
"use strict";var chars="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";function E(){this.message="String contains an invalid character"}function btoa(r){for(var t,a,o=String(r),e="",n=0,c=chars;o.charAt(0|n)||(c="=",n%1);e+=c.charAt(63&t>>8-n%1*8)){if((a=o.charCodeAt(n+=.75))>255)throw new E;t=t<<8|a}return e}E.prototype=new Error,E.prototype.code=5,E.prototype.name="InvalidCharacterError",module.exports=btoa;

},{}],18:[function(require,module,exports){
"use strict";var utils=require("./../utils");function encode(e){return encodeURIComponent(e).replace(/%40/gi,"@").replace(/%3A/gi,":").replace(/%24/g,"$").replace(/%2C/gi,",").replace(/%20/g,"+").replace(/%5B/gi,"[").replace(/%5D/gi,"]")}module.exports=function(e,i,r){if(!i)return e;var t;if(r)t=r(i);else if(utils.isURLSearchParams(i))t=i.toString();else{var n=[];utils.forEach(i,function(e,i){null!=e&&(utils.isArray(e)&&(i+="[]"),utils.isArray(e)||(e=[e]),utils.forEach(e,function(e){utils.isDate(e)?e=e.toISOString():utils.isObject(e)&&(e=JSON.stringify(e)),n.push(encode(i)+"="+encode(e))}))}),t=n.join("&")}return t&&(e+=(-1===e.indexOf("?")?"?":"&")+t),e};

},{"./../utils":26}],19:[function(require,module,exports){
"use strict";module.exports=function(e,r){return r?e.replace(/\/+$/,"")+"/"+r.replace(/^\/+/,""):e};

},{}],20:[function(require,module,exports){
"use strict";var utils=require("./../utils");module.exports=utils.isStandardBrowserEnv()?{write:function(e,t,n,i,u,o){var r=[];r.push(e+"="+encodeURIComponent(t)),utils.isNumber(n)&&r.push("expires="+new Date(n).toGMTString()),utils.isString(i)&&r.push("path="+i),utils.isString(u)&&r.push("domain="+u),!0===o&&r.push("secure"),document.cookie=r.join("; ")},read:function(e){var t=document.cookie.match(new RegExp("(^|;\\s*)("+e+")=([^;]*)"));return t?decodeURIComponent(t[3]):null},remove:function(e){this.write(e,"",Date.now()-864e5)}}:{write:function(){},read:function(){return null},remove:function(){}};

},{"./../utils":26}],21:[function(require,module,exports){
"use strict";module.exports=function(t){return/^([a-z][a-z\d\+\-\.]*:)?\/\//i.test(t)};

},{}],22:[function(require,module,exports){
"use strict";var utils=require("./../utils");module.exports=utils.isStandardBrowserEnv()?function(){var t,r=/(msie|trident)/i.test(navigator.userAgent),e=document.createElement("a");function o(t){var o=t;return r&&(e.setAttribute("href",o),o=e.href),e.setAttribute("href",o),{href:e.href,protocol:e.protocol?e.protocol.replace(/:$/,""):"",host:e.host,search:e.search?e.search.replace(/^\?/,""):"",hash:e.hash?e.hash.replace(/^#/,""):"",hostname:e.hostname,port:e.port,pathname:"/"===e.pathname.charAt(0)?e.pathname:"/"+e.pathname}}return t=o(window.location.href),function(r){var e=utils.isString(r)?o(r):r;return e.protocol===t.protocol&&e.host===t.host}}():function(){return!0};

},{"./../utils":26}],23:[function(require,module,exports){
"use strict";var utils=require("../utils");module.exports=function(e,t){utils.forEach(e,function(r,s){s!==t&&s.toUpperCase()===t.toUpperCase()&&(e[t]=r,delete e[s])})};

},{"../utils":26}],24:[function(require,module,exports){
"use strict";var utils=require("./../utils"),ignoreDuplicateOf=["age","authorization","content-length","content-type","etag","expires","from","host","if-modified-since","if-unmodified-since","last-modified","location","max-forwards","proxy-authorization","referer","retry-after","user-agent"];module.exports=function(t){var e,i,r,o={};return t?(utils.forEach(t.split("\n"),function(t){if(r=t.indexOf(":"),e=utils.trim(t.substr(0,r)).toLowerCase(),i=utils.trim(t.substr(r+1)),e){if(o[e]&&ignoreDuplicateOf.indexOf(e)>=0)return;o[e]="set-cookie"===e?(o[e]?o[e]:[]).concat([i]):o[e]?o[e]+", "+i:i}}),o):o};

},{"./../utils":26}],25:[function(require,module,exports){
"use strict";module.exports=function(n){return function(t){return n.apply(null,t)}};

},{}],26:[function(require,module,exports){
"use strict";var bind=require("./helpers/bind"),isBuffer=require("is-buffer"),toString=Object.prototype.toString;function isArray(r){return"[object Array]"===toString.call(r)}function isArrayBuffer(r){return"[object ArrayBuffer]"===toString.call(r)}function isFormData(r){return"undefined"!=typeof FormData&&r instanceof FormData}function isArrayBufferView(r){return"undefined"!=typeof ArrayBuffer&&ArrayBuffer.isView?ArrayBuffer.isView(r):r&&r.buffer&&r.buffer instanceof ArrayBuffer}function isString(r){return"string"==typeof r}function isNumber(r){return"number"==typeof r}function isUndefined(r){return void 0===r}function isObject(r){return null!==r&&"object"==typeof r}function isDate(r){return"[object Date]"===toString.call(r)}function isFile(r){return"[object File]"===toString.call(r)}function isBlob(r){return"[object Blob]"===toString.call(r)}function isFunction(r){return"[object Function]"===toString.call(r)}function isStream(r){return isObject(r)&&isFunction(r.pipe)}function isURLSearchParams(r){return"undefined"!=typeof URLSearchParams&&r instanceof URLSearchParams}function trim(r){return r.replace(/^\s*/,"").replace(/\s*$/,"")}function isStandardBrowserEnv(){return("undefined"==typeof navigator||"ReactNative"!==navigator.product)&&("undefined"!=typeof window&&"undefined"!=typeof document)}function forEach(r,e){if(null!=r)if("object"!=typeof r&&(r=[r]),isArray(r))for(var t=0,n=r.length;t<n;t++)e.call(null,r[t],t,r);else for(var i in r)Object.prototype.hasOwnProperty.call(r,i)&&e.call(null,r[i],i,r)}function merge(){var r={};function e(e,t){"object"==typeof r[t]&&"object"==typeof e?r[t]=merge(r[t],e):r[t]=e}for(var t=0,n=arguments.length;t<n;t++)forEach(arguments[t],e);return r}function extend(r,e,t){return forEach(e,function(e,n){r[n]=t&&"function"==typeof e?bind(e,t):e}),r}module.exports={isArray:isArray,isArrayBuffer:isArrayBuffer,isBuffer:isBuffer,isFormData:isFormData,isArrayBufferView:isArrayBufferView,isString:isString,isNumber:isNumber,isObject:isObject,isUndefined:isUndefined,isDate:isDate,isFile:isFile,isBlob:isBlob,isFunction:isFunction,isStream:isStream,isURLSearchParams:isURLSearchParams,isStandardBrowserEnv:isStandardBrowserEnv,forEach:forEach,merge:merge,extend:extend,trim:trim};

},{"./helpers/bind":16,"is-buffer":27}],27:[function(require,module,exports){
function isBuffer(f){return!!f.constructor&&"function"==typeof f.constructor.isBuffer&&f.constructor.isBuffer(f)}function isSlowBuffer(f){return"function"==typeof f.readFloatLE&&"function"==typeof f.slice&&isBuffer(f.slice(0,0))}module.exports=function(f){return null!=f&&(isBuffer(f)||isSlowBuffer(f)||!!f._isBuffer)};

},{}],28:[function(require,module,exports){
var cachedSetTimeout,cachedClearTimeout,process=module.exports={};function defaultSetTimout(){throw new Error("setTimeout has not been defined")}function defaultClearTimeout(){throw new Error("clearTimeout has not been defined")}function runTimeout(e){if(cachedSetTimeout===setTimeout)return setTimeout(e,0);if((cachedSetTimeout===defaultSetTimout||!cachedSetTimeout)&&setTimeout)return cachedSetTimeout=setTimeout,setTimeout(e,0);try{return cachedSetTimeout(e,0)}catch(t){try{return cachedSetTimeout.call(null,e,0)}catch(t){return cachedSetTimeout.call(this,e,0)}}}function runClearTimeout(e){if(cachedClearTimeout===clearTimeout)return clearTimeout(e);if((cachedClearTimeout===defaultClearTimeout||!cachedClearTimeout)&&clearTimeout)return cachedClearTimeout=clearTimeout,clearTimeout(e);try{return cachedClearTimeout(e)}catch(t){try{return cachedClearTimeout.call(null,e)}catch(t){return cachedClearTimeout.call(this,e)}}}!function(){try{cachedSetTimeout="function"==typeof setTimeout?setTimeout:defaultSetTimout}catch(e){cachedSetTimeout=defaultSetTimout}try{cachedClearTimeout="function"==typeof clearTimeout?clearTimeout:defaultClearTimeout}catch(e){cachedClearTimeout=defaultClearTimeout}}();var currentQueue,queue=[],draining=!1,queueIndex=-1;function cleanUpNextTick(){draining&&currentQueue&&(draining=!1,currentQueue.length?queue=currentQueue.concat(queue):queueIndex=-1,queue.length&&drainQueue())}function drainQueue(){if(!draining){var e=runTimeout(cleanUpNextTick);draining=!0;for(var t=queue.length;t;){for(currentQueue=queue,queue=[];++queueIndex<t;)currentQueue&&currentQueue[queueIndex].run();queueIndex=-1,t=queue.length}currentQueue=null,draining=!1,runClearTimeout(e)}}function Item(e,t){this.fun=e,this.array=t}function noop(){}process.nextTick=function(e){var t=new Array(arguments.length-1);if(arguments.length>1)for(var r=1;r<arguments.length;r++)t[r-1]=arguments[r];queue.push(new Item(e,t)),1!==queue.length||draining||runTimeout(drainQueue)},Item.prototype.run=function(){this.fun.apply(null,this.array)},process.title="browser",process.browser=!0,process.env={},process.argv=[],process.version="",process.versions={},process.on=noop,process.addListener=noop,process.once=noop,process.off=noop,process.removeListener=noop,process.removeAllListeners=noop,process.emit=noop,process.prependListener=noop,process.prependOnceListener=noop,process.listeners=function(e){return[]},process.binding=function(e){throw new Error("process.binding is not supported")},process.cwd=function(){return"/"},process.chdir=function(e){throw new Error("process.chdir is not supported")},process.umask=function(){return 0};

},{}]},{},[1]);
