/* JBoss, Home of Professional Open Source
 * Copyright Red Hat, Inc., and individual contributors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
var app = {
   // Application Constructor
   initialize: function () {
      this.bindEvents();
   },
   // Bind Event Listeners
   //
   // Bind any events that are required on startup. Common events are:
   // 'load', 'deviceready', 'offline', and 'online'.
   bindEvents: function () {
      document.addEventListener('deviceready', this.register, false);
   },
   // deviceready Event Handler
   //
   // The scope of 'this' is the event. In order to call the 'receivedEvent'
   // function, we must explicity call 'app.receivedEvent(...);'
   register: function () {
      if (typeof push !== 'undefined') {
        push.register(app.onNotification, successHandler, errorHandler);
      } else {
        app.addMessage('Push plugin not installed!');
      }

      function successHandler() {
         document.getElementById("waiting").remove();
         document.getElementById("nothing").style.display = 'block';
      }

      function errorHandler(error) {
         document.getElementById("waiting").remove();
         app.addMessage('error registering ' + error);
      }
   },
   onNotification: function (event) {
      document.getElementById('nothing').style.display = 'none';
      app.addMessage(event.alert || event.version);
   },
   addMessage: function (message) {
      var messages = document.getElementById("messages"),
         element = document.createElement("li");
      //for ui testing add an id for easy (fast) selecting
      element.setAttribute("id", "message" + (messages.childElementCount + 1));
      messages.appendChild(element);
      element.innerHTML = message;
   }
};
