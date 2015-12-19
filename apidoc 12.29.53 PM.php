<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml" class="no-js">
   <head>
      <title>API Doc</title>
      <meta name="description" content="">
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <link href='http://fonts.googleapis.com/css?family=Open+Sans:300' rel='stylesheet' type='text/css'>
      <meta charset="utf-8">
      <meta http-equiv="X-UA-Compatible" content="IE=edge">
      <style>
         body {
            padding: 10px 10px 10px 10px;
            margin: 0px 0px 10px 0px;
            overflow: none;

            font-family: Times, sans-serif;
            font-size: 16px;
         }
         h1, h2, h3 {
            margin: 0px 0px 5px 0px;
            padding: 0px 0px 0px 0px;
         }
         h3 {
            display: inline-block;
         }
         p {
            margin: 0px 0px 20px 0px;
            padding: 0px 0px 0px 0px;
         }
         .endpoint_block {
            display: inline-block;
            vertical-align: top;
            width: calc(100%/3 - 20px - 10px - 2px);
            border: 1px solid #999;

            padding: 10px 10px 10px 10px;
            margin: 0px 10px 10px 0px;
         }
         .endpoint_block h3 {
            font-size: 15px;
            margin: 0px 0px 2px 0px;
            padding: 0px 0px 0px 0px;
         }
         
      </style>
   </head>
   <body>
      <p>
         <h1>API Documentation</h1>
         This document outlines how to talk to the database. Talk to Matthew in order to request/fix anything.
      </p>
      
      <p>
         <h2>How to talk to API</h2>
         HTTP request the api address using either POST or GET. Communication using JSON. Example: (twelv.ca)/api/?event_create={'something':'somethingelse'}
      </p>

      <p>
         <h2>API Error</h2>
         The API creates error messages by returning a json object with a member "error" which contains a string. Example: {'error':'parameters required'}
      </p>

      <p>
         <h2>API Endpoints</h2>
         <?php
            class Endpoint {
               var $privileges;
               var $name;
               var $details;
               var $parameters;
               var $returns;

               function __construct($privileges, $name, $parameters, $returns, $details) {
                  $this->privileges = $privileges;
                  $this->name = $name;
                  $this->parameters = $parameters;
                  $this->returns = $returns;
                  $this->details = $details;
               }
            }

            $endpoints = array(
               new Endpoint(
                  "none", 
                  "session_fetch", 
                  "none",
                  "json array of relevent user session data",
                  "useful when determining if a user is logged in, returning an empty object when there's no session"
               ),
               new Endpoint(
                  "none", 
                  "session_create", 
                  "the facebook login status json",
                  "yes or error",
                  "see <a href='https://developers.facebook.com/docs/facebook-login/web#checklogin'>this</a> though there is likely something more relevant for apps"
               ),
               new Endpoint(
                  "valid login session", 
                  "events_fetch", 
                  "none",
                  "array of json objects containing all valid users events",
                  ""
               ),
               new Endpoint(
                  "valid login session", 
                  "events_create", 
                  "name, timestart, timefinish, details //these will be determined later",
                  "json object containing all information on the event, including unique event id",
                  ""
               ),
               new Endpoint(
                  "valid login session", 
                  "events_delete", 
                  "event_id",
                  "json object containing all information on the event",
                  ""
               ),
               new Endpoint(
                  "valid login session", 
                  "friends_fetch", 
                  "none",
                  "json array of facebook friends",
                  ""
               ),
            );
            
            foreach ($endpoints as $endpoint) {
               echo '<div class="endpoint_block">';
               echo '<h3>Name:</h3> ' . $endpoint->name . "</br>";
               echo '<h3>Privilege:</h3> ' . $endpoint->privileges . "</br>";
               echo '<h3>Parameters:</h3> ' . $endpoint->parameters . "</br>";
               echo '<h3>Return:</h3> ' . $endpoint->returns . "</br>";
               if ($endpoint->details != "") {
                  echo '<h3>Details:</h3> ' . $endpoint->details . "</br>";
               }
               echo '</div>';
            }
         ?>
      </p>
   </body>
</html>