<!--
///////////////////////////////////////////////////////////////////////////
#
#   LstSummaryMeeting.php
#
#   This example page uses PHP to HTTP POST a WebEx XML request function  
#   which queries for the calling user's meetings.  The WebEx XML Service then
#   returns an XML response document listing each meeting.
#
#   This page should be installed onto a webserver running PHP.
#
#   Author: Phillip Liu, phillipl@webex.com                                             
#   Date:   11/11/04													
#																		
#   (c) Copyright 2004 WebEx Communications								
#																		
///////////////////////////////////////////////////////////////////////////

These variables need to be set...

SID set to your siteid number
UID set to your WebEx username  
PWD set to your WebEx password
PID set to the site partnerID, if you don't know, you can get it from WebEx.
 
XML_SITE set to a WebEx Site name 
-->

<html>
<head>
<title>List WebEx meetings via XML API</title>
</head> 
<body>
<?php
    // Specify WebEx site and port
    $XML_SITE="apidemoeu.webex.com";
    $XML_PORT="443";

    // Set calling user information
    $d["UID"] = ""; // WebEx username
    $d["PWD"] = ""; // WebEx password
    $d["SID"] = "243585"; //Demo Site SiteID
    $d["PID"] = "g0webx!"; //Demo Site PartnerID

    // Build XML request document
    $d["XML"]="<?xml version=\"1.0\" encoding=\"UTF-8\"?>";
    $d["XML"].="<serv:message xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" ";
    $d["XML"].="xmlns:serv=\"http://www.webex.com/schemas/2002/06/service\">";
    $d["XML"].="<header>";
    $d["XML"].="<securityContext>";		
    $d["XML"].="<webExID>{$d["UID"]}</webExID>";
    $d["XML"].="<password>{$d["PWD"]}</password>";			
    $d["XML"].="<siteID>{$d["SID"]}</siteID>";				
    $d["XML"].="<partnerID>{$d["PID"]}</partnerID>";					
    $d["XML"].="</securityContext>";	 
    $d["XML"].="</header>";
    $d["XML"].="<body>";
    $d["XML"].="<bodyContent xsi:type=\"java:com.webex.service.binding.meeting.LstsummaryMeeting\" ";
    $d["XML"].="xmlns:meet=\"http://www.webex.com/schemas/2002/06/service/meeting\">";
    $d["XML"].="<listControl>";
    $d["XML"].="<startFrom/>";
    $d["XML"].="<maximumNum>5</maximumNum>";
    $d["XML"].="</listControl>";
    $d["XML"].="<order>";
    $d["XML"].="<orderBy>STARTTIME</orderBy>";
    $d["XML"].="</order>";
    $d["XML"].="<dateScope>";
    $d["XML"].="</dateScope>";
    $d["XML"].="</bodyContent>";
    $d["XML"].="</body>";
    $d["XML"].="</serv:message>";

    $URL = "http://{$XML_SITE}/WBXService/XMLService";
    $Result = postIt($d,$URL,$XML_PORT);

    //  Output calling user variables
    echo "<b>Calling user variables</b></br>";		
    echo "SID={$d["SID"]}<br>";
    echo "UID={$d["UID"]}<br>";
    echo "PID={$d["PID"]}<br>";
    echo "XML_SITE={$XML_SITE}<br>";
    exit;

    //
    //  postIt()
    //
    //  POSTs the XML action document and calling user variables
    //  to the specified WebEx XML Server and receives an XML response document
    //
    function postIt($DataStream, $URL, $Port) 
    {
        //  Strip http:// from the URL if present
        $URL = ereg_replace("^http://", "", $URL);

        //  Separate into Host and URI
        $Host = substr($URL, 0, strpos($URL, "/"));
        $URI = strstr($URL, "/");

        //  Form the request body
        $reqBody = "";
        while (list($key, $val) = each($DataStream)) {
            if ($reqBody) $reqBody.= "&";
            $reqBody.= $key."=".urlencode($val);
        }
        $ContentLength = strlen($reqBody);

	$xml = $DataStream['XML'];
        //  Generate the request header
      global $Debug_Mode;
      $Debug_Mode = 1;
      $URL = $Host;
      $fp = fsockopen($URL,80,$errno,$errstr);
      $Post =  "POST /WBXService/XMLService HTTP/1.0\n";
      $Post .= "Host: $URL\n";
      $Post .= "Content-Type: application/xml\n";
      $Post .= "Content-Length: ".strlen($xml)."\n\n";
      $Post .= "$xml\n";
      if($Debug_Mode){
	    echo "<hr>XML Sent:<br><textarea cols=\"50\" rows=\"25\">".htmlspecialchars($xml)."</textarea><hr>";
      }
      if($fp){
	    fwrite($fp,$Post);
	    $response = "";
	    while (!feof($fp)) {
		  $response .= fgets($fp, 1024);
	    }
	    if($Debug_Mode){
		  echo "<br>XML Received:<br><textarea cols=\"50\" rows=\"25\">".htmlspecialchars($response)."</textarea><hr>";
	    }

	    return $response;
      }
      else{
	    echo "$errstr ($errno)<br />\n";
	    return false;
      }
    }
?>

</body>
</html>

